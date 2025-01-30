@isTest
public with sharing class TestDropboxIntegration {
    @TestSetup
    static void makeData(){
        insert new DropboxIntegration__c(ClientId__c = '1234567890',ClientSecret__c='0987654321');
    }
    @isTest
    static void testCheckUserExist(){
        test.startTest();  
        String authorizationUrl=DropBoxIntegration.checkUserExist();
        test.stopTest();  

    }
    @isTest
    static void testAuthorizationUrl(){
        test.startTest();  
        String authorizationUrl=DropBoxIntegration.authorizationUrl();
        test.stopTest();  

    }
    @isTest
    static void testGetAccessToken(){
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.getAccessToken('4%2F0AbUR2VPT4InsgMRYeNfykSGcbGY0u2kSEpN9erqipLKV596RfYAjGshG1Pxz71DfdrJZuA');
        test.stopTest();  
    }
    @isTest
    static void testGetData(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.getData('');
        test.stopTest();  
    }
    @isTest
    static void testGetFileWhenAccessTokenExpire(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.getFileWhenAccessTokenExpire('');
        test.stopTest();  
    }
    
    @isTest
    static void testUploadToDropBox(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.uploadToDropBox('1234567890987654321','Demo','');
        test.stopTest();  
    }
    @isTest
    static void testDeleteData(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.deleteData('');
        test.stopTest();  
    }
    @isTest
    static void testDownloadFile(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.downloadFile('1234567890987654321');
        test.stopTest();  
    }
    @isTest
    static void testCreateFolder(){
        Insert new IntegrationDetail__c(RecordType__c='Dropbox',AccessToken__c='1234567890',RefreshToken__c='1234567890');
        Test.setMock(HttpCalloutMock.class,new TestDropboxIntegrationMock());
        test.startTest();  
        DropBoxIntegration.createFolder('','Demo1');
        test.stopTest();  
    }
    
    
}