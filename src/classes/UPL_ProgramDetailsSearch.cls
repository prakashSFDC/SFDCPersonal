/*  
* File Name      : UPL_ProgramDetailsSearch
* Description    : This class returns accountIds for the filter criteria passed on Program detail object                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-12    Sathish           Created  
*   1.1     04-Sep-12    Nimesh            Added Code for searchProgramDetails method
*                                          Declared required Private variables  
*   1.2     17-Oct-12    Sathish           Multi-select picklist query syntax updated 
*   
*/

public class UPL_ProgramDetailsSearch{

    // List of communities 
    private List<String> resellerNonCarrierCommunities = new List<String>{'Value Added Reseller','Direct Market Reseller','eTailer'};
    private List<String> distributorCommunities = new List<String>{'Value Added Distributor','Sub-Distributor'};
   // private List<String> federalCommunities = new List<String>{'Value Added Reseller','eTailer','Direct Market Reseller','Application Partner','Carrier'};
    private List<String> federalCommunities = new List<String>{'Value Added Reseller','eTailer','Direct Market Reseller'};
    private List<String> applicationCommunities = new List<String>{'Application Partner'};
    //private List<String> nameCommunities = new List<String>{'Application Partner','Value Added Reseller','Direct Market Reseller','eTailer','Value Added Distributor','Sub-Distributor','Carrier'};
    
    public static List<String> nonEmeaNameCommunities=new List<String>{'Application Partner','Value Added Reseller','Direct Market Reseller','eTailer','Value Added Distributor','Sub-Distributor','Carrier'};
    public static List<String> emeaNonRadioNameDistributorCommunities=new List<String>{'Value Added Distributor','Sub-Distributor'};
    public static List<String> emeaNonRadioNameResellerCommunities=new List<String>{'Application Partner','Value Added Reseller','Direct Market Reseller','eTailer','Carrier'};

    private String  carrierCommunity='Carrier';
    
    //types of search
    private String resellerSearch ='RESELLER';
    private String distributorSearch ='DISTRIBUTOR';
    public String federalSearch ='FEDERAL';
    private String applicationSearch ='APPLICATION';
    private String nameSearch ='NAME';
    
    // other private variables
    //private String regionLACR = 'Latin America';
    //private String regionNAMR = 'North America';
    private String regionLACR = 'LACR';
    private String regionNAMR = 'NAMR';
    private String regionEMEA = 'EMEA';
    private String regionAPAC = 'APAC';
    private String trackMobility = 'Mobility';
    private String trackWNS = 'WNS';
    private String trackRadio = 'RADIO';
    private String strActive = 'Active';
    
    //private List<String> allNAMRCountries = new List<String>{'All NAMR Countries'};
    //private List<String> allLACRCountries = new List<String>{'All LACR Countries'};
    //private List<String> allAPACCountries = new List<String>{'All APAC Countries'};
    //private List<String> allEMEACountries = new List<String>{'All EMEA Countries'};
    
    private String allNAMRCountries = 'All NAMR Countries';
    private String allLACRCountries = 'All LACR Countries';
    private String allAPACCountries = 'All APAC Countries';
    private String allEMEACountries = 'All EMEA Countries';    
    
    // Added by Sathish for CR 61537
  public static final List<String> uplAccountHierarchyLevel=new List<String>{'Global Account','Regional Account','Regional Subsidiary Account'};
  //Ends
     
