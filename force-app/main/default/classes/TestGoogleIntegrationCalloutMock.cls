@isTest
public class TestGoogleIntegrationCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req){
      
        HttpResponse resp=new HttpResponse();
        if(req.getEndpoint()=='https://accounts.google.com/o/oauth2/token'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"access_token": "ya29.a0AWY7CkkMKRXJVh_L_ITeutlbhaW9wNYN-RmT-6Q9nuiOlnAU7jAjmL9l_PMQiqopY07f6WviMrrLrnTqouKIA9kxjMLK7-2mIDUgLUXSOuBbYi3WcYRvEi8qe8OK8KgziEGG6U-6oHLGPb5fl8ixIf65WQ_YaCgYKAUMSARISFQG1tDrpYZCsCflwGKxMeOR26Oxstg0163","refresh_token": "1//0e3DguFI8bgNCCgYIARAAGA4SNwF-L9IrLgFZdZ_PNmynyfk_ah9AF0k1_ErqeBIRQ8MtO7ozPHJ8YC_aT2Dc9SX4HfXwR8mjDFQ"}');
            resp.setStatusCode(200);
        }
        else if(req.getEndpoint()=='https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(201);
        }
        else if(req.getMethod()=='GET'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('{"kind": "drive#fileList","mimeType": "application/vnd.google-apps.folder","id":"1zPCiAX9_hymnTfgW4Sswj7ccYb_HPAsk","name": "Demo","webViewLink": "https://drive.google.com/drive/folders/1zPCiAX9_hymnTfgW4Sswj7ccYb_HPAsk","webContentLink":" "}');
          	resp.setStatusCode(200);
            
        }
        else if(req.getMethod()=='DELETE'){
            resp.setHeader('Content-Type','applictaion/json');
            resp.setBody('');
          	resp.setStatusCode(204);
        }
        return resp;

    }
}