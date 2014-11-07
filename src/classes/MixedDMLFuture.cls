public class MixedDMLFuture {
    public static void useFutureMethod() {
        // First DML operation
        Account a = new Account(Name='Mixed DML');
        insert a;
        system.debug('Inserted Account:'+ a);
        userUpdate();
    }
    
    @Future   
    public static void userUpdate(){   
        
        User u =[Select Id, IsActive from USER where IsActive = false];
        u.IsActive = true;  
        
        if (Test.isRunningTest()) {
             // start new context via system.runAs() for the same user for test code only
            System.runAs(new User(Id = Userinfo.getUserId())) {
                update u;
             }
         }else{
             update u;
         }
        
        system.debug('#### Updated User:'+ u);
    }
}