@isTest
public with sharing class TestSalesforceToSalesforceCalloutMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest req){
      
        HttpResponse resp=new HttpResponse();
        if(req.getMethod()=='GET'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"contentList":[{"attributes":{"type":"ContentDocument","url":"/services/data/v58.0/sobjects/ContentDocument/0692t00000GJUaCAAX"},"Id":"0692t00000GJUaCAAX","Title":"Kanbab.png","FileExtension":"png","ContentSize":74386}],"conList":[{"attributes":{"type":"Contact","url":"/services/data/v58.0/sobjects/Contact/0032t00000RN1z8AAD"},"Id":"0032t00000RN1z8AAD","Name":"Jack Rogers"}]}');
            resp.setStatusCode(200);
        }
        if(req.getMethod()=='POST'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('0682t00000I');
            resp.setStatusCode(200);
        }
        return resp;

    }
}