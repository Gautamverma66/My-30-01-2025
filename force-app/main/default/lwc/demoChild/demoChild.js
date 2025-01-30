import { LightningElement,track } from 'lwc';

export default class DemoChild extends LightningElement {
    @track msg1;
    btnHandler(event){
        console.log('event');
        console.log( event.target.value);
        const name = event.target.value;
        const selectEvent= new CustomEvent('mycustomevent', {
            detail: name
        });
       this.dispatchEvent(selectEvent);
    }
    handleCustomEvent1(event) {
        const textVal = event.detail;
        this.msg1 = textVal;
    }
}