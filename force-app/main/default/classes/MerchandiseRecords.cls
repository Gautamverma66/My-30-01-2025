public class MerchandiseRecords {
    public List<Merchandise__c> lt{get;set;}
    public MerchandiseRecords(){
        lt=[Select Name__c,Job_Description__c,Price__c,Total_Inventory__c From Merchandise__c];
    }
        //public static List<Merchandise__c> getRecords(){
        //List<Merchandise__c> lt=[Select Name__c,Job_Description__c,Price__c,Total_Inventory__c From Merchandise__c];
        //return lt;  
        
   // }
}