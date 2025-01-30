({
	authorizeGoogleDrive : function(component, event, helper) {
        component.set("v.showSpinner",true);
		var action = component.get("c.GoogleDriveAuthorizationUrl");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('start js4');
                var authorizationUrl = response.getReturnValue();
             
                if(authorizationUrl!=null){
                    window.open(authorizationUrl,'_self');  					
                }
                else{
                    helper.accessTokenFetch(component, event, helper);
                }

            }
            else if(state == "ERROR"){
                var errors = response.getError();                       
                component.set("v.showSpinner",false);          
                console.log(errors[0].message);
            }
           
        });
        $A.enqueueAction(action);
	},
   
    delfiles :function(component, event, helper) {
        component.set("v.showSpinner",true);
		var fileId=component.get('v.delFileId');
        var temp;
        var breadcrumb= component.get("v.breadcrumbs");
        breadcrumb=JSON.parse(JSON.stringify(breadcrumb));
 
        breadcrumb.forEach(function (item, index) {
            temp=item.value;
          });  
      	helper.delFilefunction(component, event, helper,fileId,temp);
    },
    newFolderCreate:function(component, event, helper) {
        component.set("v.showSpinner",true);
        var temp;
        var breadcrumb= component.get("v.breadcrumbs");
        breadcrumb=JSON.parse(JSON.stringify(breadcrumb));
 
        breadcrumb.forEach(function (item, index) {
            temp=item.value;
          });  
        var inputCmp = component.find("FolderName");
        var inputValue = inputCmp.get("v.value");
        helper.folderCreate(component, event, helper,temp,inputValue);
      	
    },
    openInsideFiles:function(component, event, helper) {
        component.set("v.showSpinner",true);
        console.log('start openInsideFiles js');
		var fileid=event.currentTarget.dataset.id;
        var fileNam=event.currentTarget.dataset.name;
        var ind=event.currentTarget.dataset.index;
        var temp=[]; 
        var breadcrumb= component.get("v.breadcrumbs");
        breadcrumb=JSON.parse(JSON.stringify(breadcrumb));
        
        breadcrumb.forEach(function (item, index) {
            console.log(item, index);
            temp.push(item);
          });  
          if(ind>=0){
            temp.splice(ind);
          }
        
        temp.push({value:fileid ,label:fileNam})
        temp=JSON.parse(JSON.stringify(temp));
        component.set('v.breadcrumbs',temp); 
       
        helper.openInsideFilesFolder(component, event, helper,fileid);
        
       
    },
 

    handleFileChange: function(component, event, helper) {
        component.set("v.showSpinner",true);
        var fileInput = event.getSource().get("v.files")[0];
        
        component.set("v.fileName", fileInput.name);
        var fileType = fileInput.type;
         component.set("v.file",fileType);
        var reader = new FileReader();
        reader.onload = function(e) {
            var fileContent = e.target.result;
            component.set("v.fileContent", btoa(fileContent));
        };
        reader.readAsBinaryString(fileInput);
        component.set("v.showSpinner",false);
    },
    
    uploadFile: function(component, event, helper) {
        component.set("v.showSpinner",true);
        var fileContent = component.get("v.fileContent");
        var fileName = component.get("v.fileName");
        var filetype = component.get("v.file");
        var temp;
        var breadcrumb= component.get("v.breadcrumbs");
        breadcrumb=JSON.parse(JSON.stringify(breadcrumb));

        breadcrumb.forEach(function (item, index) {
            console.log(item, index);
            temp=item.value;
          });  
        
        helper.fileUpload(component, event, helper,fileContent,fileName,temp,filetype);
    },
    handleConfirmDialog : function(component, event, helper) {
        var fileId=event.currentTarget.dataset.id;
        component.set('v.showConfirmDialog', true);
        component.set('v.delFileId', fileId);
        
    },
    handleConfirmDialogNo : function(component, event, helper) {
        component.set('v.showConfirmDialog', false);
        component.set('v.delFileId', '');
    },
    
})