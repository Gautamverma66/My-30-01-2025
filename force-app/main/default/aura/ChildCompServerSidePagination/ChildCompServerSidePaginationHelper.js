({
    getRecords : function(component,page,pageSize,buttonNam,firstId,lastId) {
       
        
        var dataFatch=component.get("c.fatchData");
        dataFatch.setParams({
			objectName: component.get('v.selectobjectname'),
            fieldlt: component.get('v.selectList'),
            pagNumber: page,
            pagSize: pageSize,
            firstRecordId: firstId,
            lastRecordId: lastId,
            actionButton: buttonNam
		});
        console.log("start");
        dataFatch.setCallback(this, function(response){
            var returnVal=response.getReturnValue()
            var state = response.getState();
        
			component.set("v.records", returnVal.dataList);
            component.set("v.TotalRecords", returnVal.totalRecords);
            var columns = [];
            var fieldList=component.get("v.selectList");

            component.get("v.allFields").forEach(item => {
                if(fieldList.includes(item.value)){
                    columns.push({
                        label: item.label,
                        fieldName: item.value,
                        type: "text",
                        sortable :true
                    });
                }
                
            });
            component.set("v.column", columns);
			component.set("v.TotalPages",Math.ceil(component.get("v.TotalRecords")/pageSize));

            var tempRecordList=component.get("v.records");
            var tempSelectedAllList=component.get("v.listCheckbox");
            var tempList=[];
            for(let i = 0; i < tempRecordList.length; i++){
                if(tempSelectedAllList.includes(tempRecordList[i].Id)){
                    tempList.push(tempRecordList[i].Id);
                }
            }
            component.set('v.selectRecord',tempList);
            component.set("v.isLoading",false);
            
		});
		$A.enqueueAction(dataFatch);  
    },
    handleSorting: function(component, sortDirection, sortedBy) {
		var data = component.get('v.records');
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(sortedBy, reverse));
        component.set('v.records', data);
        component.set("v.isLoading",false);
	},

	sortBy: function (field, reverse, primer) {
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})