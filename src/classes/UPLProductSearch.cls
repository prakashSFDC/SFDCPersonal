/*  
 * File Name     : UPLProductSearch
 * Description   : This class returns a list of AccountIds which are linked to a Product
 *                 which matches with the Product entered in the UPL Search page
 * @author       : Infosys Technologies Limited
 *
 * Modification Log
 * =============================================================================
 *   Ver     Date         Author          Modification
 *------------------------------------------------------------------------------
 *   1.0     23-Nov-11   Infosys       Created  
 *   
 */

public class UPLProductSearch{

    List<Product_Offered__c> AccProducts = new List<Product_Offered__c>();
    List<Id> Accid_Products = new List<Id>(); 
    String Query_Search=null;   

    public List<Id> ProductSearchLogic(List<Id> Input_Accounts,String Technology,String Product){

        Query_Search='Select Account__c from Product_Offered__c where Product_offering__c =\''+ Technology +'\' and account__c in : Input_Accounts and Publish_Flag__c = true ';

        if((Product!=null)&&(Product!='None')){
            Query_Search=Query_Search+' and Product__c =\''+ Product+'\'';
        }
        System.debug('Query Value:'+Query_Search); 
        
        //Querying Database
        AccProducts = Database.query(Query_Search+' LIMIT 10000'); 
        
        //Loop through the results add the AccountIds into the final List
        for(Product_Offered__c z:AccProducts)
        {
            Accid_Products.add(z.Account__c);
        } 
        
        //Clear the Temporary List
        if(AccProducts.size()!=null)
            AccProducts.clear();
            
            Query_Search=null; 

        //Return the final list of AccountIds
        return Accid_Products;
    } 
}