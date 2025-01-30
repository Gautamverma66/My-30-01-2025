import { LightningElement,track } from 'lwc';
import fetchContacts from '@salesforce/apex/SalesforceToSalesforceInt.fetchContacts'
import fetchFiles from '@salesforce/apex/SalesforceToSalesforceInt.fetchFiles'
import uploadFile from '@salesforce/apex/SalesforceToSalesforceInt.uploadFile'

export default class SalesforceToSalesforceIntegration extends LightningElement {
    @track contacts=[];
    @track files=[];
    isModalOpen;
    isLoading;
    selectedContact;
    tableShow;
    fileName;
    base64;
    
    connectedCallback(){
        this.isLoading=true;
        fetchContacts()
        .then(result => {
            console.log('res--> ',result);
            var temp=[];
            for(let rec of result){
                temp.push({value:rec.Id , label:rec.Name});
            }
            this.contacts=temp;
            this.isLoading=false;
        })
        .catch(error => {
            console.log(error);
            this.isLoading=false;
        })
        
    }
    handleContactChange(event){
        console.log('handleContactChange');
        console.log(event.currentTarget.value);
        this.selectedContact=event.currentTarget.value;
        this.isLoading=true;
        fetchFiles({contactId : this.selectedContact})
        .then(result => {
            console.log(result);
            this.files=result;
            this.isLoading=false;
            this.tableShow=true;
        })
        .catch(error => {
            console.log(error);
            this.tableShow=false;
            this.isLoading=false;
        })
    }

    openModal(){
        this.isModalOpen=true;
    }
    closeModal(){
        this.isModalOpen=false;
    }
    openfileUpload(event){
        const file = event.target.files[0]
        const fileReader = new FileReader();
		fileReader.readAsDataURL(file);
		fileReader.onload = () => {
			this.base64 = fileReader.result.substring(fileReader.result.indexOf('base64,')+7);
            this.fileName = file.name;

        }
    }
    handleClick(){
        this.isLoading=true;
        console.log('handleClick');
        this.isModalOpen=false;
        uploadFile({contactId :this.selectedContact , documentName : this.fileName, documentData :this.base64})
        .then(result => {
            console.log(result);
            if(result == true){
                fetchFiles({contactId : this.selectedContact}  )
                .then(result => {
                    console.log('res--> ',result);
                    this.files=result;
                    this.isLoading=false;
                })
                .catch(error => {
                    console.log(error);
                    this.isLoading=false;
                })
            }
        })
        .catch( error => {
            console.log(error);
            this.isLoading=false;
        })
    }
}