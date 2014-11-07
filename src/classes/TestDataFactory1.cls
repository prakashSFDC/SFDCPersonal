@isTest
public class TestDataFactory1 {

static testmethod void method1(){
    Invoice_Statement__c inv1 =  new Invoice_Statement__c(Status__c='Open',Description__c='TestClass');
    insert inv1;
    
    Database.DeleteResult result = Database.delete(inv1, false);
    
    system.assert(result.isSuccess());
    
}

static testmethod void method2(){

    Merchandise__c mer1 = new Merchandise__c(Name='testMerch',Description__c='Testing',Price__c=10,Total_Inventry__c=500);
    insert mer1;
    
    Invoice_Statement__c inv2 =  new Invoice_Statement__c(Status__c='Open',Description__c='TestClass');
    insert inv2;
    
    Line_Item__c lItem = new Line_Item__c(Name='TestLine',Invoice_Statement__c=inv2.Id,Merchandise__c=mer1.Id);
    insert lITem;    
    
    Database.DeleteResult result = Database.delete(inv2, false);
    
    system.assert(!result.isSuccess());
    
}
}