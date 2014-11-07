public class FetchAccountRecords{

                        

        public List<Account> accounts{get;set;}

        public FetchAccountRecords() {
            accounts = [select name, owner.name,phone from account limit 10];
            }

}