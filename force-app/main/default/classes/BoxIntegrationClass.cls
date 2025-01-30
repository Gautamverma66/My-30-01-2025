/* 
Handler name      :   BoxIntegration
Created by        :   Gautam
Created on        :   12th June 2023
Last modified by  :   16th June 2023
Description       :   Integration with Box.com
*/

public class BoxIntegrationClass {

    /**************************************************************************************
    * @Description     Check the current login user record is created or not
    * @Parameter        None
    * @Return           Boolean
    ***************************************************************************************/
    @AuraEnabled(cacheable=true)
    public static boolean checkUserExist(){
        
        List<IntegrationDetail__c> commUserList = getCurrentUserRecord();
        if(commUserList.size() != 0 && commUserList[0].AccessToken__c != null){
            return true;
        }
        return false;
    }

    /**************************************************************************************
    * @Description      generate the authorization url using client id ,endpoint and redirect url 
    * @Parameter        None
    * @Return           its return authorization url
    ***************************************************************************************/
    @AuraEnabled
    public static String boxAuthorizationUrl(){
        List<IntegrationDetail__c> commUserList = getCurrentUserRecord();
        List<BoxIntegration__c> customSetting = [SELECT ClientId__c FROM BoxIntegration__c];
        String clientId = customSetting[0].ClientId__c;
        String endPoint ='https://account.box.com/api/oauth2/authorize';
        String redirectUri = 'https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=3';
        String authorizationUrl;
        if(commUserList.size() == 0 ){
            authorizationUrl = BoxIntegrationService.authorizationString(endPoint,clientId,redirectUri);
            String communityUserId = UserInfo.getUserId();
            User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
            IntegrationDetail__c newRec = new IntegrationDetail__c(Contact__c=communityUser.ContactId,RecordType__c='Box');
            insert newRec;
        }
        return authorizationUrl;
    }

    /**************************************************************************************
    * @Description      this method is use to generate the access token using the auth code and then update the current user record
    * @Parameter        pass the auth code fetching from url
    * @Return           Boolean(if access and refresh token get its return true otherwise false return)
    ***************************************************************************************/    

    @AuraEnabled
    public static boolean getTokens(String oauthCode){

        List<BoxIntegration__c> customSetting = [SELECT ClientId__c,ClientSecret__c FROM BoxIntegration__c];
        String redirectUri = 'https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=3';
        String httpMethod = 'POST';
        String endPoint =  'https://api.box.com/oauth2/token';
        Map<String,String> header =  new Map<String,String>();
        header.put('content-type', 'application/x-www-form-urlencoded');
        String body = 'code='+oauthCode+'&client_id='+customSetting[0].ClientId__c+'&client_secret='+customSetting[0].ClientSecret__c+'&redirect_uri='+redirectUri+'&grant_type=authorization_code';
        blob base64EncodeFile = null;
        HttpResponse res = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
        Map<String, Object> res_data_Map = new Map<String, Object>();

        if(res.getStatusCode() == 200){
            String resp = res.getBody();
            res_data_Map = (Map<String, Object>) JSON.deserializeUntyped(resp);
            String communityUserId = UserInfo.getUserId();
            User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
            List<IntegrationDetail__c> commUserList = [Select Id,Contact__c,AccessToken__c,RefreshToken__c,RecordType__c from IntegrationDetail__c where Contact__c=:communityUser.ContactId And RecordType__c='Box'];
            if (commUserList.size() != 0) {
                commUserList[0].RefreshToken__c = (String)res_data_Map.get('refresh_token');
                commUserList[0].AccessToken__c= (String)res_data_Map.get('access_token');
                commUserList[0].ExpireTime__c = System.now().addSeconds((Integer)res_data_Map.get('expires_in'));
                update commUserList;
            }
            return true;
        }
        else{
            System.debug(res);
        }
        return false;

    }


