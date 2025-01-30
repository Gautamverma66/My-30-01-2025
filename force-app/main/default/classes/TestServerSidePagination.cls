@isTest
public class TestServerSidePagination {
	@testSetup
    static void setup(){
        List<Account> accountList=TestDataFactory.createAccounts(50);
    }
    @isTest
    static void testfetchObjects(){
        ServerSidePaginationControllerClass.fatchObjects();
    }
    @isTest
    static void testfetchFields(){
		ServerSidePaginationControllerClass.fatchFields('Account');
        
    }
    @isTest
    static void testfetchRecord(){
        List<String> fieldList=new List<String>();
        List<ID> selectRecordsId=new List<ID>();
        fieldList.add('Name'); 
        String objName='Account';
        Integer pageNo=1;
        Integer pageSiz=5;
        String sortDie='ASC';
        String sortBy='Id';
        
		ServerSidePaginationControllerClass.fatchData(fieldList,objName,pageSiz,pageNo,sortDie,sortBy,selectRecordsId);
        
    }
}