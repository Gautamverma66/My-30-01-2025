public class ContactTriggerHandler {
    public static boolean checkRecursive=true;                                                 //Use in to Stop Recursion
    //This Method is Call When Insert new Records on contact
    public static void manageInsertContactSequenceNumber(List<Contact> insertContactList){
        checkRecursive=false;
        Map<ID,List<Contact>> mapOldContact=new Map<ID,List<Contact>>();    //Existing Records store
        
        //Add in Map all New Records where key is AccountId and value is List of Contact
        for(Contact conVar:insertContactList)      {
            if(!mapOldContact.containsKey(conVar.AccountId)){
                mapOldContact.put(conVar.AccountId,new List<Contact>());
            }
        }  

        //Retrieve all the Existing contact records for same inserted Account
        List<Contact> oldContactList=[Select Id,Sequence_Number__c,AccountId from Contact where AccountId IN :mapOldContact.keySet()  order by Sequence_Number__c ASC ];

        
        //Add in Map Existing Records where key is AccountId and value is list of Contact
        for(Contact contactVar:oldContactList){
            mapOldContact.get(contactVar.AccountId).add(contactVar); 
        }
 
        Integer size=0;   //Existing Records List Size		
        //for loop for perform opertion on new contact record list
        for(Contact contVar:insertContactList){
            size=mapOldContact.get(contVar.AccountId).size();
            if(contVar.Sequence_Number__c==null || contVar.Sequence_Number__c > size || contVar.Sequence_Number__c<=0){
                contVar.Sequence_Number__c=size+1;
            }
            else{
                for(Contact allContact:mapOldContact.get(contVar.AccountId)){
                    if(allContact.Sequence_Number__c>=contVar.Sequence_Number__c){
                        allContact.Sequence_Number__c++;
                    }
                }
            } 
            mapOldContact.get(contVar.AccountId).add(contVar);  
        }

        //Dml for Old records Sequence number update
        if(oldContactList.size()>0){
        	update oldContactList;
        } 
    }

     //This Method is call when Records is Delete
     public static void manageDeleteContactSequenceNumber(List<Contact> deletedList){
        checkRecursive=false;
        Map<ID,List<Contact>> mapAllContact=new Map<ID,List<Contact>>();         //Existing Records store

        //Add in Map all Deleted Records where key is AccountId and value is List of Contact
        for(Contact conVar:deletedList)      {
            if(!mapAllContact.containsKey(conVar.AccountId)){
                mapAllContact.put(conVar.AccountId,new List<Contact>());
            }
        }  
        //Retrieve all the Existing contact records for same inserted Account
        List<Contact> allContactList=[Select Id,Sequence_Number__c,AccountId from Contact where AccountId IN :mapAllContact.keySet() order by Sequence_Number__c ASC ];
       
        //Add in Map all Existing Records where key is AccountId and value is List of Contact
        for(Contact contactVar:allContactList){
            mapAllContact.get(contactVar.AccountId).add(contactVar); 
        }

        List<Contact> dmlContactList=new List<Contact>();

        //Perform delete operatiion
        for(Contact con:deletedList){
            if(deletedList.size()!=allContactList.size() ){
                for(Integer i=(Integer)con.Sequence_Number__c;i<mapAllContact.get(con.AccountId).size();i++){
                    mapAllContact.get(con.AccountId)[i].Sequence_Number__c-=1;
                }
            }   
        }
        //Perform dml to update Existing Records
        if(allContactList.size()>0){
        	update allContactList;
        }
    }

    //This Method is execute on undelete Record
    public static void manageUndeleteContactSequenceNumber(List<Contact> undeleteList){
        checkRecursive=false;
        List<Contact> undeleteContactList=[Select Id,Sequence_Number__c,AccountId from Contact where Id In :undeleteList];  //Query for Retrieve Undeleted records
        Map<ID,List<Contact>> mapUndeleteContact=new Map<ID,List<Contact>>();                                               //Store Undeleted Records
        Map<ID,List<Contact>> mapAllContact=new Map<ID,List<Contact>>();                                                    //Store Existing Records
        
        //Add Undeleted Records in Map
        for(Contact conVar:undeleteContactList)      {
            if(!mapUndeleteContact.containsKey(conVar.AccountId)){
            	mapUndeleteContact.put(conVar.AccountId,new List<Contact>());
                mapAllContact.put(conVar.AccountId,new List<Contact>());
            }
            mapUndeleteContact.get(conVar.AccountId).add(conVar);
        }
        //Query for retrieve existing records
        List<Contact> allContactList=[Select Id,Sequence_Number__c,AccountId from Contact where AccountId IN :mapUndeleteContact.keySet() And Id Not In :undeleteContactList order by Sequence_Number__c ASC ];

        //Add Existing Records in Map
        for(Contact contactVar:allContactList){
            mapAllContact.get(contactVar.AccountId).add(contactVar); 
        }
        
        //Perform undeleted operation add on last undeleted record
        for(Contact con:undeleteContactList){
            con.Sequence_Number__c=mapAllContact.get(con.AccountId).size()+1;
            mapAllContact.get(con.AccountId).add(con); 
        }
        //Perform Dml on undeleted records
        if(undeleteContactList.size()>0){
        	update undeleteContactList;
        }
    }
    
    //This Method is Execute when update on Existing Record
    public static void manageUpdateContactSequenceNumber(List<Contact> beforeUpdateList,List<Contact> updatedList){
        List<Contact> updatedListSort=[Select Id,AccountId,Sequence_Number__c From Contact Where Id In :updatedList order By Sequence_Number__c ASC];
        checkRecursive=false;
        Map<ID,Contact> mapBeforeUpdate=new Map<ID,Contact>();                    //Store Before Update Records 
        Map<ID,List<Contact>> mapAllContact=new Map<ID,List<Contact>>();          //Store Existing Records
        Map<ID,List<Contact>> existConMap=new Map<ID,List<Contact>>();
        //Add Updated Records AccountId in Map
        for(Contact con:updatedListSort){
            if(!mapAllContact.containsKey(con.AccountId)){
                mapAllContact.put(con.AccountId,new List<Contact>());
                existConMap.put(con.AccountId,new List<Contact>());
            }
        }
        //Add Before Updated Records in Map
        for(Contact con:beforeUpdateList){
            if(!mapBeforeUpdate.containsKey(con.Id)){
                mapBeforeUpdate.put(con.Id,con);
            }
        }
        //Quary for Retrieve Existing Records
        List<Contact> allContactList=[Select Id,LastName,Sequence_Number__c,AccountId from Contact where AccountId IN :mapAllContact.keySet() And Id Not In :updatedList order by Sequence_Number__c ASC ];
        List<Contact> existContactList=[Select Id,LastName,Sequence_Number__c,AccountId from Contact where AccountId IN :mapAllContact.keySet()  order by Sequence_Number__c ASC ];

        System.debug(existContactList.size());
        //Add Existing Records in Map
        for(Contact contactVar:existContactList){
            existConMap.get(contactVar.AccountId).add(contactVar); 
        }

        for(Contact contactVar:allContactList){
            mapAllContact.get(contactVar.AccountId).add(contactVar); 
        }
        

        Integer indexList=0;                //Use as a index to add Contact in List  base on index
        Contact beforeUpdateCon=null;       //Use to  Store before Updated Contact
        //Perform Update Operation
        for(Contact con:updatedListSort){
            beforeUpdateCon=mapBeforeUpdate.get(con.Id);
            //Reparenting task
            if(beforeUpdateCon.AccountId!=con.AccountId){
                System.debug('reparent');
               
                if(con.Sequence_Number__c==null || con.Sequence_Number__c<=0 || con.Sequence_Number__c>=mapAllContact.get(con.AccountId).size()){
                    con.Sequence_Number__c=mapAllContact.get(con.AccountId).size()+1;
                }
                else{
                    for(Contact allContact:mapAllContact.get(con.AccountId)){
                        if(allContact.Sequence_Number__c>=con.Sequence_Number__c){
                            allContact.Sequence_Number__c++;
                        }
                    } 
                }
                mapAllContact.get(con.AccountId).add(con);
            }
            //Update task
            else{
                if(con.Sequence_Number__c==null || con.Sequence_Number__c<=0 || con.Sequence_Number__c>existConMap.get(con.AccountId).size()){
                    for(Integer i=(Integer)beforeUpdateCon.Sequence_Number__c-1;i<(Integer)mapAllContact.get(con.AccountId).size();i++){
                        mapAllContact.get(con.AccountId)[i].Sequence_Number__c-=1;
                    }
                    con.Sequence_Number__c=mapAllContact.get(con.AccountId).size()+1;
                    mapAllContact.get(con.AccountId).add((Integer)beforeUpdateCon.Sequence_Number__c-1,con);
                }
                else if(con.Sequence_Number__c < beforeUpdateCon.Sequence_Number__c){
                    for(Contact allContact:mapAllContact.get(con.AccountId)){
                        if(allContact.Sequence_Number__c<=beforeUpdateCon.Sequence_Number__c && allContact.Sequence_Number__c>=con.Sequence_Number__c ){
                            allContact.Sequence_Number__c++;
                        }
                    } 
                    mapAllContact.get(con.AccountId).add(con);
                    
                }
                else if(con.Sequence_Number__c > beforeUpdateCon.Sequence_Number__c){
                    indexList=(Integer)beforeUpdateCon.Sequence_Number__c-1;
                    if(indexList>=mapAllContact.get(con.AccountId).size()){
                        mapAllContact.get(con.AccountId).add(con);
                    }else{
                        mapAllContact.get(con.AccountId).add(indexList,con);
                    }
                    
                    for(Integer i=(Integer)beforeUpdateCon.Sequence_Number__c;i<(Integer)con.Sequence_Number__c;i++){
                        if(i<mapAllContact.get(con.AccountId).size() &&!updatedListSort.contains(mapAllContact.get(con.AccountId)[i])){
                                mapAllContact.get(con.AccountId)[i].Sequence_Number__c-=1;
                        }
                        
                    } 
                }
            } 
                    
            
        }
        List<Contact> dmlList=new List<Contact>();
        dmlList.addAll(allContactList);
        dmlList.addAll(updatedListSort);
        //Perform Dml 
        if(dmlList.size()>0){
            update dmlList;
        }
    }
}