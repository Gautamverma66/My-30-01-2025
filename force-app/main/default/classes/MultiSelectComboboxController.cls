public with sharing class MultiSelectComboboxController {
    @AuraEnabled(cacheable=true)
    public static List<Account>  getRecords(){
       return [Select Name from Account];
    }
}