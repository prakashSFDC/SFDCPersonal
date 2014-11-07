/*  
* File Name      : UPL_FilterCriteria
* Description    : This class returns sorted partner locations                                        
* @author        : Infosys Technologies Limited
*
* Modification Log
* =============================================================================
*   Ver     Date         Author          Modification
*------------------------------------------------------------------------------
*   1.0     03-Sep-12    Sathish           Created  
*   1.1     10-Sep-12    Nimesh            added technologySpecialization 
*
*/
public class UPL_FilterCriteria {

    public String searchType {get;set;} 

    public String partnerName {get;set;} 
    
    public String location{get;set;} 
    
    public String locale{get;set;}
     
    public String region {get;set;} 
    
    public String country{get;set;} 
    
    public String state{get;set;} 
    
    public String technology {get;set;} 
    
    public String track {get;set;} 
    
    public List<ID> accountIDs {get;set;}
    
    public boolean isMego {get;set;}
    
    public boolean isAuthorizedServiceCentre {get;set;}
    
    public List<String> selectedProgramLevel {get;set;}
    
    public List<String> technologySpecialization {get;set;}
    
    public String latLong{get;set;} 
    
    public ID recordTypeID {get;set;} 
    
    public String nameSearchInvokedFor {get;set;} 
    
    public List<String> territoryCodes {get;set;}
    

}