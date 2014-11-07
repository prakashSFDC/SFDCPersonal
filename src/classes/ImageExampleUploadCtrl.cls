public class ImageExampleUploadCtrl {

    public Blob FileRecords { get; set; }
    public string FinalURL;
    public string convertedText {get;set;} 
    public String FileData;
    public String uploadedFileName {get;set;}
    
    public PageReference UploadFile() {
        
          system.debug('######FileRecords:-'+FileRecords);   
          system.debug('######uploadedFileName :-'+uploadedFileName );        
          FileData = EncodingUtil.base64Encode(FileRecords);
          system.debug('######FileData:-'+FileData);
          String boundary = '__boundary__xxx';
          String header = '--'+boundary+'\n';
          String body = 'Content-Disposition: form-data; name="data"; filename="'+uploadedFileName +'"\nContent-Type: application/octet-stream';
         
          String footer = '\n--'+boundary+'--';
           
          // no trailing padding on header by adding ' ' before the last "\n\n" characters
          String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\n\n'));
          //this ensures no trailing "=" padding
          while(headerEncoded.endsWith('='))
          {
           header+=' ';
           headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\n\n'));
          }
          //base64 encoded body
          String bodyEncoded = EncodingUtil.base64Encode(FileRecords);
          //base64 encoded footer
          String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
           
          Blob bodyBlob = null;
          //last encoded body bytes
          String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
          //if the last 4 bytes encoded base64 ends with the padding character (= or ==) then re-encode those bytes with the footer
          //to ensure the padding is added only at the end of the body
          if(last4Bytes.endsWith('='))
          {
           Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
           HttpRequest tmp = new HttpRequest();
           tmp.setBodyAsBlob(decoded4Bytes);
           String last4BytesFooter = tmp.getBody()+footer;   
           bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
          }
          else
          {
           bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
          }
           
        String EndPoint = 'https://api.idolondemand.com/1/api/sync/ocrdocument/v1';        
        String apiKey = '6897827b-1d14-4341-a918-b48306d9815a';        
        String imageURL = 'http://prakash123-developer-edition.ap1.force.com/resource/1413267681000/FBText';        
        imageURL = EncodingUtil.urlEncode(imageURL, 'UTF-8');
        
        //FinalURL = EndPoint+'?apikey='+apiKey+'&url='+imageURL+'&mode=document_photo';
        FinalURL = EndPoint;
        String sbody = 'apikey='+apiKey+'&file='+FileData+'&mode=document_photo';        
        system.debug('@@FinalURL'+FinalURL);                                          
        // Instantiate a new http object
          HttpRequest req = new HttpRequest();
         
        Http h = new Http();        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
       // HttpRequest req = new HttpRequest();
        req.setEndpoint(FinalURL);
        req.setMethod('POST');      
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);         
          req.setBodyAsBlob(bodyBlob);
          //req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
          
        req.setTimeOut(100000);
        system.debug('@@ request'+req);
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug('@@ response'+res);
        system.debug('@@ response'+res.getBody());
        ImageExampleWrap wraperResponse = ImageExampleWrap.parse(res.getBody());
        system.debug('@@ wraperResponse'+wraperResponse);
        system.debug('@@ wraperResponse.text_block'+wraperResponse.text_block);
        //system.debug('@@ wraperResponse.text_block.text'+wraperResponse.text_block[0].text);
        //convertedText = wraperResponse.text_block[0].text;
        return null;
    }

}