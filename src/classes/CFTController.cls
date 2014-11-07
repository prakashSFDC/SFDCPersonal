public class CFTController {

    public PageReference doSignup() {
        return null;
    }
    public PageReference doLogin() {
        return new PageReference('/apex/CFTLogin');
    }

}