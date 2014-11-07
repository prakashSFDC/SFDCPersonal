/**
 * Company     : Adobe Systems Inc.
 * Description : This provides a centralized handler for all PartnerLocation triggers going forward.
 *               All handling and processing is delegated to the 
 *               PartnerLocationTriggerHandler class.
 * History     : 
 * [30.JAN.2013] Hari Prakash- Code creation
 */
 
trigger PartnerLocationTrigger     on Partner_Location__c (before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete)
   {
   
    /**
     * For each trigger context / operation,
     * a specific method is called on the handler which will
     * provide special logic and processing as needed.
     *
     * It is recommended that methods that are NOT needed be commented
     * out, but remain in template for future use.     
     */
    

}