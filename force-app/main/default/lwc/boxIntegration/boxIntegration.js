import { LightningElement,wire,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import boxAuthorizationUrl from '@salesforce/apex/BoxIntegrationClass.boxAuthorizationUrl'
import getTokens from '@salesforce/apex/BoxIntegrationClass.getTokens'
import checkUserExist from '@salesforce/apex/BoxIntegrationClass.checkUserExist'
import getFiles from '@salesforce/apex/BoxIntegrationClass.getFiles'
import fileDownload from '@salesforce/apex/BoxIntegrationClass.fileDownload'
import deleteFile from '@salesforce/apex/BoxIntegrationClass.deleteFile'
import folderCreate from '@salesforce/apex/BoxIntegrationClass.folderCreate'
import uploadFile from '@salesforce/apex/BoxIntegrationClass.uploadFile'




export default class BoxIntegration extends LightningElement {
  
    @track allFiles=[];
    @track allFolder=[];
    @track fileData;
    @track fileName;
    @track fileTyp;
    @track breadcrumbList=[{key:0 , value:'Home'}];
    @track isLoading=false;
    uploadButton=true;
    
    constructor(){
        super();
        console.log('parent-constructor');
        checkUserExist()
        .then(result => {
            if(result == true){
                this.isLoading=true;
                this.getFile(0);
            }
            else if(result == false){
                this.isLoading=true;
                this.getAuthCode();
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
   
    getAuthCode(){
        console.log('getAuthCode');
        boxAuthorizationUrl()
        .then(result => {
           if(result != null){
            this.isLoading=false;
            window.open(result, "_self");
           }
           else{
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            var code = urlParams.get('code');
            if(code == null){
                this.getFile(0);
            }
            else{
                this.getAccessToken(code);
            }
           
           }
           
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
    getAccessToken(authCode){
        console.log('getAccessToken');
        getTokens({oauthCode:authCode})
        .then(result => {
           if(result == true){
            this.getFile(0);
           }
           else{
            console.log('result--> ',result);
           }
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
    getFile(folderId){
        console.log('files');
        getFiles({foldId: folderId})
        .then(result => {
            this.allFiles=[];
            this.allFolder=[];
            for(let file of result){
                if(file.type == 'folder'){
                    this.allFolder.push(file);
                }
                else{
                    this.allFiles.push(file);
                }
           }
           
            this.isLoading=false;
        })
        .catch(error => {
            console.error('Error: ',error);
            this.isLoading=false;
        })  
       
        
    }
    viewFile(event){
   
        if(event.currentTarget.dataset.doctype == 'folder'){
            
            this.isLoading=true;
            this.breadcrumbList.push({key :event.currentTarget.dataset.id , value : event.currentTarget.dataset.name});
            this.getFile(event.currentTarget.dataset.id)
        }
    }
    viewFileLink(event){
        console.log(event.currentTarget.dataset.id);
    }
    handlebreadcrumb(event){
        console.log('breadcrumb');
        this.isLoading=true;
        this.getFile(event.currentTarget.dataset.id);
        this.breadcrumbList.splice(parseInt(event.currentTarget.dataset.index)+1);
    }
    downloadFile(event){
        console.log('downloadFile');
        this.isLoading=true;
        fileDownload({fileId : event.currentTarget.dataset.id})
        .then(result => {
            window.open(result,"_self");
            const event = new ShowToastEvent({
                title: 'Successful',
                message: 'Download Successful',
                variant: 'success'
              });
              this.dispatchEvent(event);
              this.isLoading=false;
        })
        .catch(error => {
            console.log('error-->', error);
            this.isLoading=false;
        })
    }
    delFile(event){
        this.isLoading=true;
        const folderId=this.breadcrumbList[this.breadcrumbList.length-1].key;
        deleteFile({fileId : event.currentTarget.dataset.id, fileType : event.currentTarget.dataset.type ,foldId : folderId})
        .then(result => {
            this.allFiles=[];
            this.allFolder=[];
            for(let file of result){
                if(file.type == 'folder'){
                    this.allFolder.push(file);
                }
                else{
                    this.allFiles.push(file);
                }
           }
            const event = new ShowToastEvent({
                title: 'Successful',
                duration:' 5000',
                message: 'Delete Successful',
                variant: 'success'
              });
              this.dispatchEvent(event);
              this.isLoading=false;
        })
        .catch(error => {   
            console.log('error--> ',error);
            this.isLoading=false;
        })
        
    }
    newFolderCreate(event){
        this.isLoading=true;
        const folderName = this.template.querySelector('lightning-input[data-id="NewFolder"]').value;
        const folderId = this.breadcrumbList[this.breadcrumbList.length-1].key;
        folderCreate({foldName : folderName, foldId : folderId})
        .then(result => {

            if(result.length==this.allFiles.length+this.allFolder.length){
                const event = new ShowToastEvent({
                    title: 'Error',
                    message: ' same folder name already exists',
                    variant: 'error'
                  });
                  this.dispatchEvent(event);
            }
            else{
                this.allFiles=[];
                this.allFolder=[];
                for(let file of result){
                    if(file.type == 'folder'){
                        this.allFolder.push(file);
                    }
                    else{
                        this.allFiles.push(file);
                    }
               }
            const event = new ShowToastEvent({
                title: 'Successful',
                message: 'Folder create Successful',
                variant: 'success'
              });
              this.dispatchEvent(event);
            }
            this.isLoading=false;
        })
        .catch(error => {   
            console.log('error--> ',error);
            this.isLoading=false;
        })
    }
    handleFileChange(event){
        this.isLoading=true;
        if(event.target.files.length > 0) {
            const file = event.target.files[0];
            var reader = new FileReader();
            reader.onload = () => {
                var base64 = reader.result.substring(reader.result.indexOf('base64,') + 7);
                this.fileName = file.name;
                this.fileData = base64;
                this.fileTyp = file.type;
                this.uploadButton=false;
            }
            reader.readAsDataURL(file);
        }
        this.isLoading=false;
    }
    fileUpload(){
        this.isLoading=true;
        const foldId = this.breadcrumbList[this.breadcrumbList.length-1].key;

        uploadFile({base64 : this.fileData , filename : this.fileName ,folderId : foldId , fileType: this.fileTyp})
        .then(result => {
            this.allFiles=[];
            this.allFolder=[];
            for(let file of result){
                if(file.type == 'folder'){
                    this.allFolder.push(file);
                }
                else{
                    this.allFiles.push(file);
                }
           }
            const event = new ShowToastEvent({
                title: 'Successful',
                message: 'Folder create Successful',
                variant: 'success'
              });
              this.dispatchEvent(event);
              this.fileName=null;
              this.fileData=null;
              this.fileTyp=null;
              this.uploadButton=true;
              this.isLoading=false;
        })
        .catch(error => {
            console.log('error--> ',error);
            this.isLoading=false;
        })
    }
   
    renderedCallback(){
        console.log('parent-renderedCallback');
    } 
    connectedCallback(){
        console.log('parent-connectedCallback');
    }
}