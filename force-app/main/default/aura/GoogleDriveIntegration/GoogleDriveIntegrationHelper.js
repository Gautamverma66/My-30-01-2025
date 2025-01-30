({
    accessTokenFetch : function(component, event, helper) {
		var currentUrl=window.location.href;
    	var action = component.get("c.accessTokenGenerate");
    	action.setParams({
			accessStr: currentUrl
		});
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fileList = response.getReturnValue();
                component.set('v.driveFiles',fileList.files);  
                var temp=[];
                temp.push({value:'root', label:'Home'})
                component.set('v.breadcrumbs',temp);  
                component.set("v.showSpinner",false);
            }
             else if(state == "ERROR"){
                var errors = response.getError();                       
                component.set("v.showSpinner",false);         
                console.log(errors[0].message);
            }
        });
        $A.enqueueAction(action);
	},
   
    delFilefunction : function(component, event, helper,filID,temp) {
        var action = component.get("c.delFile");
        action.setParams({
            fileId:filID,
            folderId:temp
        });
        action.setCallback(this,function(response){
            var state=response.getState();
             console.log('State del--> ',state);
            if(state==="SUCCESS"){
                var delResult = response.getReturnValue();
                component.set('v.driveFiles',delResult.files); 
                console.log('delResult-->',delResult);
                component.set('v.showConfirmDialog', false);
                component.set("v.showSpinner",false);
            }
            else if(state == "ERROR"){
                var errors = response.getError();  
                console.log(errors[0].message);
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
	},
    folderCreate:function(component, event, helper,temp,inputValue) {
       
        var action = component.get("c.createFolder");
        action.setParams({
            folderName:inputValue,
            parentFolderId:temp
        });
        action.setCallback(this,function(response){
            var state=response.getState();
             console.log('State newFolderCreate--> ',state);
            if(state==="SUCCESS"){
                var Result = response.getReturnValue();
                component.set('v.driveFiles',Result.files); 
                component.set('v.inputValue',''); 
                component.set("v.showSpinner",false);
            }
            else if(state == "ERROR"){
                var errors = response.getError();  
                console.log(errors[0].message);
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
      	
    },
    openInsideFilesFolder:function(component, event, helper,fileid) {
        
        var action = component.get("c.fetchDriveInsideFiles");
        action.setParams({
            folderId:fileid
        });
        action.setCallback(this,function(response){
            var state=response.getState();
             console.log('State openInsideFiles--> ',state);
            if(state==="SUCCESS"){
                var Results = response.getReturnValue();
                component.set('v.driveFiles',Results.files); 
                component.set("v.showSpinner",false);
               
            }
            else if(state == "ERROR"){
                var errors = response.getError();  
                console.log(errors[0].message);
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
      
      	
    },
    fileUpload: function(component, event, helper,fileContent,fileName,temp,filetype) {
      
        var action = component.get("c.uploadFileToDrive");
        action.setParams({
            folderId:temp,
            fileName:fileName,
            fileCon:fileContent,
            mimeType:filetype
        });
        action.setCallback(this,function(response){
            var state=response.getState();
             console.log('State newFolderCreate--> ',state);
            if(state==="SUCCESS"){
                var Result = response.getReturnValue();
                component.set('v.driveFiles',Result.files); 
                component.set('v.fileContent',''); 
                component.set('v.fileName',''); 
                component.set("v.showSpinner",false);
            }
            else if(state == "ERROR"){
                var errors = response.getError();  
                console.log(errors[0].message);
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    }
})