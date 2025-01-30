@isTest
public with sharing class TestClientSidePagination {
    @testSetup
    static void setup(){
        List<Account> accountList=TestDataFactory.createAccounts(50);
    }
    @isTest
    static void testfetchObjects(){
        test.startTest();
        ClientSidePaginationLwc.fetchObjects();
        test.stopTest();
    }
    @isTest
    static void testfetchFields(){
        String objName='Account'; 
        test.startTest();
		ClientSidePaginationLwc.fetchFields(objName);
        test.stopTest();
        
    }
    @isTest
    static void testfetchRecord(){
        List<String> fieldList=new List<String>();
        List<ID> selectRecordsId=new List<ID>();
        fieldList.add('Name');
        String objName='Account'; 
        test.startTest();
		ClientSidePaginationLwc.fetchRecords(fieldList,objName);
        test.stopTest();
    }
}