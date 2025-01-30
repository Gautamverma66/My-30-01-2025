/* 
Handler name      :   GoogleDriveIntegration
Created by        :   Gautam
Created on        :   12th May 2023
Last modified by  :   31th May 2023
Description       :   Integration with Google drive
*/
public class GoogleIntegration {

    
     /**************************************************************************************
    * @Description      This method is use for get Authorization of user it return Authorization url use for get auth code from auth server
    * @Parameter        None
    * @Return           its return authorization url
    ***************************************************************************************/
    @AuraEnabled
    public static String GoogleDriveAuthorizationUrl(){
        String communityUserId = UserInfo.getUserId();
        User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
        List<IntegrationDetail__c> commUserList=[Select Id,Contact__c,RecordType__c from IntegrationDetail__c where Contact__c=:communityUser.ContactId And RecordType__c='Google'];
        String authorizationUrl;
        if(commUserList.size()==0){
            List<Drive__mdt> customMetadataRecords = [SELECT AppKey__c, AppSecret__c FROM Drive__mdt];
            String clientId = customMetadataRecords[0].AppKey__c;
            String redirectUri = 'https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=2';
            String scope = 'https://www.googleapis.com/auth/drive';
            
            authorizationUrl = 'https://accounts.google.com/o/oauth2/auth' +
                '?client_id=' + clientId +
                '&redirect_uri=' + redirectUri +
                '&scope=' + EncodingUtil.urlEncode(scope, 'UTF-8') +
                '&access_type=offline&response_type=code';

            IntegrationDetail__c inte=new IntegrationDetail__c();
            if(communityUser!=null){
                inte.Contact__c=communityUser.ContactId;
            }
            inte.RecordType__c='Google';
            insert inte;
        }
        return authorizationUrl;
    }

    
    /**************************************************************************************
    * @Description      This method is use to get accessToken and refresh token using auth code in parameter we pass url string then get auth code and then after receive access token call fetchDriveFiles method to get google drive files
    * @Parameter        pass the auth code fetching from url
    * @Return           wrapper class (in wrapper class file data available)
    ***************************************************************************************/ 
    @AuraEnabled
    public static GoogleIntegrationWrapper accessTokenGenerate(String accessStr){
        System.debug(accessStr);
        String accessToken;
        String refreshToken;

        List<Drive__mdt> customMetadataRecords = [SELECT AppKey__c, AppSecret__c FROM Drive__mdt];
        String clientId = customMetadataRecords[0].AppKey__c;
        String clientSecret = customMetadataRecords[0].AppSecret__c;
        String redirectUri = 'https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?tabset-7b041=2';
    
        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();

        accessToken=commUserList[0].AccessToken__c;
        refreshToken=commUserList[0].RefreshToken__c;
       
        
        if(commUserList[0].AccessToken__c==null){
            String urlStr=accessStr;        
            Integer i=urlStr.indexOf('code');
            Integer j=urlStr.indexOf('&');
            String codeStr=urlStr.substring(i+5, j);
            System.debug('code-->'+codeStr);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://accounts.google.com/o/oauth2/token');
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody = 'code='+codeStr+'&client_id='+clientId+'&client_secret='+clientSecret+'&redirect_uri='+redirectUri+'&scope=&grant_type=authorization_code';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60*1000);
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            String resp;
            if (res.getStatusCode() == 200) {
                resp = res.getBody();
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(resp);
                accessToken = (String) responseMap.get('access_token');
                refreshToken = (String) responseMap.get('refresh_token');
            } 
            else {
                System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            } 
        
        }
        
       
        GoogleIntegrationWrapper fileDetails=fetchDriveFiles(accessToken,refreshToken);
       
