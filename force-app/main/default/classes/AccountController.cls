public class AccountController {
    public List<Account> listAcc;
    //Testing deploying updated code on github
    //Testing deploying updated code on github in updated branch
    public List<Account> getAccountRecords(){
        if(listAcc==null){
            listAcc=new List<Account>();
        }
        listAcc=[Select Id,Name,Industry,Rating From Account];
        return listAcc;
    }
    public PageReference save(){
        update listAcc;
        Account ac=listAcc.get(listAcc.size()-1);
        return new ApexPages.StandardController(ac).view();
    }
    public pageReference quickSave(){
        update listAcc;
        return null;
    }
    public void del(){
        Database.delete(listAcc,false);
    }
    
   
}