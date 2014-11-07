public with sharing class LookUpOverRideCtrl{

public Id accountId {get; set;}
public List<Contact> results{get;set;} // search results
public string searchString{get;set;} // search keyword
public LookUpOverRideCtrl() {

}

// performs the keyword search
  public PageReference search() {
    Integer iNumOfChar  = searchString.length();
    system.debug('iNumOfChar>>>'+iNumOfChar);
    if(iNumOfChar == 1){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning, 'Your search text must have 2 or more characters.'));
    }else{
        runSearch();
    }
    return null;
  }
  
   // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  }
  
  // run the search and return the records found. 
  private List<Contact> performSearch(string searchString) {
    String soql = 'select id, name from contact where Level__c != null';
        if(searchString != '' && searchString != null){
          soql = soql +  ' AND name LIKE \'%' + searchString +'%\'';
        }
          soql = soql +  ' AND AccountId =\''+accountId+'\'';
          soql = soql + ' limit 25';
          System.debug(soql);
        return database.query(soql);
  }
  
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }

}