public class PredSearch{
public string accountname {get; set;}

public List<Account> AvailableAccounts {get; set;}

Public PredSearch(){
    doSearch();
}
public  void doSearch(){ 

        String qString = ' select Name,phone from Account ';
    String accName = '\''+accountname+'%'+'\'';
        if(accountname!=null){
            qString += ' where name like'+  accName ;
        } 
        system.debug('qString:' +qString);        
  
        AvailableAccounts = database.query(qString);
    }
}