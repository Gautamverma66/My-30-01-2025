@isTest
public class TestContactTriggerHandler {
    @TestSetup
    static void setup(){
        List<Account> accList=TestDataFactory.createAccounts(2);
        List<Contact> conList=TestDataFactory.createContactWithAcc(10,accList[0]);
        List<Contact> contactList=TestDataFactory.createContactWithAcc(10,accList[1]);
    } 
    
    @isTest
    static void testInsertCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id];
        List<Contact> newConList=new List<Contact>();
        for(Integer i=1;i<=2;i++){
            newConList.add(new Contact(AccountId=accList[0].Id,LastName='Testdemo'+i,Sequence_Number__c=2));
        }
        Test.startTest();
        Insert newConList;
        Test.stopTest();
        List<Contact> totalCon=[Select Id From Contact Where AccountId=:accList[0].Id];
        System.assertEquals(totalCon.size()==12, true);
    }
    @isTest
    static void testAllDeleteCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id];
        Test.startTest();
        Database.DeleteResult []result=Database.delete(conList,false);
        Test.stopTest();
        List<Contact> resConList=[Select Id from Contact where AccountId=:accList[0].Id];
        System.assertEquals(resConList.size()==0, true);
        
    }
    @isTest
    static void testDeleteCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id];
        Test.startTest();
        Database.DeleteResult result=Database.delete(conList[0],false);
        Test.stopTest();
        List<Contact> resConList=[Select Id from Contact where AccountId=:accList[0].Id];
        System.assertEquals(resConList.size()==9, true);
       
    }
    @isTest
    static void testUndeleteCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id ];
        List<Contact> delList=new List<Contact>();
        for(Integer i=1;i<=2;i++){
            delList.add(conList[i]);
        }
        delete delList;
        
        List<Contact> undeleteList=[Select Id,LastName from Contact where AccountId=:accList[0].Id And Id In :delList  ALL ROWS];
        Test.startTest();
        undelete undeleteList;
        Test.stopTest();
        List<Contact> resConList=[Select Id from Contact where AccountId=:accList[0].Id ];
        System.assertEquals(resConList.size()==10, true);
       
        
    }
    @isTest
    static void testUpdateNullCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id order by Sequence_Number__c ];
        
        List<Contact> updateList=new List<Contact>();
        for(Integer i=0;i<5;i++){
            conList[i].Sequence_Number__c=0;
            updateList.add(conList[i]);
        }
        Test.startTest();
        update updateList;
        Test.stopTest();
        
    }
    @isTest
    static void testUpdateDownCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id order by Sequence_Number__c ];
        
        List<Contact> updateList=new List<Contact>();
        for(Integer i=1;i<=3;i++){
            conList[i].Sequence_Number__c=i+4;
            updateList.add(conList[i]);
        }
       
        Test.startTest();
         update updateList;
        Test.stopTest();
        
        
    }
    @isTest
    static void testUpdateUpCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id order by Sequence_Number__c ];
        
        List<Contact> updateList=new List<Contact>();
        for(Integer i=4;i<=6;i++){
            conList[i].Sequence_Number__c=i-2;
            updateList.add(conList[i]);
        }
       Test.startTest();
        update updateList;
       Test.stopTest();
       
        
    }

    @isTest
    static void testUpdateReparentCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id order by Sequence_Number__c ];
        
        List<Contact> updateList=new List<Contact>();
        for(Integer i=1;i<=3;i++){
            conList[i].AccountId=accList[1].Id;
            conList[i].Sequence_Number__c=0;
            updateList.add(conList[i]);
        }
        Test.startTest();
        update updateList;
        Test.stopTest();
      	List<Contact> resConList=[Select Id from Contact where AccountId=:accList[0].Id ];
        System.assertEquals(resConList.size()==7, true);
        
    }
    @isTest
    static void testUpdateReparentingCase(){
        List<Account> accList=[Select Id from Account];
        List<Contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[0].Id order by Sequence_Number__c ];
        List<Contact> ContactList=[Select Id,LastName,AccountId,Sequence_Number__c from Contact where AccountId=:accList[1].Id order by Sequence_Number__c ];
        List<Contact> updateList=new List<Contact>();
        for(Integer i=1;i<=3;i++){
            conList[i].AccountId=accList[1].Id;
            updateList.add(conList[i]);
        }
        Test.startTest();
        update updateList;
        Test.stopTest();
        List<Contact> resConList=[Select Id from Contact where AccountId=:accList[0].Id ];
        System.assertEquals(resConList.size()==7, true);
        
    } 
}