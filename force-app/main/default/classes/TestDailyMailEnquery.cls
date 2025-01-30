public with sharing class TestDailyMailEnquery implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id,Name FROM Contact WHERE BatchDate__c = System.today()');
    }
    public void execute(Database.BatchableContext bc,List<Contact> conList){ 
        List< Messaging.SingleEmailMessage> allMail=new List<Messaging.SingleEmailMessage>();
        for(Contact con:conList){ 
            String body='Hello '+con.Name+'/n'+'this is a gentle reminder that today is your Next follow up date for Enquiry '+con.Name+'/n'+'Link :'+ Url.getSalesforceBaseUrl().toExternalForm()+'/'+con.Id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {'Gautam.verma@briskminds.com'});
            mail.setCcAddresses(new String[] {'nishant.grover@tribecadevelopers.com'});
            mail.setSubject('Enquiry Mail');
            mail.setPlainTextBody(body);
            allMail.add(mail);
        }
        Messaging.sendEmail(allMail );
       
       
    }
    public void finish(Database.BatchableContext bc){
    }
}