public class MoneyTransactionController {

    public String customerToProcess{get; set;}
    public String transType{get; set;}
    public Decimal amount{get; set;}
    public Date transactionDate{get; set;}
    public String description{get; set;}
    Map<Id,String> mapIdName = new Map<Id,String>();
    
    public MoneyTransactionController (){
         mapIdName = new Map<Id,String>();
    }
    
     public List<SelectOption> getCustomers() {
        List<SelectOption> options = new List<SelectOption>();
        List<Customer__c> custList = new List<Customer__c>();        
        custList = [Select ID,NAME FROM Customer__c ORDER BY Name ASC ];
        for(Customer__c c : custList){
            options.add(new SelectOption(c.NAME,c.NAME));
            mapIdName.put(c.Id,c.NAME);            
        }
        return options;
    }
    
    public MoneyTransactionController(ApexPages.StandardController controller) {

    }
    
    public PageReference doSave() {
    
        if(transType == 'Dr.'){
            Debit__c d = new Debit__c();
            d.Amount__c= amount;
            d.Customer__c = mapIdName.get(customerToProcess);
            d.Description__c = description;
            d.Status__c = 'ACTIVE';
            d.Transaction_Date__c = transactionDate;
            d.Transaction_Type__c = transType ;
            
           insert d; 
        }else{
            /*
            
            */
        }    
        return new PageReference('/apex/SFDCBank');
    
    }
    
    public PageReference doCancel() {
    
        return new PageReference('/apex/SFDCBank');
    
    }

}