public class AccountPageController {
    public string accountRecordFilter{get; set;}
    public list<Account> accList{get; set;}
    public void getAccountRecord() {
        accList = new list<Account>();
      
        if(accountRecordFilter=='MyAcc'){
        accList=[SELECT Id, Name,Industry,Rating,OwnerId from Account Where OwnerId=:UserInfo.getUserId()];
        }
        else if(accountRecordFilter=='AllAccount'){
        accList=[SELECT Id, Name,Industry,Rating,OwnerId from Account];
        }
    }
}