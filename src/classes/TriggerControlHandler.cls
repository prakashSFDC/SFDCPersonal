/**
 * Company     : Prakash Technologies.
 * Description : This provides a centralized control for all triggers, when processing requires
 *               that triggers are bypassed, use this class to set inactive and the relevant trigger
 *               handler will bypass all triggers for that particular object.
 * History     : 
 */
public class TriggerControlHandler {

    // Booleans to determine whether specified triggers are active; all default to active
    private static boolean accountTriggersActive = true;
    private static boolean opportunityTriggersActive = true;
    
     // Account trigger controls
    public static boolean hasActiveAccountTriggers() {
        return accountTriggersActive;
    }

    public static void setAccountTriggersInactive() {
        System.debug(LoggingLevel.INFO, 'TriggerControlHandler accountTriggersActive set to FALSE');
        accountTriggersActive = false;
    }
    
     // Opportunity Trigger controls
    public static boolean hasActiveOpportunityTriggers() {
        return opportunityTriggersActive;
    }

    public static void setOpportunityTriggersInactive() {
        opportunityTriggersActive = false;
    }
    
    public static void setOpportunityTriggerActive() {
        opportunityTriggersActive = true;
    }
}