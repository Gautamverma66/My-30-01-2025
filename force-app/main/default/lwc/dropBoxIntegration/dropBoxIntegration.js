import { LightningElement,track } from 'lwc';
import checkUserExist from '@salesforce/apex/DropBoxIntegration.checkUserExist';
import authorizationUrl from '@salesforce/apex/DropBoxIntegration.authorizationUrl';
import getAccessToken from '@salesforce/apex/DropBoxIntegration.getAccessToken';
import fileData from '@salesforce/apex/DropBoxIntegration.getData';
import uploadToDropBox from '@salesforce/apex/DropBoxIntegration.uploadToDropBox';
import deleteData from '@salesforce/apex/DropBoxIntegration.deleteData';
import downloadFile from '@salesforce/apex/DropBoxIntegration.downloadFile';
import creteFol from '@salesforce/apex/DropBoxIntegration.createFolder';

export default class DropBoxIntegration extends LightningElement {
    @track nameField;
    @track folderName="Gautam";
    @track path = ''; 
    @track isModalOpen = false;
    @track isCreate = false;
    @track base64;
    @track fname;
    @track breadcrumbList = [];
    @track isLoading = false;
    connectedCallback() {
        this.isLoading = true;
        checkUserExist()
        .then(result => {
            if(result == 'false') {
                const queryString = window.location.search;
                const urlParams = new URLSearchParams(queryString);
                var codeUrl = urlParams.get('code');
                if(urlParams.has('code')) {
                    getAccessToken({code : codeUrl})
                    .then(result => {
                        console.log(result);
                        if(result == true){
                            fileData({path : this.path})
                            .then(data => {
                                this.nameField = data;
                                console.log('nameField--> ',this.nameField);
                            });
                            this.breadcrumbList.push({key : '' , value : 'Home'});
                        }
                    });
                } else {
                    authorizationUrl()
                    .then(url => {
                        window.open(url,"_self");
                    });
                }
            } else {
                console.log('fetch Data');
                fileData({path : this.path})
                .then(data => {
                    this.nameField = data;
                    console.log('nameField2--> ',this.nameField);
                });
                this.breadcrumbList.push({key : '' , value : 'Home'});
            }
        });
        this.isLoading = false;
    }
    openfileUpload(event) {
        const file = event.target.files[0]
        const fileReader = new FileReader();
		fileReader.readAsDataURL(file);
		fileReader.onload = () => {
			this.base64 = fileReader.result.substring(fileReader.result.indexOf('base64,')+7);
            this.fname = file.name;

        }
    }
    handleClick(){
        this.isLoading = true;
        this.isModalOpen = false;
        this.isUpload = false;
        var b = this.base64;
        var fn = this.fname;
        var p = this.path;
        uploadToDropBox({ file : b, filename : fn, path : p }).then(result=> {
           
            fileData({path : p})
            .then(data => {
                this.nameField =data;
                this.isLoading = false;
            })
        })
    }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isUpload = true;
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.isUpload = false;
        this.isCreate = false;

    }
    createModel() {
        // to open modal set isModalOpen tarck value as true
        this.isCreate = true;
        this.isModalOpen = true;
    }
    inner(event) {
        this.isLoading = true;
        this.path = event.currentTarget.dataset.path;
        var p = this.path;
        fileData({path : p})
        .then(d => {
            this.isLoading = false;
            this.nameField = d;
        })
        this.breadcrumbList.push({key : event.currentTarget.dataset.path , value : event.currentTarget.dataset.name});
       
    }
    handleBreadcrumb(event) {
        this.isLoading = true;
        this.path = event.currentTarget.dataset.p;
        var p = this.path;
        fileData({path : p})
        .then(data => {
            this.isLoading = false;
            this.nameField = data;
        })
        this.breadcrumbList.splice(parseInt(event.currentTarget.dataset.index)+1);
    }

    deleteF(event) {
        this.isLoading = true;
        var p = event.currentTarget.dataset.path;
        deleteData({path : p})
        .then(result => {
            fileData({path : this.path})
            .then(data => {
                this.nameField = data;
                this.isLoading = false;
            })
        })
    }
    downloadF(event) {
        this.isLoading = true;
        var p = event.currentTarget.dataset.path;
        downloadFile({path : p})
        .then(result => {
            console.log(result);
            const link = document.createElement("a");
            link.href = result;
            link.download = 'file';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            this.isLoading = false;
        })
    }
    createF(event){
        this.isLoading = true;
        this.folderName = this.template.querySelector('lightning-input[data-id="NewFolder"]').value;
        this.isModalOpen = false;
        this.isCreate = false;
        creteFol({path : this.path, folderName : this.folderName})
        .then(result => {
            fileData({path : this.path})
            .then(data => {
                this.nameField = data;
                this.isLoading = false;
            })
        })
    }
}