import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteContact from '@salesforce/apex/ContactsDetailsOnAccountClass.deleteContact'
import fetchContacts from '@salesforce/apex/ContactsDetailsOnAccountClass.fetchContacts'
export default class ContactsDetailsOnAccountChild extends LightningElement {
    @api conDetails;
    
    constructor(){
        super();
        console.log('-----Child-constructor-----');
        console.log('-----recId-----',this.conDetails);
    }
    connectedCallback(){
        console.log('-----Child-connectedCallback-----');
        console.log('-----recId-----',this.conDetails);
       
        

    }
    renderedCallback(){
        console.log('-----Child-renderedCallback-----');
        console.log('-----recId-----',this.conDetails);
    }
    errorCallback(){
        console.log('-----Child-errorCallback-----');
        console.log('-----recId-----',this.conDetails);
    }
    disconnectedCallback(){
        console.log('-----Child-disconnectedCallback-----');
        console.log('-----recId-----',this.conDetails);
    }
    handleTask(){
        console.log('-----handleTask-----');
    }
    handleDelete(event){
        console.log('-----handleDelete-----');
        console.log(event.target.value);
        var contactId = event.target.value;
        deleteContact({conId : event.target.value})
        .then(result => {
            console.log('-----result-----',result);
            if(result == 'true'){
                const Cusevent = new ShowToastEvent({
                    title: 'Successful',
                    message: 'Successful Delete',
                    variant: 'success'
                  });
                this.dispatchEvent(Cusevent);
                console.log('-----contactId-----',contactId);
                var conEvent = new CustomEvent('findcontact', { detail:        
                    {conId : contactId}});
                this.dispatchEvent(conEvent); 
            }
            else{
                const event = new ShowToastEvent({
                    title: 'error',
                    message: 'Error!!',
                    variant: 'error'
                  });
                  this.dispatchEvent(event);
            }
           
         })
        .catch(error => {
            const event = new ShowToastEvent({
                title: 'error',
                message: 'Error!! '+error,
                variant: 'error'
              });
              this.dispatchEvent(event);
        });
    }
    handleChange(event){
        console.log(event.target.value);
        console.log(event.target.id);
        console.log(event.target.dataset.field);
        if(event.target.dataset.field == 'FirstName'){
            var conEvent = new CustomEvent('changescontact', { detail:        
                {conId : event.target.id, fieldName :'FirstName',value : event.target.value}});
            this.dispatchEvent(conEvent); 
        }
        else if(event.target.dataset.field == 'LastName'){
            var conEvent = new CustomEvent('changescontact', { detail:        
                {conId : event.target.id, fieldName :'LastName' ,value : event.target.value}});
            this.dispatchEvent(conEvent);
        }
        else if(event.target.dataset.field == 'Email'){
            var conEvent = new CustomEvent('changescontact', { detail:        
                {conId : event.target.id, fieldName :'Email' ,value : event.target.value}});
            this.dispatchEvent(conEvent);
        }
        else if(event.target.dataset.field == 'Phone'){
            var conEvent = new CustomEvent('changescontact', { detail:        
                {conId : event.target.id, fieldName :'Phone' ,value : event.target.value}});
            this.dispatchEvent(conEvent);
        }
    }
}