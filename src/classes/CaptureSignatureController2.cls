global with sharing class CaptureSignatureController2 {

    public Expenditures__c expenditure ;
    global Id oId {get;set;}
    public CaptureSignatureController2(ApexPages.StandardController controller) {
        expenditure = (Expenditures__c)controller.getRecord();
    }

 
 @RemoteAction
 global static RemoteSaveResult saveSignatureAsImage(String imageUrl, String accountId) {
  
 
    //Id parentId = saveRecord();
    Attachment accSign = new Attachment();
    accSign.ParentID = accountId;
    accSign.Body = EncodingUtil.base64Decode(imageUrl);
    accSign.contentType = 'image/png';
    accSign.Name = 'Signature Image.png';
    accSign.OwnerId = UserInfo.getUserId();
    
    Database.saveResult result = Database.insert(accSign,false);
    system.debug('####result in saveSignatureAsImage: '+result);
    
    RemoteSaveResult newResult = new RemoteSaveResult();
    newResult.success = result.isSuccess();
    newResult.objectId = result.Id;
    newResult.errorMessage = result.isSuccess()?'':result.getErrors()[0].getMessage();
    
    system.debug('####newResult in saveSignatureAsImage: '+newResult);
    return newResult;
 }
 
 global class RemoteSaveResult {
        public Boolean success;
        public Id objectId;
        public String errorMessage;
    }
    
 @RemoteAction
 global static Expenditures__c  saveRecord(String expOwner,String expType,Double expAmount,String expDesc,String imageUrl) {
        Expenditures__c  expenditure = new Expenditures__c();
        expenditure.Expense_Owner__c = expOwner;
        expenditure.Expense_Type__c = expType;      
        expenditure.Expense_Amount__c = expAmount;
        expenditure.Expenditure_Date__c = Date.today();
        expenditure.Expense_Description__c = expDesc;
        
        Database.saveResult result = Database.insert(expenditure,false); 
        system.debug('####result in saveRecord: '+result);      
        RemoteSaveResult newResult = new RemoteSaveResult();
 
        if(result.isSuccess()){
            Attachment accSign = new Attachment();
            accSign.ParentID = expenditure.Id;
            accSign.Body = EncodingUtil.base64Decode(imageUrl);
            accSign.contentType = 'image/png';
            accSign.Name = 'Signature Image.png';
            accSign.OwnerId = UserInfo.getUserId();
    
            Database.saveResult result1 = Database.insert(accSign,false);
            
            newResult.success = result1.isSuccess();
            newResult.objectId = result1.getId();
            newResult.errorMessage = result1.isSuccess()?'':result1.getErrors()[0].getMessage();
        }else{
            newResult.success = result.isSuccess();         
            newResult.errorMessage = result.isSuccess()?'':result.getErrors()[0].getMessage();
        }
        system.debug('####newResult in saveRecord: '+newResult);
        return expenditure;
        
       // return new Pagereference('/apex/'+expenditure.id);
 }

}