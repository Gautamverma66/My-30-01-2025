@isTest
public class TestKanbanView {
    @TestSetup
    static void setup(){
        List<Account> accList=TestDataFactory.createAccountsWithRating(2);
    } 
    @isTest
    static void testFatchObjects() {
        // Test fatchObjects() method
        Test.startTest();
        Map<String, String> result = KanbanViewController.fatchObjects();
        Test.stopTest();

    }

    @isTest
    static void testFetchPickListField() {
        // Test fetchPickListField() method
        String objNam='Account';
        Test.startTest();
        Map<String, String> result = KanbanViewController.fetchPickListField(objNam);
        Test.stopTest();

    }

    @isTest
    static void testFetchPickListFieldValue() {
        // Test fetchPickListFieldValue() method
        String fieldNam='Rating';
        String objNam='Account';
        Test.startTest();
        Map<Object, List<SObject>> result = KanbanViewController.fetchPickListFieldValue(fieldNam, objNam);
        Test.stopTest();

   
    }

    @isTest
    static void testUpdateRecords() {
        // Test updateRecords() method
        List<Account> accList=[Select Id,Rating from Account];
       
        ID recordId = accList[0].Id;
        String fieldValue = accList[0].Rating;
        String objName = 'Account';
        String newValue = 'Hot';
		Test.startTest();
        Map<Object, List<SObject>> result = KanbanViewController.updateRecords(recordId, fieldValue, objName, newValue);
        Test.stopTest();

       
    }

}