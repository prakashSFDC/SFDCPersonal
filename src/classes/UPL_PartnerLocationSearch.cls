/*  
* File Name      : UPL_PartnerLocationSearch
* Description    : This class returns accountIds for the filter criteria passed on Partner Location object                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-23    Sathish           Created  
*   
*/
 
public class UPL_PartnerLocationSearch {
    
    public static final String resellerSearch='RESELLER';
    public static final String distributorSearch='DISTRIBUTOR';
    public static final String federalSearch='FEDERAL';
    public static final String nameSearch='NAME';
    public static final String appPartnerSearch='APPLICATION';
    public static final String federalStatusIdentifier='Federal Only Location';
    public static final List<String> allFederalStatusIdentifier=new List<String>{'Federal Only Location','Federal and Non-Federal Location'};
    public static final String status_active ='Active';
    //public static final List<String> megoValues=new List<String>{'MEGO','MGO','EMEGO','MGCO'};
    public static final String Mobility='Mobility';
    public static final String RADIO='RADIO';
    public static final String WNS='WNS';
    public static final String SCADA='SCADA';
    public static final String regionLACR='LACR';
    public static final String regionNA='NAMR';
    public static final String regionEMEA='EMEA';
    public static final String regionAPAC='APAC';
    //Added by Sathish for CR 61537
    public static final List<String> uplAccountHierarchyLevel=new List<String>{'Global Account','Regional Account','Regional Subsidiary Account'};
    //Ends
    
