public class ParentRating {
    
    public static void updateRating(List<Gautam__c> gList){
       // Contact c=[Select AccountId from Contact where Id=:gList[0].Contact__r.Id];
        //Account ac=[Select Rating from Account where Id=:c.AccountId];
        //ac.Rating=gList[0].Rate__c;
        //update ac;
        List<Account> aList=new List<Account>();
        Account ac=new Account();
        for(Gautam__c gau:[Select Rate__c,contact__r.AccountId from Gautam__c where Id IN :gList]){
           
           ac.Id=gau.Contact__r.AccountId;
           ac.Rating=gau.Rate__c;
           aList.add(ac);
        }
        upsert aList;
    }
}