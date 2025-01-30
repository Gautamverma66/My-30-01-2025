public with sharing class PlotBuyersArgreementController {
    public String recId{get;set;} 
    public Payment_Line_Item__c pliRec{get;set;}
    public List<applicant_details__c> appDetailsRec{get;set;}
    public PlotBuyersArgreementController() {
        recId=ApexPages.currentPage().getParameters().get('id');
        System.debug(recId);
        pliRec=[Select Id,Amount_PLI__c,Rate_PLI__c,Amount_Type_PLI__c,Relationship_Manager_PLI__c,Application_Booking__c,Application_Booking__r.Amount_App_Booking__c,Application_Booking__r.Contact__r.Name,Application_Booking__r.Contact__r.Pan_No__c,Application_Booking__r.Contact__r.Aadhar_No__c From Payment_Line_Item__c Where Id=:recId Limit 1];
        appDetailsRec=[Select Id,Name,Application_Booking__c from applicant_details__c where Application_Booking__c=:pliRec.Application_Booking__c];

    }

}