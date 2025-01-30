public class ContactAuraComponentController {
	@AuraEnabled
    public static List<Contact> recordsFatch(){
        List<contact> conList=[Select Id,LastName,AccountId,Sequence_Number__c From Contact];
        return conList;
    }
}