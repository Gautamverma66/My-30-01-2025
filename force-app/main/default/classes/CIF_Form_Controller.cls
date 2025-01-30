public with sharing class CIF_Form_Controller {
    public Contact con{get;set;}
    public CIF_Form_Controller() {
        System.debug('apex');
        System.debug(ApexPages.currentPage().getParameters().get('id'));
        String recId = ApexPages.currentPage().getParameters().get('id');
        System.debug(ApexPages.currentPage().getParameters().get('id'));
        System.debug(recId);
        con=[Select Id,FirstName,LastName,Description,CreatedDate,BatchDate__c,BatchText__c,BatchTime__c,Birthdate,Email,Languages__c,Level__c,MailingPostalCode,MobilePhone,OtherAddress,OtherCity,OtherCountry,Pan_No__c,Phone,status__c from Contact where Id=:recId Limit 1];

    }
    public pageReference save(){
      
        update con;
        return new ApexPages.StandardController(con).view();

    }
}