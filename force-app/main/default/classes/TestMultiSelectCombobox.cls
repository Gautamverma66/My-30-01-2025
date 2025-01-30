@isTest
public with sharing class TestMultiSelectCombobox {
    @TestSetup
    static void makeData(){
        List<Account> accList=TestDataFactory.createAccounts(20);
    }
    @isTest
    public static void testGetRecords(){
        List<Account> accList=[Select Id,Name from Account];
        test.startTest();
        List<Account> recList=MultiSelectComboboxController.getRecords();
        test.stopTest();
        System.assert(accList.size()==20,recList.size()==20);
    } 
}