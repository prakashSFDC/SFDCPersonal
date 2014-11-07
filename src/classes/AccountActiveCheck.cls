global class AccountActiveCheck implements Database.Batchable<sObject>{

global String query;

global  database.QueryLocator start(Database.BatchableContext BC)
    {
         
        query= 'Select id,Active__c  from Account where Active__c= \'No\' ';     
         
         return Database.getQueryLocator(query);
         
    }
global void execute(Database.BatchableContext BC, list<Account> acc)
    {
    
        List<Account> finalAccUpdateList = new List<Account>();
        for(Account a:acc){
            a.Active__c='Yes';
            finalAccUpdateList.add(a); 
        }
        
        if(finalAccUpdateList.size()>0)
                update finalAccUpdateList;
    
    }
    
global void finish(Database.BatchableContext BC)
    {
        
    }

}