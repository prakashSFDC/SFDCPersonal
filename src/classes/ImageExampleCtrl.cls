public class ImageExampleCtrl {
    public string FinalURL;
    public string convertedText {get;set;}  
    
    public PageReference showText() {
    
        String EndPoint = 'https://api.idolondemand.com/1/api/sync/ocrdocument/v1';        
        String apiKey = '6897827b-1d14-4341-a918-b48306d9815a';        
        String imageURL = 'http://prakash123-developer-edition.ap1.force.com/resource/1413267681000/FBText'; 
        //String imageURL = 'https://www.idolondemand.com/sample-content/documents/hp_q1_2013.pdf';       
        imageURL = EncodingUtil.urlEncode(imageURL, 'UTF-8');
        
        //FinalURL = EndPoint+'?apikey='+apiKey+'&url='+imageURL+'&mode=document_photo';
        FinalURL = EndPoint;
        String sbody = 'apikey='+apiKey+'&url='+imageURL+'&mode=document_photo';        
        system.debug('@@FinalURL'+FinalURL);                                          
        // Instantiate a new http object
        Http h = new Http();        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(FinalURL);
        req.setMethod('POST');      
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(sbody);
        req.setTimeOut(100000);
        system.debug('@@ request:-'+req);
          System.debug(LoggingLevel.INFO, 'Request Body: ' + req.getBody());
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        system.debug('@@ response'+res);
        system.debug('@@ response'+res.getBody());
        ImageExampleWrap wraperResponse = ImageExampleWrap.parse(res.getBody());
        system.debug('@@ wraperResponse'+wraperResponse);
        system.debug('@@ wraperResponse.text_block'+wraperResponse.text_block);
        system.debug('@@ wraperResponse.text_block.text'+wraperResponse.text_block[0].text);
        convertedText = wraperResponse.text_block[0].text;
        return null;
    }

}