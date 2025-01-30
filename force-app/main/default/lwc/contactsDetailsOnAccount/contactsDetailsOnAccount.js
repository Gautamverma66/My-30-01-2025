import { LightningElement,api,track } from 'lwc';
import fetchContacts from '@salesforce/apex/ContactsDetailsOnAccountClass.fetchContacts'
import upsertContact from '@salesforce/apex/ContactsDetailsOnAccountClass.upsertContact'
export default class ContactsDetailsOnAccount extends LightningElement {
    @api recordId;
    @track conList;
    childShow = false;
    @track temConList =[];
    constructor(){
        super();
        console.log('-----constructor-----');
        console.log('-----recordId-----',this.recordId);
    }
    connectedCallback(){
        console.log('-----connectedCallback-----');
        console.log('-----recordId-----',this.recordId);
        fetchContacts({ accId: this.recordId })
        .then(result => {
            console.log('-----result-----',result);
            this.conList = result;
            console.log('-----this.conList-----',this.conList);
            // for (let key of Object.keys(result)) {
            //     this.fields.push({ value:key, label:result[key]});
            // }
 
         })
        .catch(error => {
            console.error('Error:', error);
        });
    }
    renderedCallback(){
        console.log('-----renderedCallback-----');
        console.log('-----recordId-----',this.recordId);
    }
    errorCallback(){
        console.log('-----errorCallback-----');
        console.log('-----recordId-----',this.recordId);
    }
    disconnectedCallback(){
        console.log('-----disconnectedCallback-----');
        console.log('-----recordId-----',this.recordId);
    }
    handleAddContact(){
        console.log('-----handleAddContact-----');
        console.log('-----recordId-----',this.recordId);
        if(this.childShow == false){
            this.childShow = true;
        }
        else{
            this.conList.push({Id : this.conList.length , FirstName : '', LastName : '', Email : '', Phone : ''});
        }
    }
    handleSave(){
        console.log('-----handleSave-----');
        console.log('-----this.conList-----',this.conList);
        console.log('-----this.conList-----',JSON.stringify(this.conList));
        upsertContact({contactList : this.conList})
        .then(result => {
            console.log('-----result-----',result);
         })
        .catch(error => {
            console.error('Error:', error);
        });
    }
    removeContact(event){
        console.log('-----removeContact-----');
        console.log(event.detail.conId);
        var contactId = event.detail.conId;
        this.conList = this.conList.filter(contact => contact.Id != contactId);
        console.log('-----this.conList-----',this.conList);
    }
    changesINContact(event){
        console.log('-----changesINContact-----');
        console.log(event.detail.conId);
        console.log(event.detail.value);
        console.log(event.detail.fieldName);
        this.temConList = this.conList.filter(contact => contact.Id === event.detail.conId);
        console.log('--1--');
        console.log('temConList--> ',this.temConList);
        console.log(JSON.stringify(this.temConList));
        if(event.detail.fieldName == 'FirstName'){
            console.log('--2--');
            this.temConList.FirstName = event.detail.value;
        }
        else if(event.detail.fieldName == 'LastName'){
            console.log('--3--');
            this.temConList.LastName = event.detail.value;
        }
        else if(event.detail.fieldName == 'Email'){
            console.log('--4--');
            this.temConList.Email = event.detail.value;
        }
        else if(event.detail.fieldName == 'Phone'){
            console.log('--5--');
            this.temConList.Phone = event.detail.value;
        }
        console.log('--11--');
        this.conList = this.conList.filter(contact => contact.Id != event.detail.conId);
        console.log('-----this.conList-----',JSON.stringify(this.conList));
        console.log(JSON.stringify(this.temConList));
        this.conList.push(this.temConList);
        console.log('-----this.conList-----',JSON.stringify(this.conList));

    }
}