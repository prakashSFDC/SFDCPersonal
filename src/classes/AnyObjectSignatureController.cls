global with sharing class AnyObjectSignatureController 
{
    public AnyObjectSignatureController() {
    }
    
    @RemoteAction
    global static List<Account> findAccounts(String name)   {
        name = '%' + name + '%';
        List<Account> accounts = [Select Id, Name from Account where Name like :name];
        return accounts;
    }
    
    @RemoteAction
    global static String saveSignature(String signatureBody, String parentId) {
        try {
            system.debug('Record Id == ' + parentId);
            system.debug(signatureBody);
            Attachment a = new Attachment();
            a.ParentId = parentId;
            a.Body = EncodingUtil.base64Decode(signatureBody);
            a.ContentType = 'image/png';
            a.Name = 'Signature Capture.png';
            insert a;
            return '{success:true, attachId:' + a.Id + '}';
        }catch(Exception e) {
            return JSON.serialize(e);
        }
        return null;
    }

}