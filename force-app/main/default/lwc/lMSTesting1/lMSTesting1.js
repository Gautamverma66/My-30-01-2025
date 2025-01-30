import { LightningElement ,track} from 'lwc';
import {createMessageContext,releaseMessageContext,APPLICATION_SCOPE,subscribe,unsubscribe} from 'lightning/messageService';
import POVMC from "@salesforce/messageChannel/Demo__c";
export default class LMSTesting1 extends LightningElement {
        receivedMessage = '';
        subscription = null;
    
        // NOT Using Wired MessageContext.
        // Instead using createMessageContext,releaseMessageContext to subscribe unsubscribe
        // @wire(MessageContext)
        // context;
    
        context = createMessageContext();
    
        handleSubscribe() {
            
            if (this.subscription) {
                return;
            }
            this.context = createMessageContext();
            this.subscription = subscribe(this.context, POVMC, (message) => {
                this.handleMessage(message);
            });
        }
    
        handleMessage(event) {
            if (event) {
                let message = event.messageBody;
                let source = event.source;
                this.receivedMessage = 'Message: ' + message + '.\n \n Sent From: ' + source;
            }
        }
    
        handleUnsubscribe() {
            unsubscribe(this.subscription);
            this.subscription = undefined;
            releaseMessageContext(this.context);
        }
    
        get subscribeStatus() {
            return this.subscription ? 'TRUE' : 'FALSE';
        }
}