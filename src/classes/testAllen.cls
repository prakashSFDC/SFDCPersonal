/* From developers board */

public class testAllen {
    public List<DisplayAccount> DisplayAccount {get; set;}
    
    public testAllen() {
        this.DisplayAccount = new List<DisplayAccount>();
        for (Account a : [SELECT id, Name FROM Account LIMIT 20]) {
            this.DisplayAccount.add(new DisplayAccount(a));
        }
    }
    
    public class DisplayAccount {
        public boolean IsSelected {get;set;}
        public Account account {get;set;}
            
        public DisplayAccount(Account a) {
            this.account = a;
            this.IsSelected = false;
        }
    }
}