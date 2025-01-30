public class ContactsDetailsOnAccountClass {
    @AuraEnabled
    public static List<Contact> fetchContacts(String accId){
        List<Contact> conList = new List<Contact>();
        if(accId != '' && accId != null){
            conList = [SELECT Id,FirstName,LastName,Email,Phone FROM Contact WHERE AccountId =:accId];
        }
        return conList;  
    }
    @AuraEnabled
    public static String deleteContact(String conId){
        List<Contact> conList = new List<Contact>();
        if(conId != '' && conId != null){
            conList = [SELECT Id FROM Contact WHERE Id =:conId];
            if(conList.size() > 0){
                delete conList;
                return 'true';
            }
        }
        return 'false';
    }
    @AuraEnabled
    public static String upsertContact(List<Contact> contactList){
        System.debug('contactList--> '+contactList);
       // List<Object> res = (List<Object>) JSON.deserializeUntyped(contactList);
        //Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(contactList);
        //System.debug('res-->  '+res);
       // System.debug('results-->  '+results);
        List<Contact> conList = new List<Contact>();
        try {
            upsert contactList;
            return 'true';
        } catch (Exception e) {
            System.debug(e);
        }
        
        return 'false';
    }
}