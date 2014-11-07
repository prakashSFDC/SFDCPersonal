public class dataTableCon {

        public string picklist{get;set;}
        List<Account> accounts;
        
        public List<Account> getAccounts() {
                if(accounts == null) accounts = [select name,phone,owner.name,AccountSource from account order by name Limit 5];
                return accounts;
        }

}