public class SFDCBankController {


    public PageReference doNewTransaction() {
       return new PageReference('/apex/MoneyTransaction');
    }
    
    public PageReference addNewUser() {
        return null;
    }

    public PageReference checkSingleUserHistory() {
        return new PageReference('/apex/MoneyTransaction');
    } 
    

}