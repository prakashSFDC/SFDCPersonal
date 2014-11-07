public with sharing class MyButtonOverRideCtrl{

public Id accountId {get; set;}
public MyButtonOverRideCtrl(ApexPages.StandardController controller) {

}

/*Get the related agreement type from Custom setting as picklist on the page.*/
    public List<SelectOption> getAgreementTypes()
    {
        List<AgreementType__c> listAgmtTypes = AgreementType__c.getAll().values();
        List<SelectOption> listAgreements = new List<SelectOption>();
        
        for(AgreementType__c agmnt: listAgmtTypes){
            if(agmnt.Customer_Partner__c){
                listAgreements.add(new SelectOption(agmnt.Agreement_Name__c, agmnt.Agreement_Name__c));
               }
        }
        listAgreements.sort();
        return listAgreements;
    }
    
    /*Action to taken on change of the Agreement types*/
    public PageReference OnAgreementTypeChange(){
     
     return null;
    }
}