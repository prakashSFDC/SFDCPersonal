public without sharing class FeedbackTriggerHandler  {
    
    public static void onBeforeInsert(List<Feedback__c > listNewFeedbacks, Map<Id,Feedback__c > mapNewFeedbacks){
        
    }
    
    public static void onAfterInsert(List<Feedback__c > newListFeedback,Map<Id,Feedback__c > mapNewFeedbacks){
        
    }
    
    public static void onAfterDelete(List<Feedback__c > oldListFeedback,Map<Id,Feedback__c > mapOldRecords){
    
    }
    public static void onBeforeUpdate(List<Feedback__c > listOldFeedbacks, List<Feedback__c > listNewFeedbacks, Map<Id,Feedback__c > mapOldFeedbacks, Map<Id,Feedback__c > mapNewFeedbacks){
    }
    
    public static void onAfterUpdate(
        List<Feedback__c > oldListFeedback,
        List<Feedback__c > newListFeedback,
        Map<Id,Feedback__c > mapNewRecords,
        Map<Id,Feedback__c > mapOldRecords
    ){
    
    }
}