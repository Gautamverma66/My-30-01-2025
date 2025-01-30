public class ContactStatusBatchClass implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    String csvStr;           //CSV File String
    List<String> fieldsList;  //Fields Show in CSV File
    static Integer updateCount=0;
    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext bc){
        fieldsList=new List<String>{'BatchDate__c','BatchTime__c','BatchBoolean__c','BatchText__c','Sequence_Number__c','Phone','OwnerId','status__c'};
        Map<String,Schema.SObjectField> mfields = Schema.Contact.SObjectType.getDescribe().fields.getMap();
        for(String s:fieldsList){
            if(csvStr!=null){
            csvStr+=','+mfields.get(s).getDescribe().getLabel();
            }
            else{
                csvStr=mfields.get(s).getDescribe().getLabel();
            }
        }
        return Database.getQueryLocator('Select Id,'+String.join(fieldsList,',')+' From Contact Where CreatedDate = LAST_N_Days : 1');
    }
    //Execute method
    public void execute(Database.BatchableContext bc,List<Contact> conList){ 
        List<Contact> updateConList=new List<Contact>();
        for(Contact con:conList){
            if(con.status__c!='Ready for Approval'){
                con.status__c='Ready for Approval';
                updateConList.add(con);
                updateCount++;
            }
           
            csvStr+='\n';
            for(Integer i=0;i<fieldsList.size();i++){
                if(fieldsList[i]=='BatchDate__c' || fieldsList[i]=='BatchTime__c'){
                    DateTime dt =(DateTime) con.get(fieldsList[i]);
                    String dateTimeStr = dt.format('M/d/yyyy h:mm:ss a z');
                    String subStr=dateTimeStr.substring(0,21);
                    csvStr+=subStr+',';
                }
                else{
                    csvStr=csvStr+'"'+(con.get(fieldsList[i]))+'"'+',';
                }
            }   
        }
        update updateConList;
    }
    //Finish Method
    public void finish(Database.BatchableContext bc){
        System.debug(updateCount);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        System.debug(csvStr);
        blob csvBlob = Blob.valueOf(csvStr);
        csvAttc.setBody(csvBlob);
        csvAttc.setFileName('CSVFile.csv');
        mail.setToAddresses(new String[] {'Gautam.verma@briskminds.com'});
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed CSV File');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
    }
    //Schdeler execute method
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ContactStatusBatchClass());
    }
 
}