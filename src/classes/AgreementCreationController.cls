public class AgreementCreationController{

    public echosign_dev1__SIGN_Agreement__c agreement {get; private set;}
    
    public Id agreementId {get;set;}
    
    public class AgreementIntegrationResponse extends AdobeCustomTypes.CommonResponse { }  
    
    public AgreementCreationController(ApexPages.StandardController controller) {
         agreement = (echosign_dev1__SIGN_Agreement__c)controller.getRecord();
        
    }

    public PageReference save() {
       try {
            agreement.Attatchment_Creation__c = true;
            Database.insert(agreement);
           
           PageReference pdf = Page.pdfTemplateTemp;
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',agreement.Id);         
            pdf.setRedirect(true);
            
            return pdf;
           /* PageReference pdf = Page.PdfGeneratorTemplate;
            // add parent id to the parameters for standardcontroller
            pdf.getParameters().put('id',agreement.Id);
            pdf.getParameters().put('position', '1');
            pdf.setRedirect(true);
            // the contents of the attachment from the pdf
            Blob body =  Blob.valueOf('Sample Agreement');

            try {
              // returns the output of the page as a PDF
             body = pdf.getContent();
              //List<Attachment> abc =[Select Id,body from Attachment where Id=:'00P9000000E6wQZ'];
              String filename = agreement.Name + ' ' + DateTime.Now().format('MM-dd-yy') + '.pdf';
              Attachment a = new Attachment(parentId = agreement.id, name=filename, body = body, ContentType = 'application/pdf');
              Insert a;
              
              system.debug('#####before sendforSign:');
              //sendforSign(agreement.Id);             
              system.debug('#####afer sendforSign:');              
            // need to pass unit test -- current bug  
            } catch (VisualforceException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                return null;
            } */
            
          }catch(System.DMLException e) {
               ApexPages.addMessages(e);
               return null;
           }
          
       //  After Save, navigate to the default view page:      
       //return (new ApexPages.StandardController(agreement)).view();
       
    }
    
   /* @Future(callout=true)
    public static void sendforSign(String agreementId){
            system.debug('#####Entered sendforSign:');              
            dtoApiEchosign.SenderInfo senderInfo = new dtoApiEchosign.SenderInfo();
            senderInfo.email = UserInfo.getUserEmail();  
            
            echosign_dev1__SIGN_Agreement__c agreement =[Select Id,Name,echosign_dev1__Recipient__r.Email From echosign_dev1__SIGN_Agreement__c agreement where Id =: agreementId]; 
            apiEchosign.EchoSignDocumentService19HttpPort  api = new apiEchosign.EchoSignDocumentService19HttpPort();
  
            dtoApiEchosign.DocumentCreationInfo documentCreationInfo = new dtoApiEchosign.DocumentCreationInfo();
            
            String apiKey = 'TU6ELCX2S2S3P8 ';                    
            
            documentCreationInfo.name = agreement.Name;
            documentCreationInfo.signatureFlow = 'SENDER_SIGNATURE_NOT_REQUIRED';
            documentCreationInfo.signatureType = 'ESIGN';
            
            
            //documentCreationInfo.externalId = getExternalId(agreement.Id);
            
            dtoApiEchosign.ExternalId externalId = new dtoApiEchosign.ExternalId();        
            String namespace = 'SALESFORCE';
            String groupName = UserInfo.getOrganizationId();
           // String id = agreementId.substring(0, 15);
            
            //externalId.namespace = namespace;
            //externalId.group_x = groupName;
            //externalId.id = id;
        
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
            
            system.debug('#####apiKey:'+apiKey);
            system.debug('#####recipientInfo:'+recipientInfo);
            system.debug('#####senderInfo:'+senderInfo);
            system.debug('#####:documentCreationInfo'+documentCreationInfo);
            dto16ApiEchosign.ArrayOfDocumentKey docKeyList;
            
        if(!(Test.isRunningTest())){
            docKeyList =  api.sendDocument(apiKey, senderInfo, documentCreationInfo); 
             //echosign_dev1__SIGN_Agreement__c agmtUpdate = new echosign_dev1__SIGN_Agreement__c(Id = agreement.Id);
             //agmtUpdate.echosign_dev1__Status__c= 'Out for Signature';
             //update agmtUpdate;
        }
        system.debug('#####Exiting sendforSign:');  
          
    }
        
   public static dtoApiEchosign.ArrayOfFileInfo getDocumentInfos(echosign_dev1__SIGN_Agreement__c agreement, map<Id, list<Attachment>> attachmentsMap) 
   {
        transient dtoApiEchosign.ArrayOfFileInfo arrayOfFileInfo = new dtoApiEchosign.ArrayOfFileInfo();
        
        list<Attachment> attachments = attachmentsMap.get( agreement.Id );
        
        if( attachments == null ) 
        {
            return arrayOfFileInfo;
        }
        
        //SIGN_Settings__c settings = EchoSignSettingsUtilities.getInstance().getSettings();
        //SIGN_Settings_Private__c privateSettings = SIGN_Settings_Private__c.getOrgDefaults();
        
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
    } */
            
}