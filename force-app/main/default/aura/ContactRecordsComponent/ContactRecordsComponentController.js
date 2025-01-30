({
	fatchRecords : function(component, event, helper) {
        component.set('v.column', [
        {label: 'Last Name', fieldName: 'LastName', type: 'text'},
            {label: 'AccountId', fieldName: 'AccountId', type: 'Id'},
            {label: 'Sequence Number', fieldName: 'Sequence_Number__c', type: 'Number'}
            ]);
		var conList=component.get('c.recordsFatch');
        conList.setCallback(this,function(data){
                            component.set('v.contactList',data.getReturnValue())	
                            });
        $A.enqueueAction(conList);
    	
	}
})