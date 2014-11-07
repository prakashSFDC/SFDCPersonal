public with sharing class RedirectForPDFCtrl {

    public String imageURL {get;set;}
    public String recordURL {get;set;}
    public Id recId {get;set;} 
     
    
    public RedirectForPDFCtrl(ApexPages.StandardController controller) {
    
      Attachment attId = [SELECT Id FROM Attachment WHERE ParentId =: controller.getId() Limit 1];
      imageURL = 'https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+ attId.Id ;
      recordURL = 'https://ap1.salesforce.com/'+controller.getId(); 
      //savePDFAttachment();
    }

    public Pagereference savePDFAttachment() {
    
        Id recId = ApexPages.currentPage().getParameters().get('id');
        PageReference pdf = Page.GeneratePDF;        
        pdf.getParameters().put('id',recId);
        
        Attachment attach = new Attachment();   
        Blob body;
        try {
            body = pdf.getContent();
           } catch (VisualforceException e) {
            system.debug('bkpoint e'+e);
            body = Blob.valueOf('Some Text');
           }         
        attach.Body = body;
        attach.Name = 'Final Agreement.pdf';
        attach.ParentId = recId;
        insert attach;
        system.debug('#####attach:'+attach.Id);
        List<Attachment> aList = new List<Attachment>();        
        for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :recId]){
            String fileName = a.Name;
            if(fileName.contains('.png'))
            {
                aList.add(a);
            }
        }
        if(aList.size()>0)
            delete aList;
            
       PageReference Page1 = new PageReference('/'+recId);
       Page1.setRedirect(true);
       return Page1;
    }
}