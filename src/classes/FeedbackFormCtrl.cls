public class FeedbackFormCtrl{

public List<SelectOption> agreeOptions{get;set;}
public List<SelectOption> likeOptions{get;set;}
public List<SelectOption> satisfyOptions{get;set;}
public Feedback__c feedBackObj;

    public FeedbackFormCtrl(ApexPages.StandardController stdController){        
        agreeOptions = new List<SelectOption>();
        likeOptions= new List<SelectOption>();
        satisfyOptions= new List<SelectOption>();
        
        agreeOptions = optionTypes('Agree');
        likeOptions = optionTypes('Like');
        satisfyOptions = optionTypes('Satisfy');
        
        feedBackObj= (Feedback__c)stdController.getRecord();        
    }

    // Method to populate Different type of Feedback Options
    public List<SelectOption> optionTypes(String optionType){
        List<SelectOption> options = new List<SelectOption>();
        Feedback_Settings__c FBCS = Feedback_Settings__c.getInstance(optionType);
        List<String> listString = FBCS.value__c.split(',');
        for(String str :listString){
            options.add(new SelectOption(str,str));  
        }
        return options;
    }
    
    //Method to insert Feedback Record
    public PageReference doSubmit(){
    
    try{
        Database.insert(feedBackObj);       
    }Catch(DMLException e){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(msg); 
        return null;
    }
    
    // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
        
    // Sets the paramaters of the email
        email.setSubject( 'Thanks For the Feedback' );
        email.setToAddresses( new String[]{feedBackObj.Student_Email__c});
        email.setPlainTextBody( 'Thanks For submitting your valuable feedback.I hope you enjoyed my class.' );
        
    // Sends the email
        Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
        
    return Page.ThankyouForm;
    }
}