    /**
     * This method is used to search Program detail object based on search type and filter criteria
     * @author nimesh_sharma
     * @since 04-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
     
    public List<ID> searchProgramDetails(UPL_FilterCriteria filterCriteria,List<id> resultIds ) {
      logger('Entering searchProgramDetails');
      System.debug(Logginglevel.FINEST, '### Scripts Executed BEFORE searchProgramDetails ###'+Limits.getScriptStatements());
      List<ID> programDetailAccounts=null;
      List<Technology_Specialization__c> programDetailNonCarrierResults =  new List<Technology_Specialization__c>();
      List<Technology_Specialization__c> programDetailCarrierResults =  new List<Technology_Specialization__c>();
      List<Technology_Specialization__c> finalProgramDetailResults =  new List<Technology_Specialization__c>();
       
        
       
       // execute the query for Non-Carrier community
       programDetailNonCarrierResults = constructNonCarrierQuery(filterCriteria,resultIds);
      
       if(filterCriteria.searchType == resellerSearch ){
        
           boolean isCarrierNeeded=false;
           boolean isCarrierSplSelected=false;
           boolean isCarrierProgramSelected=false;
           
           if(filterCriteria.technologySpecialization==null ||
            (filterCriteria.technologySpecialization!=null && 
             (filterCriteria.technologySpecialization.size()==1 && filterCriteria.technologySpecialization.get(0)=='Elite Specialist') 
             || filterCriteria.technologySpecialization.size()==2 )){
                isCarrierSplSelected=true;
           }
           
           
             if(filterCriteria.selectedProgramLevel!=null && filterCriteria.selectedProgramLevel.size()>0){
                for(String program:filterCriteria.selectedProgramLevel){
                    if((filterCriteria.region==regionAPAC || filterCriteria.region==regionNAMR ||filterCriteria.region==regionLACR ) && program=='Gold'  ){
                        isCarrierProgramSelected=true;
                    }
                    if(filterCriteria.region==regionEMEA && program=='Authorized' ){
                        isCarrierProgramSelected=true; // This block wont be executed becuase only for APAC pregram filter present in screen
                    }
                }
                
             }
            
            if((isCarrierSplSelected && filterCriteria.selectedProgramLevel==null) || (isCarrierSplSelected && isCarrierProgramSelected)){
                  programDetailCarrierResults =  constructCarrierQuery(filterCriteria,resultIds); 
            }
       }
     
      if(programDetailNonCarrierResults!=null && programDetailNonCarrierResults.size()>0){
            finalProgramDetailResults.addAll(programDetailNonCarrierResults);
      }
      if(programDetailCarrierResults!=null && programDetailCarrierResults.size()>0){
            finalProgramDetailResults.addAll(programDetailCarrierResults);
      }
      // check if the result obtained list has data, else 
      if(finalProgramDetailResults!=null && finalProgramDetailResults.size()>0){
         programDetailAccounts=new List<ID>();
         for(Technology_Specialization__c pdRecord:finalProgramDetailResults){
            programDetailAccounts.add(pdRecord.Account__c);
         }
          logger('Size of Program Details Result = '+programDetailAccounts.size());  
      }else {
        logger('NO RESULT');
      } 
      System.debug(Logginglevel.FINEST, '### Scripts Executed AFTER searchProgramDetails ###'+Limits.getScriptStatements());
      logger('Exiting searchProgramDetails');
      return programDetailAccounts;
    }
    /**
     * This method is used to search Program detail object for Non-carrier community. Non-Carrier community will havet
     * any technology specialization level associated to selected technology. So the query WILL HAVE the same in filter conditions
     * @author Sathish
     * @since 10-Oct-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    private List<Technology_Specialization__c> constructNonCarrierQuery(UPL_FilterCriteria filterCriteria,List<id> resultIds){
          Set<ID> uniqueIDs=new Set<ID>();
          
         
         StringBuffer searchQuery= new StringBuffer('Select ID, Account__c, Account__r.name from Technology_Specialization__c ');     
      
               //Community check for all the types of search 
              if (filterCriteria.searchType == resellerSearch ){
                searchQuery.append(' WHERE Community_Type__c IN :resellerNonCarrierCommunities');
              }else if (filterCriteria.searchType == distributorSearch ){
                searchQuery.append(' WHERE Community_Type__c IN :distributorCommunities');
              }else if (filterCriteria.searchType == federalSearch ){
                searchQuery.append(' WHERE Community_Type__c IN :federalCommunities');
              }else if (filterCriteria.searchType == applicationSearch ){
                searchQuery.append(' WHERE Community_Type__c IN :applicationCommunities');
              }else if (filterCriteria.searchType == nameSearch ){
                //searchQuery.append(' WHERE Community_Type__c IN :nameCommunities');
                if(filterCriteria.region!=regionEMEA){
                      searchQuery.append(' WHERE Community_Type__c IN :nonEmeaNameCommunities');
                }else if(filterCriteria.region==regionEMEA  ){
                    
                     if(filterCriteria.nameSearchInvokedFor!=null && filterCriteria.nameSearchInvokedFor==distributorSearch){
                         searchQuery.append(' WHERE Community_Type__c IN :emeaNonRadioNameDistributorCommunities');
                         searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
                         allEMEACountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allEMEACountries)).append(' )');
                         searchQuery.append(' AND ( '); 
                         searchQuery.append(' Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(strActive));
                         searchQuery.append(' OR Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                         searchQuery.append(' )');
                         
                     }
                            
                     if(filterCriteria.nameSearchInvokedFor!=null && filterCriteria.nameSearchInvokedFor==resellerSearch){
                         searchQuery.append(' WHERE Community_Type__c IN :emeaNonRadioNameResellerCommunities');
                         //searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                     }
                     
                }
                if(filterCriteria.region==regionLACR){
                          searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
                          allLACRCountries+='\',\''+filterCriteria.country;
                          searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allLACRCountries)).append(' )');
                          searchQuery.append(' AND ( '); 
                          searchQuery.append(' Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(strActive));
                          searchQuery.append(' OR Account__r.PartnerStatus_Radio__c = ').append(UPL_Utilities.getQuotedStringValue(strActive));
                          searchQuery.append(' OR Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                          searchQuery.append(' )');
                }
              }
              searchQuery.append(' AND Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
              searchQuery.append(' AND Account__r.Partner_Locator_Status__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
              
              // Added by Sathish for CR 61537
        searchQuery.append(' AND Account__r.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
        //Ends
         
              // check for technology specialization level conditions and make sure the selected technology is a part of result
              searchQuery.append(' AND Technology_Specialization_Level__c <> '+UPL_Utilities.getQuotedStringValue('Open'));
              // added by nimesh for issue highlighted by Palani
              searchQuery.append(' AND Technology_Specialization_Level__c <> null ');
              // check for the selected technology for all types of searches except name search
              if (filterCriteria.searchType != nameSearch  ){
                  searchQuery.append(' AND Technology_Specialization__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.technology));  
              }
              
              // check for the selected technology specialisation for only reseller search
              if(!UPL_Utilities.isListEmpty(filterCriteria.technologySpecialization) && filterCriteria.searchType == resellerSearch){
                    List<String> technologySpecialization=filterCriteria.technologySpecialization;
                    logger('chkNimsi --> ' +technologySpecialization);
                    searchQuery.append(' AND Technology_Specialization_Level__c IN :technologySpecialization '); 
              }
              
              // Query for region selected for Reseller, Distributor and Application searches only
              // Federal and Name search will not use the results based on region
              
              if ( ((filterCriteria.searchType == resellerSearch || filterCriteria.searchType == applicationSearch || filterCriteria.searchType == distributorSearch) && filterCriteria.region == regionLACR)
                  ||(filterCriteria.searchType == distributorSearch && filterCriteria.region == regionEMEA))         
              {
                      // fetch results on region
                      searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
                      // fetch results on country
                      //searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                      if (filterCriteria.region == regionEMEA && filterCriteria.country != null){
                         //allEMEACountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allEMEACountries '); 
                         allEMEACountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allEMEACountries)).append(' )');
                          
                      }else if (filterCriteria.region == regionNAMR && filterCriteria.country != null){
                         //allNAMRCountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allNAMRCountries ');   
                         allNAMRCountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allNAMRCountries)).append(' )');  
                      }else if (filterCriteria.region == regionLACR && filterCriteria.country != null){
                         //allLACRCountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allLACRCountries ');
                         allLACRCountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allLACRCountries)).append(' )');      
                      }else if (filterCriteria.region == regionAPAC && filterCriteria.country != null){
                         //allAPACCountries.add(filterCriteria.country);   
                         //searchQuery.append(' AND Country__c in : allAPACCountries ');
                         allAPACCountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allAPACCountries)).append(' )');
                      }else{
                         searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                      }
                      
                      
                      // add account related fields to the query
                      if(filterCriteria.track == trackMobility){
                        searchQuery.append(' AND Account__r.Partner_Status_Mobility__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }else  if(filterCriteria.track == trackRadio){
                        searchQuery.append(' AND Account__r.PartnerStatus_Radio__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }else if(filterCriteria.track == trackWNS){ 
                        searchQuery.append(' AND Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }
                      
                      if(!UPL_Utilities.isStringNull(filterCriteria.partnerName)){
                        searchQuery.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName)); 
                      }
                            
              }
              
              if(filterCriteria.selectedProgramLevel!=null && filterCriteria.selectedProgramLevel.size()>0){
                List<String> selectedProgramLevel =filterCriteria.selectedProgramLevel;
                searchQuery.append(' AND Account__r.Metal_Level__c in :selectedProgramLevel ');
            } 
               
               if(resultIds!=null && resultIds.size()>0){
                     uniqueIDs=UPL_Utilities.getUniqueIds(resultIds);
                     searchQuery.append(' AND Account__C in :uniqueIDs LIMIT 10000');
                
                }
             
              logger('Non-Carrier Query'+searchQuery.toStr());
              
         return Database.query(searchQuery.toStr());
    
    }
   
    /**
     * This method is used to search Program detail object for carrier community. Carrier community by nature does not
     * any technology specialization associated. So the query will not have the same in filter conditions
     * @author Sathish
     * @since 10-Oct-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    
    private List<Technology_Specialization__c> constructCarrierQuery(UPL_FilterCriteria filterCriteria,List<id> resultIds){
        
         Set<ID> uniqueIDs=new Set<ID>();
         StringBuffer searchQuery= new StringBuffer('Select ID, Account__c, Account__r.name from Technology_Specialization__c  ');     
      
               //Community check for all the types of search 
       
              searchQuery.append(' WHERE Community_Type__c = ').append(UPL_Utilities.getQuotedStringValue(carrierCommunity));  
              searchQuery.append(' AND Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
              searchQuery.append(' AND Account__r.Partner_Locator_Status__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
              
              // Added by Sathish for CR 61537
        searchQuery.append(' AND Account__r.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
        //Ends
              
              // check for technology specialization level conditions and make sure the selected technology is a part of result
              searchQuery.append(' AND Technology_Specialization_Level__c <> '+UPL_Utilities.getQuotedStringValue('Open'));
 
              // check for the selected technology for all types of searches except name search
              if (filterCriteria.searchType != nameSearch  ){
                  searchQuery.append(' AND Technology_Specialization__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.technology));  
              }
              
              
              // Query for region selected for Reseller, Distributor and Application searches only
              // Federal and Name search will not use the results based on region
              
              if ( ((filterCriteria.searchType == resellerSearch || filterCriteria.searchType == applicationSearch || filterCriteria.searchType == distributorSearch) && filterCriteria.region == regionLACR)
                  ||(filterCriteria.searchType == distributorSearch && filterCriteria.region == regionEMEA))         
              {
                      // fetch results on region
                      searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
                      // fetch results on country
                      //searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                      if (filterCriteria.region == regionEMEA && filterCriteria.country != null){
                         //allEMEACountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allEMEACountries ');     
                          allEMEACountries+='\',\''+filterCriteria.country;
                          searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allEMEACountries)).append(' )');
                      }else if (filterCriteria.region == regionNAMR && filterCriteria.country != null){
                         //allNAMRCountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allNAMRCountries ');   
                          allNAMRCountries+='\',\''+filterCriteria.country;
                          searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allNAMRCountries)).append(' )');    
                      }else if (filterCriteria.region == regionLACR && filterCriteria.country != null){
                         //allLACRCountries.add(filterCriteria.country);
                         //searchQuery.append(' AND Country__c in : allLACRCountries ');     
                          allLACRCountries+='\',\''+filterCriteria.country;
                          searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allLACRCountries)).append(' )');    
                      }else if (filterCriteria.region == regionAPAC && filterCriteria.country != null){
                         //allAPACCountries.add(filterCriteria.country);   
                         //searchQuery.append(' AND Country__c in : allAPACCountries ');
                         allAPACCountries+='\',\''+filterCriteria.country;
                         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allAPACCountries)).append(' )');
                      }else{
                         searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
                      }
                      
                      
                      // add account related fields to the query
                      if(filterCriteria.track == trackMobility){
                        searchQuery.append(' AND Account__r.Partner_Status_Mobility__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }else  if(filterCriteria.track == trackRadio){
                        searchQuery.append(' AND Account__r.PartnerStatus_Radio__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }else if(filterCriteria.track == trackWNS){ 
                        searchQuery.append(' AND Account__r.PartnerStatus_WNS__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
                      }
                      
                      if(!UPL_Utilities.isStringNull(filterCriteria.partnerName)){
                        searchQuery.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName)); 
                      }
                            
              } 
              
              if(resultIds!=null && resultIds.size()>0){
                     uniqueIDs=UPL_Utilities.getUniqueIds(resultIds);
                     searchQuery.append(' AND Account__C in :uniqueIDs LIMIT 10000');
                
                }
             // searchQuery.append(' LIMIT 10000');
              logger('Carrier Query'+searchQuery.toStr());
              
         return Database.query(searchQuery.toStr());
    }
    
   /**
     * This method is used to print logs
     * to condition is detailed in code comments.
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     *
     */
    private void logger (String message ) {
        System.debug(message);
    }
}