import { LightningElement, wire } from 'lwc';
import fetchContacts from '@salesforce/apex/DemoLwc.fetchContacts';
export default class Demo extends LightningElement {
    result
   // @wire(fetchContacts) 
   // contact

    @wire(fetchContacts) 
    contact({data,error}){
        this.result=data;
    }
   
}