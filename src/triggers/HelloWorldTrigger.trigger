trigger HelloWorldTrigger on Account (After Insert) {
    List<Account> accList = new List<Account>();
    for(Account a : Trigger.New){
        Account a1 = new Account(id=a.Id,Country__c ='World');
        accList.add(a1);
        }
        if(accList.size()>0){
            update accList;
        }
    }