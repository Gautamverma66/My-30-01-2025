@isTest
public with sharing class TestBoxIntegration {
    @TestSetup
    static void makeData(){
        insert new BoxIntegration__c(ClientId__c = '1234567890',ClientSecret__c='0987654321');
    }
    @isTest
    static void testAuth(){
        test.startTest();  
        String authorizationUrl=BoxIntegrationClass.boxAuthorizationUrl();
        test.stopTest();  

    }
    @isTest
    static void testGetTokens(){
        Insert new IntegrationDetail__c(RecordType__c='Box');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.getTokens('4%2F0AbUR2VPT4InsgMRYeNfykSGcbGY0u2kSEpN9erqipLKV596RfYAjGshG1Pxz71DfdrJZuA');
        test.stopTest();  
    }
    
    
	@isTest
    static void testdelFile(){
        Insert new IntegrationDetail__c(RecordType__c='Box',ExpireTime__c=System.now()+1,RefreshToken__c='JyLi9SIjeB1qruEa4TQFhTD8VrEQom9yNy5TIwKsKhaqX9eRjCnCP8L83HvCDej6');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.deleteFile('1234','folder','4321');
        BoxIntegrationClass.deleteFile('1234','file','4321');
        test.stopTest();  
        
    }
    @isTest
    static void testcreateFolder(){
        Insert new IntegrationDetail__c(RecordType__c='Box');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.folderCreate('Gautam','1234');
        test.stopTest();  
     
    }
    @isTest
    static void testcreateFolder1(){
        Insert new IntegrationDetail__c(RecordType__c='Box');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.folderCreate('','1234');
        test.stopTest();  
     
    }
    @isTest
    static void testuploadFileToDrive(){
        Insert new IntegrationDetail__c(RecordType__c='Box');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.uploadFile('12345','Gautam','4321','image/png');
        test.stopTest(); 
    }
     @isTest
    static void testuploadFileToDrive1(){
        Insert new IntegrationDetail__c(RecordType__c='Box');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.uploadFile('12345======','Gautam','4321==','image/png');
        test.stopTest(); 
    }
     @isTest
     static void testFileDownload(){
		Insert new IntegrationDetail__c(RecordType__c='Box',AccessToken__c='5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg');
        Test.setMock(HttpCalloutMock.class,new TestBoxIntegrationCalloutMock());
        test.startTest();  
        BoxIntegrationClass.fileDownload('1234');
        test.stopTest(); 
    }
    
    
    @isTest
    static void testCurrentUserRecord(){
        test.startTest();  
        boolean b=BoxIntegrationClass.checkUserExist();
        test.stopTest(); 
    }
    @isTest
    static void testCurrentUserRecord1(){
        Insert new IntegrationDetail__c(RecordType__c='Box',AccessToken__c='5jb1LK0kIazJ6bD1Pozb4Kr7RGgjK8sg');
        test.startTest();  
        boolean b=BoxIntegrationClass.checkUserExist();
        test.stopTest(); 
    }

   

}