@isTest
public  class TestContactStatusBatchClass {
    @TestSetup
    static void setup(){
        List<Contact> con=TestDataFactory.createContactYesterdayDate(10);
        System.debug('conlist in TEst Setup'+con);
    } 
    @isTest
    static void testBatchJob() {
        List<Contact> conVar=[Select Id,CreatedDate,status__c,BatchDate__c, BatchTime__c, BatchBoolean__c, BatchText__c from Contact];
        System.debug(conVar);
        // Start batch job
        Test.startTest();
        ContactStatusBatchClass batch = new ContactStatusBatchClass();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify results
        List<Contact> updatedContacts = [SELECT Id ,lastName, status__c  FROM Contact WHERE CreatedDate =YESTERDAY];
        for(Contact con : updatedContacts){
            System.assertEquals('Ready for Approval',con.Status__c);
        }
        
        
    }
    @isTest
    static void testSchdule(){
        Test.startTest();
        String sch = '0 5 * * * ?';
        System.schedule('testBasicScheduledApex',sch, new ContactStatusBatchClass());
        Test.stopTest();
    }
}