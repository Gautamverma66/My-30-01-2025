({
	fatchObj : function(component, event, helper) {
        component.set("v.isLoading",true);
        component.set('v.childPageShow', false);
        component.set('v.fieldBlockShow', false);
		var objList=component.get("c.fatchObjects");
        objList.setCallback(this,function(response){
            var tempList = [];
            tempList.push({ value:'None', label:'None'});
            var objectMap = response.getReturnValue(); 
            for (var k in objectMap) {
                tempList.push({ value:k, label:objectMap[k]});
            }
            component.set('v.objectList', tempList);
            component.set("v.isLoading",false);
        });	
		$A.enqueueAction(objList);
	},
	fatchObjFields : function(component, event, helper) {
        component.set("v.isLoading",true);
        component.set('v.childPageShow', false);
        component.set('v.selectedField',[]);
		var fieldList = component.get('c.fatchFields');
        var objName = component.get('v.selectedObj');
		fieldList.setParams({
			objectName: objName
            
		});
	
		fieldList.setCallback(this, function(response){
			var tempList = [];
			var fieldMap = response.getReturnValue(); 
			for (var k in fieldMap) {
				tempList.push({ value:k, label:fieldMap[k]});
			}
            tempList.sort((a, b) => (a.label > b.label ? 1 : -1));
			component.set('v.fields', tempList);
            component.set("v.isLoading",false);
		});
        component.set('v.fieldBlockShow', true);
		$A.enqueueAction(fieldList); 
	},
    
    showData : function(component, event, helper) {
        component.set('v.childPageShow', true);
        var childCmp = component.find("childComponent");
        var retnMsg = childCmp.getRecord();
       
	}
   
})