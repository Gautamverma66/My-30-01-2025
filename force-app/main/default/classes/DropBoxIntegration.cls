/* 
Handler name      :   DropboxIntegration
Created by        :   Gautam
Created on        :   27th June 2023
Last modified by  :   03th July 2023
Description       :   Integration with Dropbox
*/
public with sharing class DropBoxIntegration {

    /**************************************************************************************
    * @Description     Check the current login user record is created or not
    * @Parameter        None
    * @Return           String(true,false)
    ***************************************************************************************/
    @AuraEnabled
    public static String checkUserExist() { 
        try {
            List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
            if(existingUser.size() != 0) {
                return 'true';
            }
            return 'false';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**************************************************************************************
    * @Description      generate the authorization url using client id ,endpoint and redirect url 
    * @Parameter        None
    * @Return           its return authorization url
    ***************************************************************************************/
    @AuraEnabled
    public static String authorizationUrl() {
        List<DropboxIntegration__c> customSetting = [SELECT ClientId__c FROM DropboxIntegration__c];
        String clientId = customSetting[0].ClientId__c;
        String redirectUrl='https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=7d90e';
        String authorization = 'https://www.dropbox.com/oauth2/authorize?response_type=code&token_access_type=offline&client_id=';
        authorization = authorization +customSetting[0].ClientId__c;
        authorization = authorization + '&redirect_uri=';
        authorization = authorization + redirectUrl;
        return authorization;
    }
 
    /**************************************************************************************
    * @Description      this method is use to generate the access token using the auth code and then update the current user record
    * @Parameter        pass the auth code fetching from url
    * @Return           Boolean(if access and refresh token get its return true otherwise false return)
    ***************************************************************************************/  
    @AuraEnabled
    public static Boolean getAccessToken(String code) {
        System.debug('token');
        String communityUserId = UserInfo.getUserId();
        User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
        IntegrationDetail__c d = new IntegrationDetail__c();
        List<DropboxIntegration__c> customSetting = [SELECT ClientId__c,ClientSecret__c FROM DropboxIntegration__c];
        String redirectUrl='https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=7d90e';
        String endPoint = 'https://api.dropbox.com/oauth2/token'; 
        System.debug(code);
        System.debug(customSetting[0].ClientId__c);
        System.debug(customSetting[0].ClientSecret__c);

        String body =  'code='+code+'&client_id='+customSetting[0].ClientId__c+'&client_secret='+customSetting[0].ClientSecret__c+'&redirect_uri='+redirectUrl+'&grant_type=authorization_code';
        String method='POST';
        Map<String,String> header =  new Map<String,String>();
        header.put('content-type', 'application/x-www-form-urlencoded');
        blob base64EncodeFile = null;
        HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
        System.debug(resp);
        System.debug(resp.getBody());
        String accesstoken;
        if(resp.getStatusCode() == 200){
            System.JSONParser jp = JSON.createParser(resp.getBody()); 
            Datetime expireIn;
            
            String refreshtoken;
            d.Contact__c = communityUser.ContactId;
            d.RecordType__c='Dropbox';
            while(jp.nextToken() != null) {
                if(jp.getText() == 'access_token') {
                    jp.nextToken();
                    accesstoken = jp.getText();
                    d.AccessToken__c = accesstoken;
                }
                if(jp.getText() == 'refresh_token') {
                    jp.nextToken();
                    refreshtoken = jp.getText();
                    d.RefreshToken__c = refreshtoken;
                }
                if(jp.getText() == 'expires_in') {
                    jp.nextToken();
                    expireIn = System.now().addSeconds(jp.getIntegerValue());
                    d.ExpireTime__c = expireIn;
                }
            }
            insert d;
        }
       
        if(accesstoken != null){
            return true;
        }
        return false;
    }
    
    /**************************************************************************************
    * @Description      this method is use to get files from box.com make callout to get files if access token expire then call handleOnAccessTokenexpire method to get new aceess token using refresh token
    * @Parameter        pass the folder id which folder files you want to get
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type,etag are available
    ***************************************************************************************/    
    @AuraEnabled
    public static List<WrapperClass> getData(String path) {
        List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
        System.debug(existingUser);
        String endPoint = 'https://api.dropboxapi.com/2/files/list_folder'; 
        String body =  '{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":\"'+path+'\",\"recursive\":false}';
        String method='GET';
        Map<String,String> header =  new Map<String,String>();
        System.debug(existingUser[0].AccessToken__c);
        header.put('Authorization', 'Bearer ' + existingUser[0].AccessToken__c);
        header.put('Content-Type', 'application/json');
        blob base64EncodeFile = null;
        HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
        List<WrapperClass> wrapData;
        System.debug('resBody-->'+resp.getBody());
        if(resp.getStatusCode() == 200){
            String resBody=resp.getBody();
            String r = resBody.replace('.tag','tag');
            Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(r);
            String serializeFile = JSON.serialize(fileData.get('entries'));
            wrapData = (List<WrapperClass>) JSON.deserialize(serializeFile, List<WrapperClass>.class);
            for(WrapperClass w : wrapData) {
                if(w.tag == 'folder') {
                    w.isFolder = true;
                } else {
                    w.isFile = true;
                }
            }
            return wrapData;
        }
        else if(resp.getStatusCode() == 401){
            return getFileWhenAccessTokenExpire(path);
        }
        else{
            System.debug(resp);
            System.debug(resp.getBody());
        }
        return null;
        
    }

    // Method to get data or files from box when error 401 or access token time expired
    public static List<WrapperClass> getFileWhenAccessTokenExpire(String folderId){
        try {
            List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
            String httpMethod = 'GET';
            String endPoint =  'https://api.dropboxapi.com/2/files/list_folder';
            String accessResponse = getAccessTokenUsingRefToken(existingUser[0].RefreshToken__c);
                Map<String, Object> accessMetadata_Map = (Map<String, Object>) JSON.deserializeUntyped(accessResponse);
                String accToken = (String)accessMetadata_Map.get('access_token');
                Map<String,String> headerOnError =  new Map<String,String>();
                headerOnError.put('content-type', 'application/json');
                headerOnError.put('Authorization', 'Bearer '+ accToken);
                String body =('{\"include_deleted\":false,\"include_has_explicit_shared_members\":false,\"include_media_info\":false,\"include_mounted_folders\":true,\"include_non_downloadable_files\":true,\"path\":"'+folderId+'",\"recursive\":false}');
                blob base64EncodeFile = null;
                HttpResponse dataResponseOnError = DropBoxService.calloutRequest(httpMethod, endPoint, headerOnError, body, base64EncodeFile);
                if(dataResponseOnError.getStatusCode() == 200){
                    String dataResStrOnError = dataResponseOnError.getBody();
                    Datetime updatedExpireIn = System.now().addSeconds((Integer)accessMetadata_Map.get('expires_in'));
                    existingUser[0].AccessToken__c=(String)accessMetadata_Map.get('access_token');
                    existingUser[0].ExpireTime__c=updatedExpireIn;
                    update existingUser;
                    
                    Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(dataResStrOnError);
                    String serializeFile = JSON.serialize(fileData.get('entries'));
                    List<WrapperClass> wrapData = (List<WrapperClass>) JSON.deserialize(serializeFile, List<WrapperClass>.class);
                    for(WrapperClass w : wrapData) {
                        if(w.tag == 'folder') {
                            w.isFolder = true;
                        } else {
                            w.isFile = true;
                        }
                    }
                    return wrapData;
                }
                return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     //Method to get access token from refresh token if expired or manually changed
     @AuraEnabled
     public static string getAccessTokenUsingRefToken(String refreshToken){
         try {
            List<DropboxIntegration__c> customSetting = [SELECT ClientId__c,ClientSecret__c FROM DropboxIntegration__c];
             String httpMethod = 'POST';
             String endPoint =  'https://api.dropbox.com/oauth2/token';
             Map<String,String> header =  new Map<String,String>();
             header.put('content-type', 'application/x-www-form-urlencoded');
             String body = 'client_id='+customSetting[0].ClientId__c+'&client_secret='+customSetting[0].ClientSecret__c+
             '&refresh_token='+refreshToken+'&grant_type=refresh_token';
             blob base64EncodeFile = null;
             HttpResponse res = DropBoxService.calloutRequest(httpMethod, endPoint, header, body, base64EncodeFile);
             System.debug('resBody-->'+res.getBody());
             if(res.getStatusCode() == 200){
                 String accessResponse = res.getBody();
                 return accessResponse; 
             }else{
                 System.debug(res.getBody());
             }
             return null;   
         } catch (Exception e) {
             throw new AuraHandledException(e.getMessage());
         }
     }
    /**************************************************************************************
    * @Description      this method is use to upload file 
    * @Parameter        pass the folder id in which folder you want to upload file and new file name,file content
    * @Return           boolean
    ***************************************************************************************/
    @AuraEnabled
    public static void uploadToDropBox(String file, String filename,String path) {
        try {
            if(path == '') {
                path = '/';
                path = path+filename;
            } else {
                path = path+'/'+filename;
            }
            List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
            String endPoint = 'https://content.dropboxapi.com/2/files/upload'; 
            String body =  '';
            String method='POST';
            Map<String,String> header =  new Map<String,String>();
            header.put('Authorization', 'Bearer ' + existingUser[0].AccessToken__c);
            header.put('Dropbox-API-Arg', '{\"autorename\":false,\"mode\":\"add\",\"mute\":false,\"path\":\"'+path+'\",\"strict_conflict\":false}');
            header.put('content-type', 'application/octet-stream');
           
            blob base64EncodeFile =  EncodingUtil.base64Decode(file);
           
            HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
            System.debug(resp);
        }
        catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
     /**************************************************************************************
    * @Description      this method is use to delete the files and folder
    * @Parameter        pass the file id which file you want to delete and file type(file/folder) and parent folder id to fetch again same folder files
    * @Return           none
    ***************************************************************************************/
    @AuraEnabled
    public static void deleteData(String path) {
        try {
            List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
            String endPoint = 'https://api.dropboxapi.com/2/files/delete_v2';
            String body =  ('{\"path\":"'+path+'"}');
            String method='POST';
            Map<String,String> header =  new Map<String,String>();
            header.put('Authorization', 'Bearer ' + existingUser[0].AccessToken__c);
            header.put('content-type', 'application/json');
            blob base64EncodeFile =  null;
            HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
            System.debug(resp);
            System.debug(resp.getBody());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**************************************************************************************
    * @Description      this method is use to Download the files
    * @Parameter        pass the file id which file you want to download
    * @Return           it return the file download link 
    ***************************************************************************************/ 
    @AuraEnabled
    public static Object downloadFile(String path){
        try {
            List<IntegrationDetail__c> existingUser = getCurrentUserRecord();
            String endPoint = 'https://api.dropboxapi.com/2/files/get_temporary_link'; 
            String body =  ('{\"path\":"'+path+'"}');
            String method='POST';
            Map<String,String> header =  new Map<String,String>();
            header.put('Authorization', 'Bearer ' + existingUser[0].AccessToken__c);
            header.put('content-type', 'application/json');
            blob base64EncodeFile =  null;
            HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
            System.debug(resp);
            Map<String,Object> data = (Map<String,Object>)JSON.deserializeUntyped(resp.getBody());
            return data.get('link');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    /**************************************************************************************
    * @Description      this method is use to create new folder
    * @Parameter        pass the folder id in which folder you want to create folder and new folder name
    * @Return           None
    ***************************************************************************************/
    @AuraEnabled
    public static Void createFolder(String path, String folderName) {
        try {
            if(folderName != null){
                folderName='New Folder';
            }
            String pathFold = '';
            pathFold = path +'/'+folderName;
            List<IntegrationDetail__c> existingUser =  getCurrentUserRecord();
            String endPoint = 'https://api.dropboxapi.com/2/files/create_folder_v2'; 
            String body =  ('{\"path\":"'+pathFold+'"}');
            String method='POST';
            Map<String,String> header =  new Map<String,String>();
            header.put('Authorization', 'Bearer ' + existingUser[0].AccessToken__c);
            header.put('content-type', 'application/json');
            blob base64EncodeFile =  null;
            HttpResponse resp = DropBoxService.calloutRequest(method, endPoint, header, body, base64EncodeFile);
            System.debug(resp);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class WrapperClass{
        @AuraEnabled public String tag;
        @AuraEnabled public String name;
        @AuraEnabled public String path_display;
        @AuraEnabled public String id;
        @AuraEnabled public boolean isFolder;
        @AuraEnabled public boolean isFile;
   }
   public static List<IntegrationDetail__c> getCurrentUserRecord(){
    String communityUserId = UserInfo.getUserId();
    User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
    List<IntegrationDetail__c> commUserList=[Select Id,Contact__c,AccessToken__c,RefreshToken__c,RecordType__c,ExpireTime__c from IntegrationDetail__c where Contact__c=:communityUser.ContactId And RecordType__c='Dropbox'];
    return commUserList;
}
}