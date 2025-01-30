import { LightningElement,wire,track } from 'lwc';
import { publish,MessageContext } from 'lightning/messageService';
import msgChannel from '@salesforce/messageChannel/Demo__c';

export default class LMSTesting extends LightningElement {
    msg = '';

    // Wired message Context
    @wire(MessageContext)
    context;

    handleChange(event) {
        this.msg = event.detail.value;
    }

    handlePublish() {
            let payload = {
                source: "LWC",
                messageBody: this.msg
            };
            publish(this.context, msgChannel, payload);
        
    }
}