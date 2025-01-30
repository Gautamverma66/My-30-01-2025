@isTest
public with sharing class TestGoogleIntegration {
    @isTest
    static void testAuth(){
        test.startTest();  
        String authorizationUrl=GoogleIntegration.GoogleDriveAuthorizationUrl();
        test.stopTest();  

    }
    @isTest
    static void testAceessToken(){
        IntegrationDetail__c tempRec=new IntegrationDetail__c();
        tempRec.RecordType__c='Google';
        Insert tempRec;
        Test.setMock(HttpCalloutMock.class,new TestGoogleIntegrationCalloutMock());
        test.startTest();  
        GoogleIntegration.accessTokenGenerate('https://briskminds58-dev-ed.develop.my.site.com/Integration/s/?code=4%2F0AbUR2VPT4InsgMRYeNfykSGcbGY0u2kSEpN9erqipLKV596RfYAjGshG1Pxz71DfdrJZuA&scope=https%3A%2F%2Fwww');
        test.stopTest();  
    }
    
     @isTest
    static void testGetAceessTokenByRefreshTok(){
        Test.setMock(HttpCalloutMock.class,new TestGoogleIntegrationCalloutMock());
        test.startTest();  
        GoogleIntegration.fetchAccTokenUsingRefToken('1//0e3DguFI8bgNCCgYIARAAGA4SNwF-L9IrLgFZdZ_PNmynyfk_ah9AF0k1_ErqeBIRQ8MtO7ozPHJ8YC_aT2Dc9SX4HfXwR8mjDFQ');
        test.stopTest();  
    }
	@isTest
    static void testdelFile(){
        IntegrationDetail__c tempRec=new IntegrationDetail__c();
        tempRec.RecordType__c='Google';
        Insert tempRec;
        Test.setMock(HttpCalloutMock.class,new TestGoogleIntegrationCalloutMock());
        test.startTest();  
        GoogleIntegration.delFile('1234','root');
        test.stopTest();  
        
    }
    @isTest
    static void testcreateFolder(){
        IntegrationDetail__c tempRec=new IntegrationDetail__c();
        tempRec.RecordType__c='Google';
        Insert tempRec;
        Test.setMock(HttpCalloutMock.class,new TestGoogleIntegrationCalloutMock());
        test.startTest();  
        GoogleIntegration.createFolder('Gautam','root');
        test.stopTest();  
     
    }
    @isTest
    static void testuploadFileToDrive(){
         IntegrationDetail__c tempRec=new IntegrationDetail__c();
        tempRec.RecordType__c='Google';
        Insert tempRec;
        Test.setMock(HttpCalloutMock.class,new TestGoogleIntegrationCalloutMock());
        test.startTest();  
        GoogleIntegration.uploadFileToDrive('root','Gautam','gauti');
        test.stopTest(); 
    }
    
    @isTest
    static void testfetchUserDetails(){
        test.startTest();  
        GoogleIntegration.fetchUserDetails();
        test.stopTest(); 
    }

   
}