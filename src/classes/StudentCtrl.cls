public class StudentCtrl{

public Student__c studentObj;

    public StudentCtrl(ApexPages.StandardController stdController){   
        
        studentObj = (Student__c)stdController.getRecord();        
    }
   
    //Method to insert Feedback Record
    public PageReference doSubmit(){
     try{
            Database.insert(studentObj);       
        }Catch(DMLException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(msg); 
            return null;
        }
        
        // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();    
            
        // Sets the paramaters of the email
            email.setSubject( 'Thanks For Contacting us' );
            email.setToAddresses( new String[]{studentObj.Email__c});
            email.setPlainTextBody( 'Thanks For contacting us . We will get back to you soon.' );
            
        // Sends the email
            Messaging.SendEmailResult [] r =  Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
            
        return Page.ThankyouForm;
        }    
}