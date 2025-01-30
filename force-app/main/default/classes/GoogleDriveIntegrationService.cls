public with sharing class GoogleDriveIntegrationService {
    public static HttpResponse calloutResponse(String httpMethod,String endPoint,Map<String,String> header,String body,Blob base64EncodeFile){
        HttpRequest req = new HttpRequest();
        req.setMethod(httpMethod);
        req.setEndpoint(endPoint);
        req.setTimeout(60*1000);
        for (String headerName : header.keySet()) {
            String headerValue = header.get(headerName);
            req.setHeader(headerName, headerValue);
        }
        if(body!=''){
            req.setBody(body);
        }
        if(base64EncodeFile != null){
            req.setBodyAsBlob(base64EncodeFile);
        }

        Http htt = new Http();
        HttpResponse res = htt.send(req);
        
        return res;
    }
    public static String  authorizationString(String endPoint,String clientId,String redirectUri){
        String authorizationUrl = 'https://account.box.com/api/oauth2/authorize' +
            '?client_id=' + clientId +
            '&redirect_uri=' + redirectUri +
            '&response_type=code';
        return authorizationUrl;
    }
}