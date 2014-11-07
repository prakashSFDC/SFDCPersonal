//For displaying ajax processing logo
public class OverlayDemoController{
    public Partner_Location__c cnt {get;set;}
    public OverlayDemoController(){
        cnt = [select id,Account__c ,Address_Line1__c, Address_Line2__c, phone__c, Fax__c from Partner_Location__c limit 1];
    }
    
    public pagereference saveRecord(){
        List<contact> contacts = [select id, name from contact];
        //List<Site_User__c> users = [select id, name from Site_User__c];
        List<account> accounts = [select id, name from account];
        List<lead> leads = [select id, name from lead];
        List<case> cases = [select id from case];
        
        upsert cnt;
        return null;
    }
}