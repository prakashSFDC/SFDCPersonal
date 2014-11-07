/*  
 * File Name     : UPLTechnologySearch
 * Description   : This class returns a list of AccountIds which are linked to the Technology Specialization
 *                 corresponding to the Technology selected in the UPL Search page
 * @author       : Infosys Technologies Limited
 *
 * Modification Log
 * =============================================================================
 *   Ver     Date         Author       Modification     Reason
 *------------------------------------------------------------------------------
 *   1.0     30-Nov-11   Infosys       Created  
 *   2.0     04-Apr-12   Infosys       Modified         UPL 1.2 Federal Change
 *   
 */

public class UPLTechnologySearch{

    List<Technology_Specialization__c> Tech_Accs = new List<Technology_Specialization__c>();
    List<Id> Accid_Technology = new List<Id>(); 
    List<String> resellerCommunities = new List<String>{'Value Added Reseller','Dealer','Direct Market Reseller','eTailer'};
    List<String> distributorCommunities = new List<String>{'Value Added Distributor'};
    List<String> federalCommunities = new List<String>{'Value Added Reseller','Dealer','Direct Market Reseller','eTailer'};
    List<String> TotalCommunities = new List<String>{'Value Added Reseller','Dealer','Direct Market Reseller','eTailer','Value Added Distributor'};
    String Query_Search=null;   

    public List<Id> TechnologySearchLogic(List<Id> Input_Accounts,String Technology,String[] TechLevel,String SearchType,String sortType){

        //Include TechSpecilization,Community,SpecializationType and Status Fields in Query Search
        if(SearchType == 'Reseller')
        {
         if(sortType=='old')
          Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\' and account__c in : Input_Accounts ';
         else 
         Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\'  and Community_Type__c in: resellerCommunities  and Type__c=\'Technology' + '\' and Technology_Specialization_Status__c =\'Active' + '\' and account__c in : Input_Accounts ';
          
        }
        else if(SearchType == 'Distributor')
        {
          if(sortType=='old')
           Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\' and account__c in : Input_Accounts ';
          else
           Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\'  and Community_Type__c in: distributorCommunities  and Type__c=\'Technology' + '\' and Technology_Specialization_Status__c =\'Active' + '\' and account__c in : Input_Accounts ';
        }
        
        /* for UPL 1.2 */
         else if(SearchType == 'Federal')
        {
          //if(sortType=='old')
           //Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\' and Partner_Type__r.US_Federal_Specialization__c!=null and account__c in : Input_Accounts ';
          //else
           Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\'  and Community_Type__c in: federalCommunities  and Type__c=\'Technology' + '\' and Technology_Specialization_Status__c =\'Active' + '\' and Partner_Program__r.US_Federal_Specialization__c!=null and account__c in : Input_Accounts ';
        }
         else if(SearchType == 'EMEARADIO')
        {
          if(sortType=='old')
           Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\' and account__c in : Input_Accounts ';
          else
           Query_Search='Select Account__c from Technology_Specialization__c where Technology_Specialization__c =\''+ Technology +'\'  and Community_Type__c in: TotalCommunities and Type__c=\'Technology' + '\' and Technology_Specialization_Status__c =\'Active' + '\' and account__c in : Input_Accounts ';
        }
        if(TechLevel!=null)
        System.debug('TechLevels Size is :'+TechLevel.size());  

        //If the selected  Specialization Level contains 'Authorized', then remove it from the list,since all Partners are Authorized by Defalut
        if(TechLevel!=null)
        {
            Integer noOfLevels = TechLevel.size();
            for(integer i=0;i<noOfLevels;i++){
                if(TechLevel[i].equals('Authorized'))
                {
                    TechLevel.remove(i);
                }            
            }
        }
        
        if(TechLevel!=null)
        System.debug('TechLevels:'+TechLevel.size());

        //If the Selected Specialization Level list is not empty(after removing Authorized),consider it in the query
        if(TechLevel!=null)
        {
            if(TechLevel.size()>0)
             Query_Search=Query_Search+' and (Technology_Specialization_Level__c in : TechLevel or tolabel(Technology_Specialization_Level__c) in : TechLevel) ';
        }
        System.debug('##########Query Value:'+Query_Search); 
        
        //Querying DataBase 
        Tech_Accs = Database.query(Query_Search+' LIMIT 10000');  
        
        //Loop through the results and add the AccountIds to the final list
        for(Technology_Specialization__c z:Tech_Accs)
        {
            Accid_Technology.add(z.Account__c);
        } 
        
        //Clear the Temporary List
        if(Tech_Accs.size()!=null)
            Tech_Accs.clear();   
   
         //Clear all Unwanted Fields
        Query_Search=null;  
        
        //Return the list of AccountIds
        return Accid_Technology;
    } 
}