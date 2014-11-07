global class AccountActiveCheckSchedulable implements Schedulable{

     global void execute(SchedulableContext sc)
    { 
            AccountActiveCheck aCheck= new AccountActiveCheck();                              
            
            // Actual Batch Execution
           database.executebatch(aCheck);
       
    }
}