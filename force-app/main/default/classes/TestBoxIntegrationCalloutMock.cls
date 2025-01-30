@isTest
public with sharing class TestBoxIntegrationCalloutMock implements HttpCalloutMock  {
    public HttpResponse respond(HttpRequest req){
      
        HttpResponse resp=new HttpResponse();
        if(req.getEndpoint()=='https://account.box.com/api/oauth2/authorize'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"access_token": "5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg", "expires_in"="4051","refresh_token": "JyLi9SIjeB1qruEa4TQFhTD8VrEQom9yNy5TIwKsKhaqX9eRjCnCP8L83HvCDej6"}');
            resp.setStatusCode(200);
        }
         else if(req.getEndpoint() == 'https://www.box.com/api/oauth2/token?'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"access_token": "5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg","refresh_token":"JyLi9SIjeB1qruEa4TQFhTD8VrEQom9yNy5TIwKsKhaqX9eRjCnCP8L83HvCDej6","expires_in": "3600"}');
          	resp.setStatusCode(200);
        }
         else if(req.getEndpoint() == 'https://api.box.com/oauth2/token'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"access_token": "5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg","refresh_token":"JyLi9SIjeB1qruEa4TQFhTD8VrEQom9yNy5TIwKsKhaqX9eRjCnCP8L83HvCDej6","expires_in": 3600}');
          	resp.setStatusCode(200);
        }
        else if(req.getMethod() == 'GET' && req.getEndpoint() != 'https://api.box.com/2.0/files/1234/content'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"type": "image.png","id":"1zPCiAX9_hymnTfgW4Sswj7ccYb_HPAsk","name": "Demo","etag":" "}');
          	resp.setStatusCode(200);
            
        }
        else if(req.getEndpoint() == 'https://upload.box.com/api/2.0/files/content?parent_id=4321'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(201);
            
        }
        else if(req.getEndpoint() == 'https://api.box.com/2.0/folders'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(201);
        }
        else if(req.getEndpoint() == 'https://api.box.com/2.0/files/1234/content'){
            resp.setHeader('location','applictaionjson');
            
        }
        else if(req.getMethod()=='DELETE'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(204);
        }
       
        
        return resp;

    }
}