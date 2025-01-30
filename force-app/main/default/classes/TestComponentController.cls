@isTest
public class TestComponentController {
    @testSetup
    static void setup(){
        List<Account> accountList=TestDataFactory.createAccounts(23);
        List<case> caseList=TestDataFactory.createCase(1,accountList[0]);
        
    }
	@isTest
    static void testControllerPage(){
       ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
    }
    
    @isTest
    static void testPageSizeChange(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.pageSize=30;
        cc.pageSizeChange();
    }
    @isTest
    static void testButton(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.nextButton();
        System.assertEquals(2, cc.page);
        cc.perviousButton();
        System.assertEquals(1, cc.page);
        cc.lastButton();
        cc.firstButton();
        System.assertEquals(1, cc.page);
    }
    @isTest
    static void testNextButton(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.startNo=21;
        cc.nextButton();
    }
    @isTest
    static void testdelLink(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.selectedId=cc.listWrapper[1].obj.Id;
  		cc.delLink();
        
    }
    @isTest
    static void testdelLinkError(){
         ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.selectedId=cc.listWrapper[0].obj.Id;
  		cc.delLink();
    } 
     @isTest
    static void testdeleteSelected(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.listWrapper[0].selectedCheckBox=true;
        cc.listWrapper[2].selectedCheckBox=true;
        cc.listWrapper[3].selectedCheckBox=true;
        cc.deleteSelected();
        
    }
     @isTest
    static void testNewRecordcreate(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.newRecordCreate();
        
    }
    @isTest
    static void testcolumnSort(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.sortExpression='Name';
        cc.columnSort();
    }
    @isTest
    static void testAlphaDisplayAll(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.searchVar='All';
        cc.alphaDisplay();
    }
    @isTest
    static void testAlphaDisplayOther(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.searchVar='other';
        cc.alphaDisplay();
    }
    @isTest
     static void testAlphaDisplayAlphabet(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.searchVar='T';
        cc.alphaDisplay();
    }
    @isTest
     static void testAlphaDisplayCaseObj(){
        ComponentController cc=new ComponentController();
        cc.objName='Case';
        cc.selectfields.add('CaseNumber');
        cc.selectfieldsLabel.add('Case Number');
        cc.records();
        cc.searchVar='T';
        cc.alphaDisplay();
    }
    @isTest
    static void testCsvFile(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.listWrapper[0].selectedCheckBox=true;
        cc.listWrapper[2].selectedCheckBox=true;
        cc.listWrapper[3].selectedCheckBox=true;
        cc.csvFile();
    }

    @isTest
    static void testPageNumberChangeZero(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.page=0;
        cc.pageNumberChange();
    }
    @isTest
    static void testPageNumberChangeGreater(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.page=9;
        cc.pageNumberChange();
    }
    @isTest
    static void testPageNumberChangeInBetween(){
        ComponentController cc=new ComponentController();
        cc.objName='Account';
        cc.selectfields.add('name');
        cc.selectfieldsLabel.add('Account Name');
        cc.records();
        cc.page=3;
        cc.pageNumberChange();
    }
}