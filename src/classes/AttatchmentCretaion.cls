global class AttatchmentCretaion implements Database.Batchable<sObject>{

global String query;

global  database.QueryLocator start(Database.BatchableContext BC)
    {
         
        query= 'Select id,Name,Attatchment_Creation__c from echosign_dev1__SIGN_Agreement__c where Attatchment_Creation__c= true ';     
         
         return Database.getQueryLocator(query);
         
    }
global void execute(Database.BatchableContext BC, list<echosign_dev1__SIGN_Agreement__c> acc)
    {
    
        List<Attachment > attList= new List<Attachment>();
        for(echosign_dev1__SIGN_Agreement__c agreement:acc){
               PageReference pdf = Page.PdfGeneratorTemplate;
                // add parent id to the parameters for standardcontroller
                pdf.getParameters().put('id',agreement.Id);
    
                // the contents of the attachment from the pdf
                Blob body =  Blob.valueOf('Sample Agreement');
    
                try {
                    system.debug('#####agreement:'+agreement.Id); 
                  // returns the output of the page as a PDF
                  body = pdf.getContentAsPDF();
                  String filename = agreement.Name + ' ' + DateTime.Now().format('MM-dd-yy') + '.pdf';
                  Attachment a = new Attachment(parentId = agreement.id, name=filename, body = body, ContentType = 'application/pdf');
                  attList.add(a);
                }catch (VisualforceException e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                    //return null;
                }
        }
        
        if(attList.size()>0) {
                insert attList;
         }
         system.debug('#####attList:'+attList); 
    
    }
    
global void finish(Database.BatchableContext BC)
    {
        
    }

}