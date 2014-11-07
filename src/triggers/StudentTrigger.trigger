trigger StudentTrigger on student__c (before insert,before update){
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(Student__c s: trigger.New){
                s.Record_Created_date__c = Date.today();
            }
        }   
        if(trigger.isUpdate){
            
            for(Student__c a : Trigger.New){
                a.phone__c ='12345678';                
            }
        }
    }   
    
}