   /**
     * This method is used to search partner location object based on search type and filter criteria
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    public List<ID> searchPartnerLocations(UPL_FilterCriteria filterCriteria,List<id> resultIds ) {
      logger('Entering searchPartnerLocations');
      System.debug(Logginglevel.FINEST, '##Scripts executed BEFORE searchPartnerLocations### : '+Limits.getScriptStatements());
      List<ID> results=null;
      StringBuffer query=new StringBuffer('SELECT ID,Account__c from Partner_Location__c WHERE Location_Publish_Flag__c = true ');
      query.append(' AND Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
      if(filterCriteria.searchType==resellerSearch || filterCriteria.searchType==distributorSearch || filterCriteria.searchType==appPartnerSearch ){
            query.append(' AND Federal_Status__c <> ').append(UPL_Utilities.getQuotedStringValue(federalStatusIdentifier));
      }else if(filterCriteria.searchType==federalSearch){
           query.append(' AND Federal_Status__c in :allFederalStatusIdentifier ');
      }
      
      if(isCounrtyFilterRequired(filterCriteria)){
         query.append(' AND Country1__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
         
      }
      
      if(filterCriteria.track!= SCADA && isNonSCADAfilterRequired(filterCriteria)){
            if(filterCriteria.track==Mobility){
                query.append(' AND Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
            }else if(filterCriteria.track==RADIO){
                query.append(' AND Account__r.PartnerStatus_Radio__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
            }else if(filterCriteria.track==WNS){
                query.append(' AND Account__r.PartnerStatus_WNS__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
            }
            
            if(filterCriteria.isMego==true){
                //query.append(' AND Account__r.MEGO_Status__c in :megoValues ');
                query.append(' AND Account__r.MEGO_Status__c !=null ');   
            }
            if((filterCriteria.selectedProgramLevel!=null && filterCriteria.selectedProgramLevel.size()>0) 
                && (filterCriteria.searchType == resellerSearch && filterCriteria.region!=regionAPAC  )    ){ // Added by Sathish for Carrier Refine Search 
                List<String> selectedProgramLevel =filterCriteria.selectedProgramLevel;
                query.append(' AND Account__r.Metal_Level__c in :selectedProgramLevel ');
            }
            
      }else if(filterCriteria.track== SCADA && (filterCriteria.searchType==resellerSearch || filterCriteria.searchType==distributorSearch) ){
          /*String partnerRegion='';
          if(filterCriteria.region==regionNA){
                partnerRegion='NAMR';
          }else if(filterCriteria.region==regionLACR){
                partnerRegion='LACR';
          }else{
                partnerRegion=filterCriteria.region;
          } */ 
           if(filterCriteria.region!=regionLACR){ // Included ST search logic for SCADA
                query.append(' AND Account__R.Partner_Region__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
          }
          query.append(' AND Account__R.PartnerStatus_SCADA__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
          query.append(' AND Account__R.Partner_Locator_Status__c= ').append(UPL_Utilities.getQuotedStringValue(status_active));
          
          // Added by Sathish for CR 61537
          query.append(' AND Account__R.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
      }
      if(filterCriteria.searchType==nameSearch){
          //query.append(' AND ( '); 
          //query.append(' Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
          //query.append(' OR Account__r.PartnerStatus_Radio__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
          //query.append(' OR Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(status_active));
          //query.append(' OR Account__R.PartnerStatus_SCADA__c= ').append(UPL_Utilities.getQuotedStringValue(status_active));
          //query.append(' )');
         // query.append(' AND Account__r.name like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName));
           if((filterCriteria.region==regionAPAC 
              || (filterCriteria.region==regionNA && filterCriteria.nameSearchInvokedFor=='NON-RADIO' )
              || (filterCriteria.region==regionEMEA && filterCriteria.nameSearchInvokedFor==resellerSearch ) )
               && filterCriteria.nameSearchInvokedFor!=SCADA
               && filterCriteria.region!=regionLACR  ){
                    query.append(' AND ( '); 
                    query.append(' Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
            
            if(!(filterCriteria.region==regionEMEA && filterCriteria.nameSearchInvokedFor==resellerSearch)){
                query.append(' OR Account__r.PartnerStatus_Radio__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
            } 
            query.append(' OR Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(status_active));
            // query.append(' OR Account__R.PartnerStatus_SCADA__c= ').append(UPL_Utilities.getQuotedStringValue(status_active));
            query.append(' )');
            query.append(' AND Country1__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
          }
          if(filterCriteria.nameSearchInvokedFor==SCADA ){
                if(filterCriteria.region!=regionLACR)
                     query.append(' AND Country1__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                
                query.append(' AND Account__R.PartnerStatus_SCADA__c= ').append(UPL_Utilities.getQuotedStringValue(status_active));
          }
      }
      if(filterCriteria.partnerName!=null){           
          query.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName));
      }
     query.append(' AND Account__R.Partner_Locator_Status__c= ').append(UPL_Utilities.getQuotedStringValue(status_active));
    
     // Added by Sathish for CR 61537
   query.append(' AND Account__R.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
     //Ends
     
      if(resultIds!=null && resultIds.size()>0){
           Set<ID> uniqueIDs=UPL_Utilities.getUniqueIds(resultIds);
           query.append(' AND Account__C in :uniqueIDs ');
      }
         
      query.append(' LIMIT 10000 ');
      
      system.debug('query---->'+query);
      
      List<Partner_Location__c> partnerLocations=Database.query(query.toStr());
      
      if(partnerLocations!=null && partnerLocations.size()>0){
        results=new List<ID>();
         logger('Size of PartnerLocations result = '+partnerLocations.size());  
        for(Partner_Location__c locations:partnerLocations){
            results.add(locations.Account__c);
        }
      }else{
        logger('NO Results');
      }
      System.debug(Logginglevel.FINEST, '##Scripts executed AFTER searchPartnerLocations### : '+Limits.getScriptStatements());
      logger('Exiting searchPartnerLocations');
      
      return results;
    }
    /**
     * This method is used check whether country filter condition is required in query.Returns in either of the conditions
     * 1.Reseller && (region <> LACR OR NOT(EMEA-RADIO) OR NOT(NA-EMEA))
     * 2.Distributor && (region <> LACR,EMEA )
     * 3.Application Partner && region <> LACR
     * @author sathish_selvaraj
     * @since 07-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param boolean
     * @return accountIds
     */
    public boolean isCounrtyFilterRequired(UPL_FilterCriteria filterCriteria){
        logger('Entering isCounrtyFilterRequired');
        
        /*if(filterCriteria.searchType== resellerSearch && ((filterCriteria.region!=regionLACR) || (filterCriteria.region==regionEMEA && filterCriteria.track!=RADIO) || (filterCriteria.region==regionNA && filterCriteria.track!=RADIO) )){
             logger('Exiting isCounrtyFilterRequired - TRUE1');
            return true;
        }else if(filterCriteria.searchType== distributorSearch && filterCriteria.region!=regionLACR && filterCriteria.region!=regionEMEA){
             logger('Exiting isCounrtyFilterRequired - TRUE2');
            return true;
        }else if(filterCriteria.searchType== appPartnerSearch && filterCriteria.region!=regionLACR){
             logger('Exiting searchPartnerLocations - TRUE3');
            return true;
        }else if(filterCriteria.searchType== nameSearch ){
             logger('Exiting searchPartnerLocations - TRUE4');
            return true;
        }else if(filterCriteria.searchType== federalSearch && filterCriteria.country!=null ){
             logger('Exiting searchPartnerLocations - TRUE5');
            return true;
        }*/
        
        if(filterCriteria.searchType== federalSearch && filterCriteria.country!=null){
             logger('Exiting isCounrtyFilterRequired - TRUE');
             return true;
        //}else if(filterCriteria.searchType== nameSearch ){ // Temporarily Added
             //logger('Exiting searchPartnerLocations - TRUE4');
            //return true;
        }else if(filterCriteria.region==regionNA && 
            ((filterCriteria.searchType== resellerSearch &&  filterCriteria.track!=RADIO) 
             || filterCriteria.searchType== distributorSearch 
             || filterCriteria.searchType== appPartnerSearch 
             || (filterCriteria.searchType==nameSearch && filterCriteria.nameSearchInvokedFor=='NON-RADIO' ) )){
             logger('Exiting isCounrtyFilterRequired - TRUE');
             return true;
        }else if(filterCriteria.region==regionAPAC &&
            (filterCriteria.searchType== resellerSearch || filterCriteria.searchType== distributorSearch || filterCriteria.searchType== appPartnerSearch || filterCriteria.searchType==nameSearch)){
             logger('Exiting isCounrtyFilterRequired - TRUE');
             return true;
        }else if(filterCriteria.region==regionEMEA){ // For EMEA Name search , will be handled separately
            if(filterCriteria.searchType== appPartnerSearch){
                logger('Exiting isCounrtyFilterRequired - TRUE');
                return true;
            }else if(filterCriteria.searchType== resellerSearch &&  filterCriteria.track!=RADIO){
                logger('Exiting isCounrtyFilterRequired - TRUE');
                return true;
            }else if(filterCriteria.searchType== distributorSearch &&  filterCriteria.track==SCADA){
                logger('Exiting isCounrtyFilterRequired - TRUE');
                return true;
            
            }
        }
        
        logger('Exiting isCounrtyFilterRequired');
        return false;
        
    }
     /**
     * For track <> SCADA , certain filter condition is amended in query based on region-track combination which is checked in this method.
     * 1.Reseller && region <> LACR
     * 2.Distributor && region <> LACR && EMEA
     * 3.Application Partner  && region <> LACR  
     * @author sathish_selvaraj
     * @since 07-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param boolean
     * @return accountIds
     */ 
    private boolean isNonSCADAfilterRequired(UPL_FilterCriteria filterCriteria){
        logger('Entering isNonSCADAfilterRequired');
        if(filterCriteria.searchType== resellerSearch && filterCriteria.region!=regionLACR){
            logger('Exiting isNonSCADAfilterRequired');
            return true;
        }else if(filterCriteria.searchType== distributorSearch && filterCriteria.region!=regionLACR && filterCriteria.region!=regionEMEA ){
            logger('Exiting isNonSCADAfilterRequired');
            return true;
        }else if(filterCriteria.searchType==appPartnerSearch && filterCriteria.region!=regionLACR){
            logger('Exiting isNonSCADAfilterRequired');
            return true;
        }
        logger('Exiting isNonSCADAfilterRequired');
        return false;
    }
   /**
     * This method is used to print logs
     * to condition is detailed in code comments.
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     *
     */
     
    private void  logger (String message ) {
        System.debug(message);
    }
}