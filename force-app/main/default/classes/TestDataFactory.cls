@isTest
public class TestDataFactory {
	public static List<Account> createAccounts(Integer numAccts) {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=1;i<=numAccts;i++) {
            testAccts.add(new Account(Name = 'Test'+i));
        }
        insert testAccts; 
        
        return testAccts;
    }
    public static List<Account> createAccountsWithRating(Integer numAccts) {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=1;i<=numAccts;i++) {
            testAccts.add(new Account(Name = 'Test'+i,Rating='Cold'));
        }
        insert testAccts; 
        
        return testAccts;
    }
    public static List<case> createCase(Integer numOpps, Account acc) {
       
        List <case> casestocreate=new list<case>();
		
		for(Integer i=1;i<=numOpps;i++) {
            casestocreate.add( new case(Subject='Account case',AccountId=acc.id));
        }
        
        insert casestocreate;
        
        return casestocreate;
    }
    public static List<Contact> createContactWithAcc(Integer numContact,Account acc){
        List<Contact> testCon = new List<Contact>();
        for(Integer i=1;i<=numContact;i++) {
            testCon.add(new Contact(LastName = 'Test'+i,AccountId=acc.Id));
        }
        insert testCon; 
        
        return testCon;
    }
    public static List<Contact> createContactWithSequence(Integer numContact,Account acc,List<Integer> SeqNo){
        List<Contact> testCon = new List<Contact>();
        for(Integer i=0;i<numContact;i++) {
            testCon.add(new Contact(LastName = 'Test'+i+1,AccountId=acc.Id,Sequence_Number__c=SeqNo[i]));
        }
        insert testCon; 
        
        return testCon;
    }
    public static List<Contact> createContactYesterdayDate(Integer numContact){
        List<Contact> contacts = new List<Contact>();
        System.debug('today date using system.today >>'+System.today());
        System.debug('today date using Date.today >>'+Date.today());
        
       // Date yesterday = System.today().addDays(-1);
        DateTime yesterday=System.now().addDays(-1);
        System.debug('Yesterday Date is >>>'+yesterday);
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(LastName = 'DemoTest ' + i)); 
        }
        insert contacts;
        System.debug('contact List is >>>'+contacts);       
        for(Contact c: contacts){
            Test.setCreatedDate(c.Id, yesterday);
        }
        List<Contact> cont = [Select Id,Name,CreatedDate from Contact];
        System.debug('after updated created Date >>>>'+cont);
        return contacts;
    }
}