({
    fetchRecord : function(component, event, helper) {
        component.set("v.isLoading",true);
        var page=0;
        var pageSize = 10;
        var buttonNam="first";
        var firstId=null;
        var lastId=null;
        helper.getRecords(component,page,pageSize,buttonNam,firstId,lastId);
        component.set("v.pageNumber",1);
        component.set("v.TotalPages",CEILING(component.get("v.TotalRecords") / pageSize));
    },
    sortColumn: function(component, event, helper){
        component.set("v.isLoading",true);
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
		var isAscen = component.get('v.isAscending');
		if(isAscen){
            sortDirection = 'desc';
            component.set("v.isAscending",false);
        }
        else{
            component.set("v.isAscending", true);
            sortDirection = 'asc';
        }
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
		helper.handleSorting(component, sortDirection, sortedBy);
        
    },
    pagesizeChange : function(component, event, helper) {
        component.set("v.isLoading",true);
        var page=0;
        var pageSize = component.find("pageSize").get("v.value");
        var buttonNam='pageSizeChange';
        var recordsPerPage=component.get("v.records");
        var firstId=recordsPerPage[0].Id;
        var lastId=recordsPerPage[recordsPerPage.length-1].Id;
        helper.getRecords(component,page,pageSize,buttonNam,firstId,lastId);
        component.set("v.pageNumber",1);
        component.set("v.TotalPages",CEILING(component.get("v.TotalRecords") / pageSize));
    
    },
    handleFirst : function(component, event, helper) {
        component.set("v.isLoading",true);
        var page=0;
        var pageSize = component.find("pageSize").get("v.value");
        var buttonNam="first";
        var firstId=null;
        var lastId=null;
        helper.getRecords(component,page,pageSize,buttonNam,firstId,lastId);
        component.set("v.pageNumber",1);
       
    },
    handlePrev : function(component, event, helper) {
        component.set("v.isLoading",true);
        var buttonNam="prev";
        var page=component.get("v.pageNumber")-2;
        var pageSize = component.find("pageSize").get("v.value");
        var recordsPerPage=component.get("v.records");
        var firstId=recordsPerPage[0].Id;
        var lastId=recordsPerPage[recordsPerPage.length-1].Id;
        helper.getRecords(component,page,pageSize,buttonNam,firstId,lastId);
        component.set("v.pageNumber",page+1);
        

    },
    handleNext : function(component, event, helper) {
        component.set("v.isLoading",true);
        var buttonNam="next";
        var page=component.get("v.pageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        var recordsPerPage=component.get("v.records");
        var firstId=recordsPerPage[0].Id;
        var lastId=recordsPerPage[recordsPerPage.length-1].Id;
        helper.getRecords(component,page,pageSize,buttonNam,firstId,lastId);
        component.set("v.pageNumber",page+1);
       

       
    },
    handleLast : function(component, event, helper) {
        component.set("v.isLoading",true);
        var buttonNam="last";
        var page=component.get("v.TotalPages")-1;
        var pageSize = component.find("pageSize").get("v.value");
        helper.getRecords(component,page,pageSize,buttonNam);
        component.set("v.pageNumber",page+1);
        
    },
    updateSelected :  function(component, event, helper){
        component.set("v.isLoading",true);
        var selectedRows = event.getParam('selectedRows');

        var data=component.get("v.records");
        var tempSelectedAllList=component.get("v.listCheckbox");
        for(let j=0;j<data.length;j++){
            if(tempSelectedAllList.includes(data[j].Id)){
                tempSelectedAllList.splice(tempSelectedAllList.indexOf(data[j].Id),1);
            }      
        } 
        component.set('v.listCheckbox',tempSelectedAllList);

        var select=[];
        var tempSelectedAll=component.get("v.listCheckbox");
        for (let i = 0; i < selectedRows.length; i++){
            select.push(selectedRows[i].Id); 
            tempSelectedAll.push(selectedRows[i].Id);
        }
        component.set("v.selectRecord",select); 
        component.set("v.listCheckbox",tempSelectedAll);
        component.set("v.isLoading",false);
       
    }

})