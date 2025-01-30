({
	updateRec : function(component,recId,changeValue) {
        console.log('helperCall');
		var action=component.get("c.updateRecords");
        console.log('helperCall1');
        action.setParams({
            recordId: recId,
            fieldValue: component.get("v.fieldName"),
            objName: component.get("v.objectName"),
            newValue:changeValue
        });
        console.log('helperCall2');
        action.setCallback(this, function(response){
            var data = response.getReturnValue(); 
            var tempList=[];
            console.log(data);
            for(var key in data){
                tempList.push({key: key, value: data[key]})
            }
           	component.set('v.records', tempList);
               component.set('v.isLoading',false);

        });
        $A.enqueueAction(action);
	}
})