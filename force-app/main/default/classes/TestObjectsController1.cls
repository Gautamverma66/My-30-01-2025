@isTest
public class TestObjectsController1 {
   @testSetup
    static void setup(){
        List<Account> lt=TestDataFactory.createAccounts(23);
    }
    @isTest
  	 static void testobjFields() {
        ObjectsController1 obj=new ObjectsController1();
        obj.selectObject='Account';
		obj.objFields();
    }
     @isTest
  	 static void testAddButton() {
        ObjectsController1 obj=new ObjectsController1();
        obj.selectObject='Account';
        obj.objFields();
        obj.selectedList.add('Account Number');
        obj.selectedList.add('Account Name');
        obj.addButton();
       	System.assertEquals(true, obj.processButtonDis);
    }
     @isTest
  	 static void testRemoveButton() {
        ObjectsController1 obj=new ObjectsController1();
        obj.selectObject='Account';
        obj.objFields();
        obj.selectedList.add('Account Name');
        obj.selectedList.add('Account Number');
        obj.addButton();
         
        obj.reSelectedList.add('Account Name');
        obj.removeButton();
        System.assertEquals(true, obj.processButtonDis);
   
    }
     @isTest
  	 static void testProcessButton() {
        ObjectsController1 obj=new ObjectsController1();
        obj.processButton();   
        System.assertEquals(true, obj.compPageRe);
    }
    @isTest
    static void testResetButton() {
        ObjectsController1 obj=new ObjectsController1();
   
        obj.selectObject='Account';
        obj.objFields();
        obj.selectedList.add('Account Name');
        obj.selectedList.add('Account Number');
        obj.addButton();
         
        obj.reSelectedList.add('Account Name');
        obj.removeButton();
        obj.resetButton();
        System.assertEquals('None', obj.selectObject);
    }
   
}