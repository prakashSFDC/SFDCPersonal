global class AttachmentInsertBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {

global String query;
global String Out_for_Signature = 'Out for Signature';

global  database.QueryLocator start(Database.BatchableContext BC)
    {
         
        query= 'Select id,Name,echosign_dev1__Status__c,echosign_dev1__Document_Key__c from echosign_dev1__SIGN_Agreement__c where Id = \'a1H90000002FY6iEAG\' AND echosign_dev1__Status__c = \''+Out_for_Signature+'\' LIMIT 1';     
        system.debug('Query:-'+query); 
         return Database.getQueryLocator(query);
         
    }
global void execute(Database.BatchableContext BC, list<echosign_dev1__SIGN_Agreement__c> agmt)
    {
    
        List<Attachment > attList= new List<Attachment>();
        for(echosign_dev1__SIGN_Agreement__c agreement : agmt){  
            apiEchosign.EchoSignDocumentService19HttpPort  api = new apiEchosign.EchoSignDocumentService19HttpPort();
            dto19ApiEchosign.DocumentInfo documt = api.getDocumentInfo('TU6ELCX2S2S3P8',agreement.echosign_dev1__Document_Key__c);
            System.debug('###### Status'+documt .status);
            if(documt .status == 'SIGNED'){ 
                dto14ApiEchosign.GetDocumentsOptions options = new dto14ApiEchosign.GetDocumentsOptions();
                options.combine = FALSE;
                dto16ApiEchosign.getDocumentsResult doc = api.getDocuments('TU6ELCX2S2S3P8','2AAABLblqZhAxX9kr4rQ8Gjutsqg4aGKPbHPT3i0TE3MFOlbu5ZM-0b5-ziHv2o8hGSWdm4ZwAbY*',options);
                System.debug('###### HI:-'+options);
                System.debug('###### DocumentInfo:-'+doc);
                System.debug('###### DocumentInfo success:-'+doc.success);
                System.debug('###### DocumentInfo supportingDocuments:-'+doc.supportingDocuments);
                System.debug('###### DocumentInfo documents:-'+doc.documents.DocumentContent[0].name);
                if(doc.success){
                    try {
                        Blob body =  Blob.valueOf('Sample Agreement');
                       body = EncodingUtil.base64Decode(doc.documents.DocumentContent[0].bytes);      
                       //body = body.toPDF(doc.documents.DocumentContent[0].bytes);
                        String filename = agreement.Name + ' ' + DateTime.Now().format('MM-dd-yy') + 'Signed.pdf';
                        Attachment a = new Attachment(parentId = agreement.id, name=filename, body = body, ContentType = 'application/pdf');
                        insert a;
                    }catch (VisualforceException e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));                      
                    }
                }
            }
         //System.debug('###### agreement Id :-'+agreement.ID);
        }
    }
    
global void finish(Database.BatchableContext BC)
    {
        
    }

}