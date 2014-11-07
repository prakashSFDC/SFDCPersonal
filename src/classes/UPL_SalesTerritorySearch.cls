/*  
* File Name      : UPL_SalesTerritorySearch
* Description    : This class returns accountIds for the filter criteria passed on  Sales Territory object                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-23    Sathish           Created  
*   1.1     10-Sep-12    Nimesh            Added Code for searchsalesTerritories method
                                           Declared required Private variables
*   1.2     10-Oct-12    Nimesh            Changed Sales Territory query syntax for technology multi select pick list
*   1.3     10-Oct-12    Sathish           Commented the additional county filter condition in query
*/

public class UPL_SalesTerritorySearch{
   
    private List<String> resellerCommunities = new List<String>{'Value Added Reseller','Direct Market Reseller','eTailer','Carrier'};
    private String strActive = 'Active';
    private String resellerSearch ='RESELLER';
    private String distributorSearch ='DISTRIBUTOR';
    private String nameSearch ='NAME';
    private String trackRadio = 'RADIO';
    private String trackSCADA = 'SCADA';
    private String regionNAMR = 'NAMR';
    private String regionEMEA = 'EMEA';
    private String regionAPAC = 'APAC';
    private String regionLACR = 'LACR';
    private String allNAMRCountries = 'All NAMR Countries';
    private String allLACRCountries = 'All LACR Countries';
    private String allAPACCountries = 'All APAC Countries';
    private String allEMEACountries = 'All EMEA Countries';     
    
    // Added by Sathish for CR 61537
  public static final List<String> uplAccountHierarchyLevel=new List<String>{'Global Account','Regional Account','Regional Subsidiary Account'};
  //Ends
    
