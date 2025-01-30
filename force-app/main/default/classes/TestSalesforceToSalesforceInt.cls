@isTest
public with sharing class TestSalesforceToSalesforceInt {
   @isTest
   public static void testfetchContacts(){
    Test.setMock(HttpCalloutMock.class,new TestSalesforceToSalesforceCalloutMock());
    test.startTest();
    SalesforceToSalesforceInt.fetchContacts();
    test.stopTest();
   } 

   @isTest
   public static void testfetchFiles(){
    Test.setMock(HttpCalloutMock.class,new TestSalesforceToSalesforceCalloutMock());
    test.startTest();
    SalesforceToSalesforceInt.fetchFiles('123456789');
    test.stopTest();
   } 

   @isTest
   public static void testuploadFile(){
    Test.setMock(HttpCalloutMock.class,new TestSalesforceToSalesforceCalloutMock());
    test.startTest();
    SalesforceToSalesforceInt.uploadFile('123456789','Gautam.png','0987654321');
    test.stopTest();
   } 


}