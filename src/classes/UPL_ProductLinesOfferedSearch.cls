/*  
* File Name      : UPL_ProductLinesOfferedSearch
* Description    : This class will query ProductLinesOffered object.                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     16-Oct-12    Sathish           Created  
*   
*/
public class UPL_ProductLinesOfferedSearch{
     /**
     * This method is used to search ProductLines Offered  object based on search type and filter criteria
     * @author Sathish
     * @since 16-Oct-2012
     * @param filterCriteria- contains all user filter criteria
     * @param resultIds - List of AccountIds from pre-searched object
     * @return accountIds
     */
     public List<ID> searchProductLinesOffered(UPL_FilterCriteria filterCriteria,List<id> resultIds ) {
          logger('Entering searchProductLinesOffered');
          List<ID> productLinesOfferedAccounts=null;
          
          StringBuffer searchQuery= new StringBuffer('Select ID, Account__c from Product_Offered__c where Publish_Flag__c=true ');  
          searchQuery.append('  AND Product_offering__c = ').append(UPL_Utilities.getQuotedStringValue(filterCriteria.technology));
          searchQuery.append('  AND Account__C in :resultIds ');   
          searchQuery.append(' LIMIT 10000');
          List<Product_Offered__c> productLinesResults=Database.query(searchQuery.toStr());
          
           if(productLinesResults!=null && productLinesResults.size()>0){
                 productLinesOfferedAccounts=new List<ID>();
                 for(Product_Offered__c ploRecord:productLinesResults){
                    productLinesOfferedAccounts.add(ploRecord.Account__c);
                 }
                  logger('Size of productLinesResultsresult = '+productLinesResults.size());  
             } else {
                logger('NO RESULT');
              }   
          logger('Entering searchProductLinesOffered');
          return productLinesOfferedAccounts;
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