   /**
     * This method is used to search Sales Territory object based on search type and filter criteria
     * @author nimesh_sharma
     * @since 10-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    public List<ID> searchsalesTerritories(UPL_FilterCriteria filterCriteria,List<id> resultIds ) {
      logger('Entering searchsalesTerritories');
      System.debug(Logginglevel.FINEST, '### Scripts Executed BEFORE  searchsalesTerritories ###'+Limits.getScriptStatements());
      List<ID> searchTerritoriesAccounts=null;
      List<Sales_Territory__c> salesTerritoryResults = new List<Sales_Territory__c>();
      List<String> territoryMasterCodes= new List<String>();
      String can='Canada';
      StringBuffer searchQuery= new StringBuffer('Select ID, Account__c, Account__r.name from Sales_Territory__c WHERE '); 
      
      searchQuery.append(' Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
      // check for the selected technology 
      //searchQuery.append(' WHERE Technology_Segment__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.technology)); 
       if(filterCriteria.searchType !=nameSearch){
              searchQuery.append(' AND Technology_Segment__c includes ( ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.technology)).append(' )');
       }
      
      
     
      
      // fetch results on country
      //searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country)); Commented by Sathish   
      if (filterCriteria.region == regionEMEA && filterCriteria.country != null){
         allEMEACountries+='\',\''+filterCriteria.country;
         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allEMEACountries)).append(' )');
      }else if (filterCriteria.region == regionNAMR && filterCriteria.country != null){
         allNAMRCountries+='\',\''+filterCriteria.country;
         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allNAMRCountries)).append(' )');
      }else if (filterCriteria.region == regionLACR && filterCriteria.country != null){
         allLACRCountries+='\',\''+filterCriteria.country;
         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allLACRCountries)).append(' )');
      }else if (filterCriteria.region == regionAPAC && filterCriteria.country != null){
         allAPACCountries+='\',\''+filterCriteria.country;
         searchQuery.append(' AND Country__c includes ( ').append(UPL_Utilities.getQuotedStringValue(allAPACCountries)).append(' )');
      }else{
         searchQuery.append(' AND Country__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));
      }
       
      
      
       // Added by Sathish Starts // Included ST search logic for SCADA
      if(filterCriteria.track==trackRadio || (filterCriteria.searchType==nameSearch && filterCriteria.region == regionEMEA )){
          // fetch results for RadioTrackStatus true 
          searchQuery.append(' AND Account__r.PartnerStatus_Radio__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
      }
      if(filterCriteria.track== trackSCADA && (filterCriteria.searchType== resellerSearch || filterCriteria.searchType== distributorSearch)){
          searchQuery.append(' AND Account__R.PartnerStatus_SCADA__c = ').append(UPL_Utilities.getQuotedStringValue(strActive));
      }
    
      // Added by Sathish Ends // Included ST search logic for SCADA
          
      // check if partner name is not null and if not, search for accounts with partner name
      if(!UPL_Utilities.isStringNull(filterCriteria.partnerName)){
                    searchQuery.append(' AND Account__r.PartnerName__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(filterCriteria.partnerName)); 
      }
      
      searchQuery.append(' AND Account__r.Partner_Locator_Status__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
      
      // Added by Sathish for CR 61537
    searchQuery.append(' AND Account__r.Hierarchy_Placement__c in :uplAccountHierarchyLevel ');
    //Ends
   
      // Included ST search logic for SCADA
       if (filterCriteria.searchType == resellerSearch || filterCriteria.searchType == distributorSearch){
             if ((filterCriteria.region == regionEMEA && filterCriteria.track == trackRadio) || (filterCriteria.region == regionLACR && filterCriteria.track == trackSCADA) ){
                      searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
                }
       }
     // Included ST search logic for SCADA
      
      // check for Region North America and Track RADIO
      
      if(filterCriteria.searchType==nameSearch && filterCriteria.region == regionNAMR && filterCriteria.nameSearchInvokedFor==trackRadio){
             searchQuery.append(' AND Region__c =').append(UPL_Utilities.getQuotedStringValue(filterCriteria.region));
             searchQuery.append(' AND Account__r.PartnerStatus_Radio__c =').append(UPL_Utilities.getQuotedStringValue(strActive));
             searchQuery.append(' AND Community__c IN :resellerCommunities');
       }
       
      if (filterCriteria.region == regionNAMR && filterCriteria.track == trackRadio){
        if (filterCriteria.searchType == resellerSearch){
            searchQuery.append(' AND Community__c IN :resellerCommunities');
            
            // fetch the territory master codes from the territory search class
            if((filterCriteria.country.toUpperCase()!='CANADA') || (filterCriteria.country.toUpperCase()=='CANADA' && filterCriteria.nameSearchInvokedFor=='CANADA' ) ){
                 territoryMasterCodes = new UPL_TerritoryMasterSearch().searchTerritoryMasters(filterCriteria);
                    if(territoryMasterCodes==null)
                        return null;
                        //territoryMasterCodes= new List<String>(); 
                    searchQuery.append(' AND Territory_Code__c IN :territoryMasterCodes');
            }
           
           if(filterCriteria.country.toUpperCase()=='CANADA' && filterCriteria.territoryCodes!=null && filterCriteria.territoryCodes.size()>0 ){
               List<String> territoryCodes= filterCriteria.territoryCodes;
               searchQuery.append(' AND Territory_Code__c IN :territoryCodes ');
           }            
        }
      }
      
      searchQuery.append(' LIMIT 10000');
      logger('Querry : : '+searchQuery);
      
      // execute the query
      salesTerritoryResults =  Database.query (searchQuery.toStr()); 
      
      
      // check if the result obtained list has data, else 
      if(salesTerritoryResults!=null && salesTerritoryResults.size()>0){
         searchTerritoriesAccounts=new List<ID>();
         for(Sales_Territory__c stRecord:salesTerritoryResults){
            searchTerritoriesAccounts.add(stRecord.Account__c);
         }
          logger('Size of Sales Territories Result = '+searchTerritoriesAccounts.size());  
      }else {
        logger('NO RESULT');
      } 
      System.debug(Logginglevel.FINEST, '### Scripts Executed AFTER searchsalesTerritories ###'+Limits.getScriptStatements());

      logger('Exiting searchsalesTerritories');
      
      return searchTerritoriesAccounts;
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