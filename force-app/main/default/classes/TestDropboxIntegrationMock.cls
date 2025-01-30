@isTest
public with sharing class TestDropboxIntegrationMock implements HttpCalloutMock  {
    public HttpResponse respond(HttpRequest req){
      
        HttpResponse resp=new HttpResponse();
        if(req.getEndpoint()=='https://api.dropbox.com/oauth2/token'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"access_token": "5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg","refresh_token": "JyLi9SIjeB1qruEa4TQFhTD8VrEQom9yNy5TIwKsKhaqX9eRjCnCP8L83HvCDej6", "expires_in": 14400}');
            resp.setStatusCode(200);
        }
        else if(req.getMethod() == 'GET' ){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"entries": [{".tag": "folder", "name": "Trigger & Test", "path_lower": "/trigger & test", "path_display": "/Trigger & Test", "id": "id:iJ0mG_7NCoMAAAAAAAAABw"}]}');
          	resp.setStatusCode(200);
            
        }
        else if(req.getEndpoint() == 'https://content.dropboxapi.com/2/files/upload'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(201);
            
        }
        else if(req.getEndpoint() == 'https://api.dropboxapi.com/2/files/delete_v2'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(200);
        }
        else if(req.getEndpoint() == 'https://api.dropboxapi.com/2/files/get_temporary_link'){
            resp.setHeader('location','applictaionjson');
            resp.setBody('{"link":"qwertyuip"}');
          	resp.setStatusCode(200);
            
        }
        else if(req.getEndpoint()=='https://api.dropboxapi.com/2/files/create_folder_v2'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(200);
        }
       
        
        return resp;

    }
}