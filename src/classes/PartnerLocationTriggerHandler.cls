public without sharing class PartnerLocationTriggerHandler{

/**
     * The following methods provide the generic
     * handling for the PartnerLocationTrigger; specific logic and processing
     * is delegated to private methods.
     *
     * It is recommended that methods that are NOT needed be commented
     * out, but remain in template for future use.
     */

    /* Commented for future use   
    public static void onBeforeInsert(List<Partner_Location__c> newLocation){}*/
  
    public static void onAfterInsert(List<Partner_Location__c> listNewLocations){        
        //AccountActiveLocationFieldUpdationBL.collectAccountForUpdate(listNewLocations);
    }
    
    /* Commented for future use   
    @future 
    public static void onAfterInsertAsync(Set<Id> newLocationIds){ }
  
    public static void onBeforeUpdate(List<Partner_Location__c> oldLocation, List<Partner_Location__c> updatedLocation, Map<Id, Partner_Location__c> LocationMap){}*/
    
    public static void onAfterUpdate(List<Partner_Location__c> listOldLocation, List<Partner_Location__c> listNewLocation, Map<Id, Partner_Location__c> mapOldLocation, Map<Id, Partner_Location__c> mapNewLocation){ 
        //AccountActiveLocationFieldUpdationBL.collectAccountForUpdate(listNewLocation);
    }
    
    /* Commented for future use
    @future 
    public static void onAfterUpdateAsync(Set<Id> updatedLocationIds){ }
    
    public static void onBeforeDelete(List<Partner_Location__c> LocationToDelete, Map<Id, Partner_Location__c> LocationMap){}
  
    public static void onAfterDelete(List<Account> deletedLocation, Map<Id, Partner_Location__c> LocationMap){ }
    
    @future 
    public static void onAfterDeleteAsync(Set<ID> deletedLocationIds){ }
    
    public static void onUndelete(List<Partner_Location__c> restoredLocation){ }*/

}