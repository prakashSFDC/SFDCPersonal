/**
 * Company     : Cloud Force Tech.
 * Description : Generic Trigger on Feedback__c to handle insert,update,delete and undelete events
 *               All handling and processing is delegated to the 
 *               FeedbackTriggerHandler class.
 * History     : 
 * [26.AUG.2013] Manish Prasad    - Code creation
 */
 
trigger FeedbackTrigger on Feedback__c (
  after delete, 
  after insert, 
  after undelete,
  after update,
  before delete, 
  before insert, 
  before update
) {
  
    if(Trigger.isInsert && Trigger.isBefore){
      FeedbackTriggerHandler.onBeforeInsert(Trigger.new,Trigger.newMap);
    }else if(Trigger.isInsert && Trigger.isAfter){
           FeedbackTriggerHandler.onAfterInsert(Trigger.new,Trigger.NewMap);
        }else if(Trigger.isUpdate && Trigger.isBefore){
          FeedbackTriggerHandler.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }else if(Trigger.isUpdate && Trigger.isAfter){
            FeedbackTriggerHandler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap, Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isBefore){
            //FeedbackTriggerHandler.OnBeforeDelete(Trigger.old,Trigger.oldMap);
        }else if(Trigger.isDelete && Trigger.isAfter){
           FeedbackTriggerHandler.OnAfterDelete(Trigger.old,Trigger.oldMap);
        }else if(Trigger.isUnDelete){
            //FeedbackTriggerHandler.OnUnDelete(Trigger.old,Trigger.oldMap);
        }
}