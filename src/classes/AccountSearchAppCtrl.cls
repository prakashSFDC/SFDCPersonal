public class AccountSearchAppCtrl {

public String accName{get;set;}
public String accCountry{get;set;}
public String accType{get;set;}
public String accPhone{get;set;}
public List<Account> accList{get;set;}

public AccountSearchAppCtrl (){
    accName = '';
    accCountry = '';
    accType = '';
    accPhone = '';  
}

    public PageReference doSearch() {
        Integer iNumSearchParms = 0;
        accList = new List<Account>();      
        
        String stringQuery = 'Select Id,Name,Country__c,Type,Phone From Account';        
        
        if(accName != null && !(''.equals(accName))){
             //check for wildcard character(s)           
            if(accName.contains('%')){
                stringQuery += ' where (Name= \'' + String.escapeSingleQuotes(accName) + '\' OR Name like \'' 
                     + String.escapeSingleQuotes(accName) + '\')';
            }else{  
                stringQuery += ' where Name = \'' + String.escapeSingleQuotes(accName) + '\'';
            }
            iNumSearchParms++;
        }
        
        if(accCountry != null && !(''.equals(accCountry))){
            if(iNumSearchParms == 0){
                stringQuery += ' where Country__c = \'' + String.escapeSingleQuotes(accCountry) + '\'';
                
            }else{
                stringQuery += ' OR Country__c = \'' + String.escapeSingleQuotes(accCountry) + '\'';
            }
            iNumSearchParms++;          
        }
        
        if(accType != null && !(''.equals(accType))){ 
            if(iNumSearchParms == 0) {
                stringQuery += ' where Type = \'' + String.escapeSingleQuotes(accType) + '\'';
            }else{
                stringQuery += ' OR Type = \'' + String.escapeSingleQuotes(accType) + '\'';
            }
            iNumSearchParms++;
        }
        
        if(accPhone != null && !(''.equals(accPhone))){ 
            if(iNumSearchParms == 0){
                stringQuery += ' where Phone = \'' + String.escapeSingleQuotes(accPhone) + '\'';
            }else{
                stringQuery += ' OR Phone = \'' + String.escapeSingleQuotes(accPhone) + '\'';
            }
            iNumSearchParms++;
        }
        
        stringQuery = stringQuery + ' Order By Name asc Limit 10000';
        
        accList = Database.query(stringQuery);
        
        return null;
    }
    
    public PageReference doReset() {
        accName = '';
        accCountry = '';
        accType = '';
        accPhone = '';  
        accList = new List<Account>();
        
        return null;
    }

}