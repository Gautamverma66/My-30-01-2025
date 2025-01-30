@isTest
public with sharing class TestPaymentGatwayMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req){
      
        HttpResponse resp=new HttpResponse();
        if(req.getEndpoint()=='https://apitest.authorize.net/xml/v1/request.api'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"transactionResponse":{"responseCode":"1","authCode":"LW7IAS","avsResultCode":"Y","cvvResultCode":"P","cavvResultCode":"2","transId":"40122393442","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX1111","accountType":"Visa","description":"This transaction has been approved."}');
            resp.setStatusCode(200);
        }
        return resp;

    }
}