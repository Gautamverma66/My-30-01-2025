trigger ContactSequence on Contact (before insert,after update,before delete,after undelete) {
    if(Trigger.isBefore){
        
        if(Trigger.isInsert){
            ContactTriggerHandler.manageInsertContactSequenceNumber(Trigger.New);
        }
        
        
        if(Trigger.isDelete){
            ContactTriggerHandler.manageDeleteContactSequenceNumber(Trigger.Old);
        }
        
        
    }
    
    if(Trigger.isAfter){
        
        if(ContactTriggerHandler.checkRecursive){
            if(Trigger.isUpdate){
                ContactTriggerHandler.manageUpdateContactSequenceNumber(Trigger.Old,Trigger.New);
            }
        } 
        if(Trigger.isUndelete){
            ContactTriggerHandler.manageUndeleteContactSequenceNumber(Trigger.New);
        }
    }
}