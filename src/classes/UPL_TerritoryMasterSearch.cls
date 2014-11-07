/*  
* File Name      : UPL_TerritoryMasterSearch
* Description    : This class returns accountIds for the filter criteria passed on  Territory Master object                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-23    Sathish           Created  
*   
*/

public class UPL_TerritoryMasterSearch{
   /**
     * This method is used to search Territory Master object based on search type and filter criteria
     * @author sathish_selvaraj
     * @since 03-Sep-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
    public List<String> searchTerritoryMasters(UPL_FilterCriteria filterCriteria ) {
      logger('Entering searchTerritoryMasters');
      System.debug(Logginglevel.FINEST, '### Scripts Executed BEFORE searchTerritoryMasters ###'+Limits.getScriptStatements());
      List<String> territoryCode=null;
      StringBuffer query=new StringBuffer('select ID,Territory_Code__c from Territory_Master__c where ');
      // and country__c =filterCriteria
      //query.append(' Account__r.RecordTypeId= ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.recordTypeID));
      query.append(' country__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.country));  
      if(filterCriteria.location!=null){
        String[] locationArray=null;  
        locationArray = filterCriteria.location.split(',');
        if(locationArray!=null ){ 
            for(Integer i=0;i<locationArray.size();i++){
                if(locationArray[i]!=null ){
                    locationArray[i]=locationArray[i].trim().replaceAll('^+(?!$)', '');
                        query.append(' AND CityStateZip__c like ').append(UPL_Utilities.getQuotedWildCardStringValue(','+locationArray[i]+','));
                    }
                }
            } 
                
        }
        query.append(' limit 20000'); 
        
        logger('Territory master query -->' + query.toStr() );
        List<Territory_Master__c> territoryMaster=Database.query(query.toStr());
        
        if(territoryMaster!=null && territoryMaster.size()>0){
            territoryCode=new List<String>();
            for(Territory_Master__c master:territoryMaster){
                territoryCode.add(master.Territory_Code__c);
            }
            logger('The size of territoryMaster = : '+territoryMaster.size());
        }else{
            logger('No results ');
        }
        System.debug(Logginglevel.FINEST, '### Scripts Executed AFTER searchTerritoryMasters ###'+Limits.getScriptStatements());

        logger('Exiting searchTerritoryMasters');
        return territoryCode;
            
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