/*  
* File Name     : UPLLocationAccountSearch
* Description    : This class returns a list of Active Partner Accounts which belong
*                  to the Country selected in the UPL search page                                           
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     28-Nov-11   Infosys       Created  
 *   
 */
public class UPLLocationAccountSearch
{

    List<Partner_Location__c> AccPartLocs = new List<Partner_Location__c>();//Temporary list to hold the Partner location data
    List<Id> Accid_Part_Locs= new List<Id>();//List to return the AccountIds 
    String Query_Search=null;//Query string 
    String Federal_condition_1 = 'Non-Federal Location';//US Federal Condition for Partners
    String Federal_condition_2 = 'Federal Only Location';//US Federal Condition for Partners
    String Federal_condition_3 = 'Federal and Non-Federal Location';//US Federal Condition for Partners
    Id recordTypeIDPartner = '012Q0000000Clem';//Record Type Id for Partners
      

    public List<Id> LocationAccountSearchLogic(String Country,String Track,String SearchType,String[] ServOffered,String PartnerName,boolean MegoCheckbox )
    {
    
        //Include Country,Locator Status and Partner RecordType in the Query String
        Query_Search='Select Account__c from Partner_Location__c where   Account__r.Partner_Locator_Status__c=\'Active'+ '\' and Account__r.RecordTypeId = \''+recordTypeIDPartner+'\'';
        
         System.debug('*************** Country in Location Search:'+ Country );
        
         //if(!(Country.equals('None'))){ 
       // if(Country != null)
        //Country = Country.trim();
        
        if((Country !='None')&&(Country != null)&&(Country != '')) {
            System.debug('######################## Country in Location Search:'+ Country );
           Query_Search = Query_Search+ ' AND Country1__c=\''+ Country +'\' ';
        }
        
        if(SearchType=='Reseller'){
            Query_Search=Query_Search+ ' AND(Federal_Status__c != \''+Federal_condition_2+'\')'; 
        }       
        else if(SearchType == 'Federal'){
            Query_Search=Query_Search+ ' AND(Federal_Status__c = \''+Federal_condition_2+'\'  OR Federal_Status__c= \''+Federal_condition_3+'\')';    
        }
        
        //Include the Partner Record type and US Federal Specialization in the Query.
        
                        
        System.debug('########################Track in Location Account Search:'+Track);
        
        //If Track is Mobility,then fetch only the records where Mobility Status field is Active on Accounts
        if(Track=='Mobility'){
            Query_Search=Query_Search+' and Account__r.Partner_Status_Mobility__c=\'Active'+ '\'';
        }
         //If Track is Radio,then fetch only the records where Radio Status field is Active on Accounts
        else if(Track=='RADIO'){
            Query_Search=Query_Search+' and Account__r.PartnerStatus_Radio__c=\'Active'+ '\'';
        }
         //If Track is WNS,then fetch only the records where WNS Status field is Active on Accounts
        else if(Track=='WNS'){
            Query_Search=Query_Search+' and Account__r.PartnerStatus_WNS__c=\'Active'+ '\'';
        }
         //If Track is SCADA,then fetch only the records where SCADA Status field is Active on Accounts
        else if(Track=='SCADA'){
            Query_Search=Query_Search+' and Account__r.PartnerStatus_SCADA__c=\'Active'+ '\''; 
        }
        
        
        
        //If Mego checkbox is selected,then fetch only the records which have MEGO/eMEGO/MGCO in the Mego Status Field
        if(MegoCheckbox == true)
        Query_Search=Query_Search+' and Account__r.Mego_Status__c!=null';
       
       //If Partner name field has a value,include it in the query
       if(PartnerName!=null)
       {
          if(PartnerName.length()!=0)
          {
            PartnerName=PartnerName.trim().replaceAll('^+(?!$)', '');
            System.debug('########Value of Partner Name field:'+PartnerName);
            String partner_name_nonfed=null;
            partner_name_nonfed = '\''+'%'+PartnerName+'%'+'\'';
            Query_Search=Query_Search+' and PartnerName__c like'+partner_name_nonfed; 
            System.debug('###############Query after Part name:'+query_search);
          }
       }
       
       //If Services Provided checkbox is chosen,then include Services Provided in the Query.
       if(ServOffered!=null)
       {
         if(ServOffered.size()>0)
           Query_Search=Query_Search+ ' and Account__r.Services_Provided__c in : ServOffered';
       }                      
        System.debug('######FINAL Query Value:'+Query_Search);  
        
        AccPartLocs = Database.query(Query_Search+' LIMIT 10000');      
        for(Partner_Location__c z : AccPartLocs)
        {
          Accid_Part_Locs.add(z.Account__c);
        } 
         
         //Clear the Temporary List
         if(AccPartLocs.size()!=null)
             AccPartLocs.clear();
         
        /* //Clear the Unwanted Fileds 
         Query_Search=null;
         Federal_condition_2 = null;
         Federal_condition_3 = null;
         recordTypeIDPartner = null; */
         
         //Return the list of AccountIds  
         return Accid_Part_Locs;
       } 
}