    /**************************************************************************************
    * @Description      this method is use to get files from box.com make callout to get files if access token expire then call handleOnAccessTokenexpire method to get new aceess token using refresh token
    * @Parameter        pass the folder id which folder files you want to get
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/    
    @AuraEnabled
    public static List<BoxIntegrationWrapper> getFiles(String foldId){
        List<IntegrationDetail__c> commUserList = getCurrentUserRecord();
        List<BoxIntegration__c> customSetting = [SELECT ClientId__c FROM BoxIntegration__c];
        String httpMethod = 'GET';
        String endPoint =  'https://api.box.com/2.0/folders/'+foldId+'/items';
        Map<String,String> header =  new Map<String,String>();
        header.put('content-type', 'application/x-www-form-urlencoded');
        header.put('Authorization', 'Bearer '+ commUserList[0].AccessToken__c);
        String body = '';
        blob base64EncodeFile = null;
        List<BoxIntegrationWrapper> wrapData;
        if(commUserList[0].ExpireTime__c>System.now()){
            HttpResponse res = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
            if(res.getStatusCode() == 200){
                System.debug(res.getBody());
                Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String serializeFile = JSON.serialize(fileData.get('entries'));
                wrapData = (List<BoxIntegrationWrapper>) JSON.deserialize(serializeFile, List<BoxIntegrationWrapper>.class);
                
            }
            else if(res.getStatusCode() == 401){
                wrapData=handleOnAccessTokenexpire(commUserList[0].RefreshToken__c,foldId);
            }
            else{
                System.debug(res.getBody());
            }
            
        }
        else{
            wrapData=handleOnAccessTokenexpire(commUserList[0].RefreshToken__c,foldId);
        }

        return wrapData;

    }

    /**************************************************************************************
    * @Description      this method is use when access token is expire then this method call from getfile method this method first get access token then get files of given folder id
    * @Parameter        pass the refresh token and folder id (refresh token use in to genrate access token and folder id is use to fetch files of this folder)
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/  
    public static List<BoxIntegrationWrapper> handleOnAccessTokenexpire(String refToken,String foldId){
        List<IntegrationDetail__c> commUserList = getCurrentUserRecord();
        List<BoxIntegrationWrapper> wrapData;
    
        String accessResponse = getAccessToken(refToken);
        if(accessResponse !=null){
            Map<String, Object> accessMetadata_Map = (Map<String, Object>) JSON.deserializeUntyped(accessResponse);
            String accToken = (String)accessMetadata_Map.get('access_token');

            String httpMethod = 'GET';
            String endPoint =  'https://api.box.com/2.0/folders/'+foldId+'/items';
            String body = '';
            blob base64EncodeFile = null;
            Map<String,String> headerOnError =  new Map<String,String>();
            headerOnError.put('content-type', 'application/x-www-form-urlencoded');
            headerOnError.put('Authorization', 'Bearer '+ accToken);

            HttpResponse dataResponseOnError = BoxIntegrationService.calloutResponse(httpMethod, endPoint, headerOnError, body, base64EncodeFile);

            if(dataResponseOnError.getStatusCode() == 200){

                Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(dataResponseOnError.getBody());
                String serializeFile = JSON.serialize(fileData.get('entries'));
                wrapData = (List<BoxIntegrationWrapper>) JSON.deserialize(serializeFile, List<BoxIntegrationWrapper>.class);
                commUserList[0].AccessToken__c = accToken;
                commUserList[0].RefreshToken__c=(String)accessMetadata_Map.get('refresh_token');
                commUserList[0].ExpireTime__c = System.now().addSeconds((Integer)accessMetadata_Map.get('expires_in'));
                update commUserList;
                
            }
            else {
                System.debug(dataResponseOnError.getBody());                    
            }
        }
        else{
            delete commUserList;
        }

        
        return wrapData;
    }

    /**************************************************************************************
    * @Description      this method is use to get new access token using refresh token
    * @Parameter        pass the refresh token (refresh token use in to genrate access token)
    * @Return           it return the HttpResponse body (in body new access token and expire time available )
    ***************************************************************************************/  
    @AuraEnabled
    public static string getAccessToken(String refreshToken){

        List<BoxIntegration__c> customSetting = [SELECT ClientId__c,ClientSecret__c FROM BoxIntegration__c];
        String httpMethod = 'POST';
        String endPoint =  'https://api.box.com/oauth2/token';
        Map<String,String> header =  new Map<String,String>();
        header.put('content-type', 'application/x-www-form-urlencoded');
        String body = 'client_id='+customSetting[0].ClientId__c+'&client_secret='+customSetting[0].ClientSecret__c+
        '&refresh_token='+refreshToken+'&grant_type=refresh_token';
        blob base64EncodeFile = null;
        HttpResponse res = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
        String accessResponse;
        if(res.getStatusCode() == 200){
            accessResponse = res.getBody();
            
        }
        else if(res.getStatusCode() == 400){
            System.debug(res.getStatusCode());
            System.debug(res.getBody());
    
        }else{
            System.debug(res.getStatusCode());
        }
        return accessResponse;

    }

     /**************************************************************************************
    * @Description      this method is use to Download the files
    * @Parameter        pass the file id which file you want to download
    * @Return           it return the file download url string
    ***************************************************************************************/  
    @AuraEnabled
    public static string fileDownload(String fileId){
            List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
            String httpMethod = 'GET';
            String endPoint ='https://api.box.com/2.0/files/'+fileId+'/content';
            Map<String,String> header =  new Map<String,String>();
            header.put('content-type', 'application/json');
            header.put('Authorization', 'Bearer '+commUserList[0].AccessToken__c);
            String body = '';
            blob base64EncodeFile = null;
            HttpResponse res = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
            return res.getHeader('location');
    }

