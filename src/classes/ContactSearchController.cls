public class ContactSearchController {

private String soql {get;set;}
public List<Account> accounts {get;set;}

public void runQuery() { 
    try {
      accounts = Database.query(soql + 'limit 20');
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
  }
public PageReference runSearch() {
        String accountName = Apexpages.currentPage().getParameters().get('accountName');
        soql = 'select  account.name from accounts where account.name != null';
        if (!accountName.equals(''))
      soql += 'account.name LIKE \''+String.escapeSingleQuotes(accountName)+'%\'';
            runQuery();
             
    return null;
            }

}