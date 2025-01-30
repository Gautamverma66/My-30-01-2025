public class FilterRecords {
    public List<Account> accList{get;set;}
 
    public List<Account> getAllRec(){
        if(accList==null){
            accList=new List<Account>();
        }
        accList=[Select Id,Name,Industry,Rating From Account];
        return accList;
    }
    public List<Account> getMyAccount(){
        if(accList==null){
            accList=new List<Account>();
        }
        accList=[Select Id,Name,Industry,Rating From Account where OwnerId='0052w00000D82UZAAZ'];
        return accList;
    }
    public pageReference filter1(){
        accList=[Select Id,Name,Industry,Rating From Account];
        return new pageReference('displayAllRecords.vfp');
    }
    
}