    /**************************************************************************************
    * @Description      this method is use to delete the files and folder
    * @Parameter        pass the file id which file you want to delete and file type(file/folder) and parent folder id to fetch again same folder files
    * @Return            it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/
    @AuraEnabled
    public static  List<BoxIntegrationWrapper> deleteFile(String fileId, String fileType, String foldId){
            List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
            String httpMethod = 'DELETE';
            String endPoint ='';
            if(fileType=='folder'){
                endPoint =  'https://api.box.com/2.0/folders/'+fileId+'?recursive=true';
            }
            else{
                endPoint =  'https://api.box.com/2.0/files/'+fileId;
            }

            Map<String,String> header =  new Map<String,String>();
            header.put('content-type', 'application/json');
            header.put('Authorization', 'Bearer '+commUserList[0].AccessToken__c);
            String body = '';
            blob base64EncodeFile = null;
            HttpResponse res = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
            List<BoxIntegrationWrapper> wrapData;
            if(res.getStatusCode() == 204){
                wrapData=getFiles(foldId);
            }
            else{
                System.debug(res.getStatusCode());
                System.debug(res.getBody());
            }
            return wrapData;
    }
    /**************************************************************************************
    * @Description      this method is use to create new folder
    * @Parameter        pass the folder id in which folder you want to create folder and new folder name
    * @Return            it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/
    @AuraEnabled
    public static  List<BoxIntegrationWrapper> folderCreate(String foldName, String foldId){
            String folderName=foldName;
            if(folderName==''){
                folderName='New Folder';
            }
            List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
            String httpMethod = 'POST';
            String endPoint =  'https://api.box.com/2.0/folders';
            Map<String,String> header =  new Map<String,String>();
            header.put('content-type', 'application/json');
            header.put('Authorization', 'Bearer '+commUserList[0].AccessToken__c);
            String body = '{"name": "' + folderName +'","parent":{"id":"'+foldId+'"}}';
            blob base64EncodeFile = null;
            HttpResponse resp = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
            List<BoxIntegrationWrapper> wrapData;
            if(resp.getStatusCode()==201){
                wrapData=getFiles(foldId);
            }
            else if(resp.getStatusCode()==409){
                wrapData=getFiles(foldId);
               System.debug('body-->'+resp.getBody());
            }
            return wrapData;
    }

    /**************************************************************************************
    * @Description      this method is use to upload file 
    * @Parameter        pass the folder id in which folder you want to upload file and new file name,base64 (file content)
    * @Return            it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/
    @AuraEnabled
    public static  List<BoxIntegrationWrapper> uploadFile(String base64, String filename, String folderId,String fileType){
        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
        List<BoxIntegrationWrapper> wrapData; 
        if(base64!=null){
                blob base64EncodeFile = base64EncodeFileContent(EncodingUtil.base64Decode(base64),filename);
                String boundary = '----------------------------741e90d31eff';
                String httpMethod = 'POST';
                String endPoint = 'https://upload.box.com/api/2.0/files/content?parent_id='+folderId;
                Map<String,String> header =  new Map<String,String>();
                header.put('Content-Type','multipart/form-data; boundary='+boundary);
                header.put('Authorization', 'Bearer '+commUserList[0].AccessToken__c);
                String body = '{"name":"' + filename + '", "type":"'+fileType+'" , "parent":{"id":"' + folderId + '"}}';
                HttpResponse resp = BoxIntegrationService.calloutResponse(httpMethod, endPoint, header, body, base64EncodeFile);
                
                if(resp.getStatusCode()==201){
                    wrapData=getFiles(folderId);
                }else{
                    System.debug('body--> '+resp.getBody());
                }
            }else{
                System.debug('base64--> '+base64);
            }
       return wrapData;
    }

    /**************************************************************************************
    * @Description      this method is use in upload file  to convert file content into blob
    * @Parameter        pass the file body and file name
    * @Return           it return the blob of file content
    ***************************************************************************************/
    public static blob base64EncodeFileContent(Blob file_body, String file_name){
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
        String footer = '--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(file_body);
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }
        return bodyBlob;
    }
  
    public static List<IntegrationDetail__c> getCurrentUserRecord(){
        String communityUserId = UserInfo.getUserId();
        User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
        List<IntegrationDetail__c> commUserList=[Select Id,Contact__c,AccessToken__c,RefreshToken__c,RecordType__c,ExpireTime__c from IntegrationDetail__c where Contact__c=:communityUser.ContactId And RecordType__c='Box'];
        return commUserList;
    }

}