/*  
* File Name      : UPL_SearchResults
* Description    : This class returns acts as a wrapper for the search results and accomodates all the details corresponding to a account                                        
* @author        : Prakash
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     09-Oct-12    Prakash           Created  
*
*/
public class UPL_SearchResults{

    public String accountName {get;set;} 
    
    public id accountId {get;set;} 
    
    public String accountLocalName {get;set;} 
    
    public String address {get;set;}
    
    public String addressLine1 {get;set;}
    
    public String addressLine2 {get;set;}
    
    public String addressLine3 {get;set;}
    
    public String city {get;set;}
    
    public String state {get;set;}
    
    public String postalCode {get;set;}
    
    public String country {get;set;}
    
    public String phoneNumber {get;set;} 
    
    public String faxNumber {get;set;}
    
    public String webUrl {get;set;}  
        
    public String programLevel {get;set;}
    
    public List<String> communities {get;set;}
    
    public List<String> technologySpecializations {get;set;}
    
    public List<String> applicationSpecializations {get;set;}
    
    public List<String> usFederalSpecializations {get;set;}
    
    public List<String> authorizedProductsOrProductLineOffered {get;set;}
    
    public List<String> partnerLevelOrType {get;set;}
    
    public Double latitude{get;set;}
    
    public Double longitude{get;set;}
    
}