        return fileDetails;
        
    }
    
    
    /**************************************************************************************
    * @Description      This method is use to get google drive files using access token and if access token is expire then it call fetchAccTokenUsingRefToken method to fetch access token agian using refresh token
    * @Parameter        pass the accessToken and refreshToken
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/ 
    @AuraEnabled
    public static GoogleIntegrationWrapper fetchDriveFiles(String accessToken,String refreshToken){
        
        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false&fields=*');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseBody;    
      
        GoogleIntegrationWrapper fileDetails;
        if (response.getStatusCode() == 200) {
            responseBody = response.getBody();
            System.debug('responseBody-> '+responseBody);
        }
        else {
            if(response.getStatusCode()==401){
               fileDetails= fetchAccTokenUsingRefToken(refreshToken);
            } 
            
        } 
        if(responseBody!=null){
            fileDetails=GoogleIntegrationWrapper.parse(responseBody);
            
            commUserList[0].AccessToken__c=accessToken;
            commUserList[0].RefreshToken__c=refreshToken;
            update commUserList;
        }
        return fileDetails;
    }
  
    /**************************************************************************************
    * @Description      This mehtod is use  to get Access token using refresh token its call when access token is expire
    * @Parameter        pass the  refreshToken
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/ 
    
    @AuraEnabled
    public static GoogleIntegrationWrapper fetchAccTokenUsingRefToken(String refreshToken){
       

        List<Drive__mdt> customMetadataRecords = [SELECT AppKey__c, AppSecret__c FROM Drive__mdt];
        String clientId = customMetadataRecords[0].AppKey__c;
        String clientSecret = customMetadataRecords[0].AppSecret__c;
        
        HttpRequest requ = new HttpRequest();
        requ.setEndpoint('https://accounts.google.com/o/oauth2/token');
        requ.setMethod('POST');
        requ.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String body = 'client_id=' +clientId
            + '&client_secret=' + clientSecret
            + '&refresh_token=' + refreshToken
            + '&grant_type=refresh_token';
        requ.setBody(body);
        
        HttpResponse respons = new Http().send(requ);
        GoogleIntegrationWrapper result=null;
        String accessToken;
        if (respons.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(respons.getBody());
            accessToken= (String) responseMap.get('access_token');
            result=fetchDriveFiles(accessToken,refreshToken);
        }
        else{
            List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
            delete commUserList;
        }
        return result;
        
    }

    /**************************************************************************************
    * @Description      This method is use to delete files of google drive
    * @Parameter        pass the  file Id and folder id
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/ 
    @AuraEnabled
    public static GoogleIntegrationWrapper delFile(String fileId,String folderId){
    
        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
        String accToken=commUserList[0].AccessToken__c;
        String refToken=commUserList[0].RefreshToken__c;
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/drive/v3/files/' + fileId);
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer '+accToken);
        
        HttpResponse response = new Http().send(request);
        
        GoogleIntegrationWrapper result;
        if (response.getStatusCode() == 204) {
            System.debug('response--> '+response.getBody());
            result=fetchDriveInsideFiles(folderId);
        } else {
            System.debug('An error occurred while deleting the file: ' + response.getBody());
        }
        
        return result;

    }
    

     /**************************************************************************************
    * @Description      This method is use to get Google drive files using the fileId
    * @Parameter        pass the  folder id
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/ 
    @AuraEnabled
    public static GoogleIntegrationWrapper fetchDriveInsideFiles(String folderId){
      
        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
        String accessToken=commUserList[0].AccessToken__c;
        String refreshToken=commUserList[0].RefreshToken__c;
        System.debug('accessToken '+accessToken);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/drive/v3/files?q=\''+folderId+'\'+in+parents&fields=*');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response--> '+response);
        String responseBody;
        GoogleIntegrationWrapper fileDetails;
        if (response.getStatusCode() == 200) {
            System.debug('flow 19');
            responseBody = response.getBody();
            System.debug('responseBody--> '+responseBody);
            fileDetails=GoogleIntegrationWrapper.parse(responseBody);
           
            
        }
        else {
            if(response.getStatusCode()==401){
                
               fileDetails= fetchAccTokenUsingRefToken(refreshToken);
            } 
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            
        } 
        
        return fileDetails;
    }

 
     /**************************************************************************************
    * @Description      This method is use to create new folder in google drive
    * @Parameter        pass the folder name and Parentfolder id
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/
    @AuraEnabled
    public static GoogleIntegrationWrapper createFolder(String folderName, String parentFolderId) {

        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
        String accessToken=commUserList[0].AccessToken__c;
        String refToken=commUserList[0].RefreshToken__c;
        String foldNam=folderName;
        if(foldNam==null){
            foldNam='New folder';
        }
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/drive/v3/files');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod('POST');
    
        // Create the request body
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('name', foldNam);
            requestBody.put('mimeType', 'application/vnd.google-apps.folder');
    
        if (parentFolderId != null) {
            List<String> parents = new List<String>();
            parents.add(parentFolderId);
            requestBody.put('parents', parents);
        }
        System.debug(requestBody);
        request.setBody(JSON.serialize(requestBody));
    
        Http http = new Http();
        HttpResponse response = http.send(request);
     
        GoogleIntegrationWrapper result;
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
      
            result=fetchDriveInsideFiles(parentFolderId);
           
        } else {
            System.debug('Error creating folder: ' + response.getStatusCode() + ' ' + response.getStatus());
           
        }
    
        return result;
    }
    
 
    /**************************************************************************************
    * @Description      This method is use to upload file in a folder
    * @Parameter        pass the folderId and  Filename and file content mimetype
    * @Return           it return list of wrapper class in wrapper class list every file name,id,type are available
    ***************************************************************************************/
    @AuraEnabled
    public static GoogleIntegrationWrapper uploadFileToDrive(String folderId, String fileName, String fileCon,String mimeType) {

        List<IntegrationDetail__c> commUserList=getCurrentUserRecord();
        String accessToken=commUserList[0].AccessToken__c;
        System.debug('fileCon--> '+fileCon);
        Blob fileBody = EncodingUtil.base64Decode(fileCon);
        System.debug('fileBody--> '+fileBody);
        // Create the request body
        String boundary = '----------9889464542212';
        String delimiter = '\r\n--' + boundary + '\r\n';
        String close_delim = '\r\n--' + boundary + '--';
        String httpMethod = 'POST';
        String endPoint =  'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';
        String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "name" : "' + fileName + '",' + ' "mimeType" : "' + mimeType + '",'+'"parents":["'+folderId+'"]}' + delimiter + 'Content-Type: ' + mimeType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + fileCon + close_delim;
        Map<String,String> header =  new Map<String,String>();
        header.put('Authorization', 'Bearer ' + accessToken);
        header.put('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        header.put('Content-length', String.valueOf(body.length()));
    
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
        request.setHeader('Content-length', String.valueOf(body.length()));
        request.setBody(body);
        request.setMethod(httpMethod);
        Http http = new Http();
        HttpResponse response = http.send(request);
        GoogleIntegrationWrapper files;
        if(response.getStatusCode()==200){
            files=fetchDriveInsideFiles(folderId);
        }
        else {
            System.debug('Error uploading file: ' + response.getStatusCode() + ' ' + response.getStatus());
           
        }
        
        return files;
    }
    
    
    /**************************************************************************************
    * @Description      This method is use to get the current user details
    * @Parameter        None
    * @Return           it return list of Current login user details
    ***************************************************************************************/
    @AuraEnabled
    public static List<String> fetchUserDetails(){
        List<String> userDet=new List<String>();
        String communityUserId = UserInfo.getUserId();
        User communityUser = [SELECT Name,Email,ContactId,FullPhotoUrl FROM User WHERE Id = :communityUserId LIMIT 1];
        Contact con;
        if(communityUser.ContactId!=null){
            con=[SELECT Name FROM Contact WHERE Id = :communityUser.ContactId LIMIT 1];
        }
       
        String name;
        if(con!=null){
            name=con.Name;
        }
        if(name==null){
            name=communityUser.Name;
        }
        String emailId=communityUser.Email;
        String photoUrl=communityUser.FullPhotoUrl;
        userDet.add(name);
        userDet.add(emailId);
        userDet.add(photoUrl);
        return userDet;
    }

     /**************************************************************************************
    * @Description      This method is use to get the current user object details
    * @Parameter        None
    * @Return           it return list of Current login user object details (AccessToken__c,RefreshToken__c)
    ***************************************************************************************/
    public static List<IntegrationDetail__c> getCurrentUserRecord(){
        String communityUserId = UserInfo.getUserId();
        User communityUser = [SELECT ContactId FROM User WHERE Id = :communityUserId LIMIT 1];
        List<IntegrationDetail__c> commUserList=[Select Id,Contact__c,AccessToken__c,RefreshToken__c,RecordType__c,ExpireTime__c from IntegrationDetail__c where Contact__c=:communityUser.ContactId And RecordType__c='Google'];
        return commUserList;
    }
    
}