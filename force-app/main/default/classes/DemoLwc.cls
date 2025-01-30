public with sharing class DemoLwc {
    @AuraEnabled(cacheable=true)
    public static List<Contact> fetchContacts(){ 
        return [Select Id,Name from Contact];
    }
}