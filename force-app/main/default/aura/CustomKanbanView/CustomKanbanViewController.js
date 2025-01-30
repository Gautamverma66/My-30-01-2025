({
	fetchObject : function(component, event, helper) {
        component.set('v.isLoading',true);
        
		var objList=component.get("c.fatchObjects");
        objList.setCallback(this,function(response){
            var state=response.getState();
            console.log(state);
            var tempList = [];
            tempList.push({ value:'None', label:'None'});
            var objectMap = response.getReturnValue(); 
            for (var k in objectMap) {
                tempList.push({ value:k, label:objectMap[k]});
            }
            component.set('v.objectList', tempList);
            component.set('v.isLoading',false);
            
            
            
        });	
		$A.enqueueAction(objList);
	},
    fatchObjFields : function(component, event, helper) {
        console.log("Start");
        component.set('v.isLoading',true);
        component.set('v.recordsShow',false);
		var fieldList = component.get('c.fetchPickListField');
        var objName = component.get('v.objectName');
		fieldList.setParams({
			objNam: objName
            
		});
	
		fieldList.setCallback(this, function(response){
			var tempList = [];
            tempList.push({ value:'None', label:'None'});
			var fieldMap = response.getReturnValue(); 
			for (var k in fieldMap) {
				tempList.push({ value:k, label:fieldMap[k]});
			}
			component.set('v.pickListFieldList', tempList);
            console.log('list-->'+tempList);
            component.set('v.isLoading',false);
            component.set('v.fieldListShow',true);
		});
       
		$A.enqueueAction(fieldList);
	},
     fetchPicklistValue : function(component, event, helper) {
        console.log("Start");
        component.set('v.isLoading',true);
		var fieldListValue = component.get('c.fetchPickListFieldValue');
        var fieldValue = component.get('v.fieldName');
        var objName = component.get('v.objectName');
		fieldListValue.setParams({
			fieldNam: fieldValue,
            objNam:	objName
            
		});
	
		fieldListValue.setCallback(this, function(response){
			var data = response.getReturnValue(); 
            console.log(data);
            var tempList=[];
            for(var key in data){
                tempList.push({key: key, value: data[key]})
            }
           	component.set('v.records', tempList);
            console.log(JSON.stringify(component.get('v.records')));
            component.set('v.isLoading',false);
            component.set('v.recordsShow',true);
            
          
		});
       
		$A.enqueueAction(fieldListValue);
	},
    drag :function(component, event, helper) {
        console.log(event.target.id);
        event.dataTransfer.setData("text", event.target.id);
        
    },
    allowDrop :function(component, event, helper) {
        event.preventDefault();
    },
    drop :function(component, event, helper) {
        console.log('onNew1');
        component.set('v.isLoading',true);
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        var tar = event.target;
        while(tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        tar.appendChild(document.getElementById(data));
        document.getElementById(data).style.backgroundColor = "#ffb75d";
        helper.updateRec(component,data,tar.getAttribute('data-Pick-Val'));
    }
})