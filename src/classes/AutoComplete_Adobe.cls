public class AutoComplete_Adobe{

public Account foundAccount {get;set;}
public String selectedCompany {get;set;}
public Boolean isCompanySelected {get;set;}
public Boolean isCompanyFound {get;set;}
    

/*Method Name : getCompanyDetails
     *Description : retrieves the account details chosen by the user.
     *Returns     : PageReference
     */
    public PageReference getCompanyDetails()
    {
        isCompanySelected = true;
        isCompanyFound = true;
        String selectedCompany = ApexPages.currentPage().getParameters().get('one');
        foundAccount = [Select Name, BillingStreet, BillingCity, BillingState,BillingCountry, BillingPostalCode, Phone, Website,
                               Partner_HQ_Country__c from Account where ID = :selectedCompany];
        system.debug('&&&&&&&&&foundAccount'+foundAccount);
        return null;
        
    }
    
}