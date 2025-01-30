@isTest
public with sharing class TestPaymentGatway {
    @isTest
    public static void testPayByAuthrizePayment(){
        Test.setMock(HttpCalloutMock.class,new TestPaymentGatwayMock());
        test.startTest();
        PaymentGatway.payByAuthrizePayment('41111111111111111','08','2025','1234');
        test.stopTest();

    }
    @isTest
    public static void testpayByEcheck(){
        Test.setMock(HttpCalloutMock.class,new TestPaymentGatwayMock());
        test.startTest();
        PaymentGatway.payByEcheck('122105812','000123456789','gautam');
        test.stopTest();

    }
    
}