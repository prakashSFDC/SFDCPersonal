/*  
* File Name      : UPL_ProgramInformationSearch
* Description    : This class returns accountIds for the filter criteria passed on Program Information object                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-12    Sathish           Created  
*   
*/


public class UPL_ProgramInformationSearch{
    public static final String resellerSearch='RESELLER';
    public static final String distributorSearch='DISTRIBUTOR';
    public static final String federalSearch='FEDERAL';
    public static final String nameSearch='NAME';
    public static final String regionEMEA='EMEA';
    public static final String Ind_Software_Vendor='Ind Software Vendor';
    public static final String Mobility='Mobility';
    public static final String RADIO='RADIO';
    public static final String WNS='WNS';
    public static final String SCADA='SCADA';
    public static final String booleanTrue='true';
    public static final String status_active ='Active';
    public static final List<String> us_federal_status =new List<String>{'Authorized','Specialist','Elite Specialist'};
    
    // Added by Sathish for CR 61537
  public static final List<String> uplAccountHierarchyLevel=new List<String>{'Global Account','Regional Account','Regional Subsidiary Account'};
  //Ends
    
   /**
     * This method is used to search Program Information object based on search type and filter criteria
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    public List<ID> searchProgramInformations(UPL_FilterCriteria filterCriteria,List<id> resultIds ) {
      logger('Entering searchProgramInformations');
      System.debug(Logginglevel.FINEST, '### Scripts Executed BEFORE searchProgramInformations ###'+Limits.getScriptStatements());
      List<ID> programInformationAccounts=null;
      StringBuffer query= new StringBuffer(' SELECT ID,Account__c FROM Partner_Type__c  ');  
      query.append(' WHERE Status__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
      query.append(' AND Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
      if(filterCriteria.searchType==resellerSearch || filterCriteria.searchType==distributorSearch ){
         query.append(' AND Program__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.track));
      }
      if((filterCriteria.searchType==resellerSearch || filterCriteria.searchType==distributorSearch) && filterCriteria.track !=SCADA && filterCriteria.isAuthorizedServiceCentre==true ){
         query.append(' AND Authorized_Service_Center__c = ').append('true');
      }
      
      if(filterCriteria.searchType==resellerSearch && filterCriteria.track ==SCADA  ){
         query.append(' AND Partner_Track__c <> ').append(UPL_Utilities.getQuotedStringValue(distributorSearch));
         query.append(' AND Partner_Track__c <> ').append(UPL_Utilities.getQuotedStringValue(Ind_Software_Vendor));
      }else if(filterCriteria.searchType==distributorSearch && filterCriteria.track ==SCADA  ){
         query.append(' AND Partner_Track__c = ').append(UPL_Utilities.getQuotedStringValue(distributorSearch));
      }
       
      if(filterCriteria.searchType==federalSearch){ 
        query.append(' AND US_Federal_Specialization__c in :us_federal_status ');
        //query.append(' AND Account__r.Partner_Locator_Status__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
        
        if(filterCriteria.track==Mobility){
             query.append(' AND Account__r.Partner_Status_Mobility__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
        }else if(filterCriteria.track==RADIO){
             query.append(' AND Account__r.PartnerStatus_Radio__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
        }else if(filterCriteria.track==WNS){
             query.append(' AND Account__r.PartnerStatus_WNS__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
        }
      }
      if(filterCriteria.searchType==nameSearch){
            query.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName));
            if(filterCriteria.region==regionEMEA){
                query.append(' AND Program__c in ( ').append(UPL_Utilities.getQuotedStringValue(RADIO)).append(',').append(UPL_Utilities.getQuotedStringValue(SCADA)).append(' )');
            }else{
                query.append(' AND Program__c = ').append(UPL_Utilities.getQuotedStringValue(SCADA));
            }
      }
      if(filterCriteria.partnerName !=null && filterCriteria.searchType!=nameSearch){
        query.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName));
      }
      query.append(' AND Account__r.Partner_Locator_Status__c = ').append(UPL_Utilities.getQuotedStringValue(status_active));
      
      // Added by Sathish for CR 61537
    query.append(' AND Account__r.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
      //Ends
      
       if(resultIds!=null && resultIds.size()>0){
           Set<ID> uniqueIDs=UPL_Utilities.getUniqueIds(resultIds);
           query.append(' AND Account__C in :uniqueIDs ');
      }
      
      query.append(' LIMIT 10000 ');
      
      List<Partner_Type__c> programInformationResult=Database.query(query.toStr());
      
      if(programInformationResult!=null && programInformationResult.size()>0){
         programInformationAccounts=new List<ID>();
         for(Partner_Type__c piRecord:programInformationResult){
            programInformationAccounts.add(piRecord.Account__c);
         }
          logger('Size of ProgramInformation result = '+programInformationAccounts.size());  
      } else {
        logger('NO RESULT');
      }   
         
      System.debug(Logginglevel.FINEST, '### Scripts Executed AFTER searchProgramInformations ###'+Limits.getScriptStatements());

      logger('Exiting searchProgramInformations');
      
      return programInformationAccounts;
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