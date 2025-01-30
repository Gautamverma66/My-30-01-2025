public with sharing class DropBoxService {
    public static HttpResponse calloutRequest(String httpMethod,String endPoint,Map<String,String> header,String body,Blob base64EncodeFile) {
        System.debug(httpMethod);
        System.debug(endPoint);
        System.debug(body);
        System.debug(base64EncodeFile);
        HttpRequest req = new HttpRequest();
        req.setMethod(httpMethod);
        req.setEndpoint(endPoint);
        req.setTimeout(60*1000);
        for (String headerName : header.keySet()) {
            String headerValue = header.get(headerName);
            System.debug(headerName);
            System.debug(headerValue);
            req.setHeader(headerName, headerValue);

        }
        if(body != ''){
            req.setBody(body);
        }
        if(base64EncodeFile != null){
            req.setBodyAsBlob(base64EncodeFile);
        }

        Http htt = new Http();
        HttpResponse res = htt.send(req);
        
        return res;
    }


    
}