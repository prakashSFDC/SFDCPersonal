public class pdfTemplateTempCtrl{

public Id agreementId {get;set;}
public pdfTemplateTempCtrl(){
    agreementId = ApexPages.currentPage().getparameters().get('id');
}
public PageReference doCreate(){
    PageReference pdf = Page.PdfGeneratorTemplate;
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',agreementId);
            //pdf.getParameters().put('position', '1');
            //pdf.setRedirect(true);
            // the contents of the attachment from the pdf
            Blob body =  Blob.valueOf('Sample Agreement');

            try {
              // returns the output of the page as a PDF
             body = pdf.getContent();
              //List<Attachment> abc =[Select Id,body from Attachment where Id=:'00P9000000E6wQZ'];
              String filename = DateTime.Now().format('MM-dd-yy') + ' Agreement-Draft.pdf';
              Attachment a = new Attachment(parentId = agreementId, name=filename, body = body, ContentType = 'application/pdf');
              Insert a; 
              sendforSign(agreementId);        
            // need to pass unit test -- current bug  
            } catch (VisualforceException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                //return null;
            } 
            
            //return new PageReference('/apex/AgreementCreation');
            return null;
}
@Future(callout=true)
    public static void sendforSign(String agreementId){
            system.debug('#####Entered sendforSign:');              
            dtoApiEchosign.SenderInfo senderInfo = new dtoApiEchosign.SenderInfo();
            senderInfo.email = EchoSign_API_Settings__c.getInstance('Sender_Mail').Value__c; 
            
            echosign_dev1__SIGN_Agreement__c agreement =[Select Id,Name,echosign_dev1__Recipient__r.Email From echosign_dev1__SIGN_Agreement__c agreement where Id =: agreementId]; 
            apiEchosign.EchoSignDocumentService19HttpPort  api = new apiEchosign.EchoSignDocumentService19HttpPort();
  
            dtoApiEchosign.DocumentCreationInfo documentCreationInfo = new dtoApiEchosign.DocumentCreationInfo();
            
            String apiKey = EchoSign_API_Settings__c.getInstance('APIKEY').Value__c;                    
         // Querying Custom Setting To populate Callback URL 
            String callBackURL = EchoSign_API_Settings__c.getInstance('Signed_Document_Url').Value__c; 
            
            dtoApiEchosign.CallbackInfo callBackInfo = new dtoApiEchosign.CallbackInfo();
            callBackInfo.signedDocumentUrl = callBackURL;
        
            documentCreationInfo.name = agreement.Name;
            documentCreationInfo.signatureFlow = 'SENDER_SIGNATURE_NOT_REQUIRED';
            documentCreationInfo.signatureType = 'ESIGN';
            documentCreationInfo.callbackInfo = callBackInfo; 
            
            dto14ApiEchosign.ArrayOfRecipientInfo recipients = new dto14ApiEchosign.ArrayOfRecipientInfo();
            dto14ApiEchosign.RecipientInfo[] recipientInfos = new dto14ApiEchosign.RecipientInfo[]{};
            
            dto14ApiEchosign.RecipientInfo recipientInfo = new dto14ApiEchosign.RecipientInfo();
            
            recipientInfo.email = agreement.echosign_dev1__Recipient__r.Email;              
            recipientInfo.role = 'SIGNER';
            
            recipientInfos.add(recipientInfo);      
            recipients.RecipientInfo = recipientInfos;          
            documentCreationInfo.recipients = recipients;
            
            map<Id, list<Attachment>> attachmentsMap = new map<Id,list<Attachment>>();
            list<Attachment> attachmentList = [select Id, Name, Body from Attachment where parentId = :agreement.Id];
            
            attachmentsMap.put(agreement.Id, attachmentList);
            documentCreationInfo.fileInfos = getDocumentInfos(agreement, attachmentsMap);
            
            System.debug(LoggingLevel.INFO, ' apiKey = ' + apiKey);
            System.debug(LoggingLevel.INFO, ' recipientInfo = ' + recipientInfo);
            System.debug(LoggingLevel.INFO, ' senderInfo = ' + senderInfo);
            System.debug(LoggingLevel.INFO, ' documentCreationInfo = ' + documentCreationInfo);
            
            dto16ApiEchosign.ArrayOfDocumentKey docKeyList;
            
        if(!(Test.isRunningTest())){
            docKeyList =  api.sendDocument(apiKey, senderInfo, documentCreationInfo); 
            if(docKeyList.documentKey[0].documentKey != NULL){
                 echosign_dev1__SIGN_Agreement__c agmtUpdate = new echosign_dev1__SIGN_Agreement__c(Id = agreement.Id);
                 agmtUpdate.echosign_dev1__Document_Key__c = docKeyList.documentKey[0].documentKey;
                 agmtUpdate.echosign_dev1__Status__c= 'Out for Signature';
                 update agmtUpdate;
            }
        }
           System.debug(LoggingLevel.INFO, 'Exiting sendForSignatureProcess()');   
          
    }
    
    /**
     * Description: 
     * @param
     */     
   public static dtoApiEchosign.ArrayOfFileInfo getDocumentInfos(echosign_dev1__SIGN_Agreement__c agreement, map<Id, list<Attachment>> attachmentsMap) 
   {
        transient dtoApiEchosign.ArrayOfFileInfo arrayOfFileInfo = new dtoApiEchosign.ArrayOfFileInfo();
        
        list<Attachment> attachments = attachmentsMap.get( agreement.Id );
        
        if( attachments == null ) 
        {
            return arrayOfFileInfo;
        }
        transient dtoApiEchosign.FileInfo[] fileInfos = new dtoApiEchosign.FileInfo[]{};

        for(Attachment attachment : attachments) 
        {
            dtoApiEchosign.FileInfo fileInfo = new dtoApiEchosign.FileInfo();
            fileInfo.file = EncodingUtil.base64Encode(attachment.Body);            
            fileInfo.FileName = attachment.Name;            
            fileInfos.add(fileInfo);
        }
        
        arrayOfFileInfo.FileInfo = fileInfos;   
        
        return arrayOfFileInfo;
    } 
}