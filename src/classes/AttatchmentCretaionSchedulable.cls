global class AttatchmentCretaionSchedulable implements Schedulable{

     global void execute(SchedulableContext sc)
    { 
            AttatchmentCretaion aCheck= new AttatchmentCretaion ();                              
            
            // Actual Batch Execution
           database.executebatch(aCheck);
       
    }
}