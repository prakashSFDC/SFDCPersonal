public class DialyExpendituresCtrl {
    
    public Date expenseDate { get; set; }
    public String amount { get; set; }
    public String expenseType { get; set; }
    public String ownerName { get; set; }    
    public Boolean displayFlag {get;set;}    
    public Boolean displayTrasFlag {get;set;}   
    public Boolean flagShowHistory {get;set;} 
    public Boolean flagShowHistoryError {get;set;}
    public Expenditures__c expenditure ;
    public List<Expenditures__c> expendituresList {get; private set;}    
    public Date fromDate {get;set;}
    public Date toDate {get;set;}    
    public Attachment attachment {get;set;}
    public transient Attachment attachment1;
           
    public DialyExpendituresCtrl(ApexPages.StandardController controller) {
        displayFlag = false;  
        flagShowHistoryError = false ;    
        expenditure = (Expenditures__c)controller.getRecord();
        this.expendituresList = new List<Expenditures__c>();
        flagShowHistory = false;
        attachment = new Attachment();
        attachment1 = new Attachment();
    }
    public PageReference doCreate() {
        displayFlag = true;
        displayTrasFlag = false;
        attachment = new Attachment();
        attachment1 = new Attachment();
        //expenditure = new Expenditures__c();
        expenditure.Expense_Owner__c = null;
        expenditure.Expense_Type__c = null;        
        expenditure.Expense_Amount__c = null;
        expenditure.Expenditure_Date__c = null; 
        expenditure.Expense_Description__c = null;      
        expenditure.isValid__c = false;
        flagShowHistoryError = false ; 
        flagShowHistory = false;      
        return null;
    }
    
    public PageReference doCancel() { 
        PageReference p = new PageReference('/apex/DialyExpenditures');  
        p.setRedirect(true);   
        return p;
    }


    public PageReference doModify() {
        displayTrasFlag = true;
        displayFlag = false;
        expenditure.Expense_Owner__c = null;
        expenditure.Expense_Type__c = null;
        fromDate = null;
        toDate = null;               
        return null;
    }
    public PageReference showTranscations() {
        displayTrasFlag = true;
        return null;
    }
    
     public PageReference doClose() {
        return null;
    }

    public PageReference doSave() {
       try{
            insert expenditure ;
            
            attachment.OwnerId = '00590000000Oj5W';
            attachment.ParentId = expenditure.Id; // the record the file is attached to
            attachment1 = attachment ;
            insert attachment1;
            
            attachment = null;            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Record Inserted Successfully');
            ApexPages.addMessage(msg); 
            displayFlag = false; 
            PageReference p = new PageReference('/apex/DialyExpenditures');  
            p.setRedirect(true);   
            return p;       
        }Catch(DMLException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg); 
            return null;
        }
    }
    
    public void clearValues(){
          
    }
    
    public PageReference doSearch() {
        system.debug('####expenditure.Expense_Owner__c:'+expenditure.Expense_Owner__c);
        system.debug('####expenditure.Expense_Type__c:'+expenditure.Expense_Type__c);
        system.debug('####fromDate:'+fromDate);
        system.debug('####toDate:'+toDate); 
        String queryString = 'SELECT Id ,Expense_Owner__c ,Expense_Type__c ,Expense_Amount__c ,Expenditure_Date__c ,Expense_Description__c FROM Expenditures__c WHERE isValid__c = TRUE'; 
        String filters = '';
        
        if(expenditure.Expense_Owner__c != null){
            filters += ' AND Expense_Owner__c =\''+expenditure.Expense_Owner__c+'\'';
        } 
        if(expenditure.Expense_Type__c != null){
            filters += ' AND Expense_Type__c =\''+expenditure.Expense_Type__c +'\'';
        }
        if(fromDate!= null && toDate== null) {
            filters+=' AND Expenditure_Date__c >=:fromDate' ;            
        }
        if(fromDate!= null && toDate!= null) {
            filters+=' AND Expenditure_Date__c >=:fromDate AND Expenditure_Date__c <=:toDate';
        }
        if(fromDate==null && toDate!= null) {
            filters+=' AND Expenditure_Date__c <=:toDate';   
        } 
        system.debug('####queryString :'+queryString ); 
        system.debug('####filters :'+filters );  
        expendituresList = Database.query(queryString+filters);
        if(expendituresList.size()>0){
            flagShowHistory = true;
        }else{
            flagShowHistoryError = true;
        }
         system.debug('####flagShowHistory :'+flagShowHistory );  
        return null;
    }

}