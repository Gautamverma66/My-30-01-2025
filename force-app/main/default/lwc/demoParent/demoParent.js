import { LightningElement, track } from 'lwc';

export default class DemoParent extends LightningElement {
    @track msg;
    handleCustomEvent(event) {
        const textVal = event.detail;
        this.msg = textVal;
    }
    btnHandler1(event){
        console.log('event');
        console.log( event.target.value);
        const name = event.target.value;
        const selectEvent= new CustomEvent('mycustomevent1', {
            detail: name
        });
       this.dispatchEvent(selectEvent);
    }
}