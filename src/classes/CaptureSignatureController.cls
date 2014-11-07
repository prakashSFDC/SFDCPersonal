global with sharing class CaptureSignatureController {
 
 @RemoteAction
 global static String saveSignature(String imageUrl, String accountId) {
  
  try {
   Attachment accSign = new Attachment();
   accSign.ParentID = accountId;
   accSign.Body = EncodingUtil.base64Decode(imageUrl);
   accSign.contentType = 'image/png';
   accSign.Name = 'Signature Image';
   accSign.OwnerId = UserInfo.getUserId();
   insert accSign;
   
   return 'success';
   
  }catch(Exception e){
   system.debug('---------- ' + e.getMessage());
   return JSON.serialize(e.getMessage());
  }
  return null; 
 }

}