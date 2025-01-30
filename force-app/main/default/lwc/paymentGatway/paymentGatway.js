import { LightningElement ,track} from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import payByAuthrizePayment from '@salesforce/apex/PaymentGatway.payByAuthrizePayment';
import payByEcheck from '@salesforce/apex/PaymentGatway.payByEcheck';

export default class PaymentGatway extends LightningElement {
    monthOptions = [
        {
            value: "01",
            label: "January"
        },
        {
            value: "02",
            label: "February"
        },
        {
            value: "03",
            label: "March"
        },
        {
            value: "04",
            label: "April"
        },
        {
            value: "05",
            label: "May"
        },
        {
            value: "06",
            label: "June"
        },
        {
            value: "07",
            label: "July"
        },
        {
            value: "08",
            label: "August"
        },
            {
            value: "09",
            label: "September"
        },
        {
            value: "10",
            label: "October"
        },
        {
            value: "11",
            label: "November"
        },
        {
            value: "12",
            label: "December"
        }
    ];
    yearOptions = [
        {
            value: "2023",
            label: "2023"
        },
        {
            value: "2024",
            label: "2024"
        },
        {
            value: "2025",
            label: "2025"
        },
        {
            value: "2026",
            label: "2026"
        },
        {
            value: "2027",
            label: "2027"
        },
        {
            value: "2028",
            label: "2028"
        },
            {
            value: "2029",
            label: "2029"
        },
        {
            value: "2030",
            label: "2030"
        }
    
    ];

   
    @track eCheckshow = false;
    @track cardNumber;
    @track cvv;
    @track cardMonth;
    @track cardYear;
    @track showSpinner = false;
    @track routingNumber;
    @track accountNumber;
    @track accountName;
    @track cardNumberShow='';

    handleChangeECheck(event) {
        console.log('handleChangeECheck');
        console.log(event.detail.value);
        if(event.target.name == 'RoutingNumber'){
            this.routingNumber = event.detail.value;
        } else if(event.target.name == 'AccNumber'){
            this.accountNumber = event.detail.value;
        } else if(event.target.name == 'AccountName'){
            this.accountName = event.detail.value;
        }
    }

    handleChange(event) {
        console.log('handleChange');
        console.log('handleChange--> ',event.detail.value);
        if(event.target.name == 'cardNumber'){
            

            var cardNo=event.detail.value;
            console.log('length--> ',cardNo.length);
            if(cardNo.length > this.cardNumberShow.length){
                if(cardNo.length==4 || cardNo.length==9 || cardNo.length==14){
                    console.log('1');
                    this.cardNumber=this.cardNumber+cardNo[cardNo.length-1]+' ';
                    if(cardNo.length != 4){
                        console.log('2')
                        this.cardNumberShow=this.cardNumberShow+'*'+' ';
                    }
                    else{
                        console.log('3');
                        this.cardNumberShow=this.cardNumberShow+cardNo[cardNo.length-1]+' ';
                    }
                    
                }
                else{
                    console.log('4');
                        if(cardNo.length>5 ){
                            console.log('5');
                            if(cardNo.length>15 ){
                                console.log('6');
                                this.cardNumberShow=this.cardNumberShow+'X';
                                this.cardNumber=this.cardNumber+cardNo[cardNo.length-1];
                            }
                            else{
                                console.log('7');
                                this.cardNumberShow=this.cardNumberShow+'*';
                                this.cardNumber=this.cardNumber+cardNo[cardNo.length-1];
                            }
                            
                        }
                        else{
                            console.log('8');
                            this.cardNumberShow=cardNo;
                            this.cardNumber=cardNo;
                        }
                    
                }
            }else{
                if(cardNo.length==4 || cardNo.length==9 || cardNo.length==14){
                    console.log('1');
                    console.log(cardNo);
                    console.log(this.cardNumberShow);
                    this.cardNumberShow=cardNo+' '; 
                    console.log(this.cardNumberShow+'abc');
                }
                else{
                    this.cardNumberShow=cardNo;
                }
                
            }
                
        } else if(event.target.name == 'Month'){
            this.cardMonth = event.detail.value;
        } else if(event.target.name == 'Year'){
            this.cardYear = event.detail.value;
        } else if(event.target.name == 'cvvNumber'){
            console.log(event.detail.value);
           
            this.cvv = event.detail.value;
        }
    }
    handlePaymentCheck(){
        console.log(this.routingNumber);
        this.handleSpinner();
       
        
        payByEcheck({ routingNumber : this.routingNumber, accountNumber : this.accountNumber, nameOnAccount : this.accountName})
        .then(res=>{
            let title = res;
            this.ShowToast('Success!', title, 'success', 'dismissable');
        }).catch(err=>{
            this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
        }).finally(() => {
            this.handleSpinner();
        })
    }
    handlePayment(){
        var cardNo=this.cardNumber.split(" ").join("");
        console.log(cardNo);
        console.log(this.cvv);
        this.handleSpinner();
        payByAuthrizePayment({ cardNumber : cardNo,
                        cardMonth : this.cardMonth, cardYear : this.cardYear, cvv : this.cvv
        })
        .then(res=>{
            let message = res;
            console.log(res);
      
            this.ShowToast('Success!', message, 'success', 'dismissable');
        }).catch(err=>{
            console.log(err);
          
            this.ShowToast('Error!!', err.body.message, 'error', 'dismissable');
        }).finally(() => {
            this.handleSpinner();
        })
    }

    handleSpinner(){
        this.showSpinner = !this.showSpinner;
    }

    ShowToast(title, message, variant, mode){
        console.log('message');
        const evt = new ShowToastEvent({
        title: title,
        message:message,
        variant: variant,
        duration:' 5000',
        mode: mode
        });
        this.dispatchEvent(evt);
    }
    showECheckForm(){
        console.log('in E check');
        this.eCheckshow=true;
    }
    showCreditForm(){
        this.eCheckshow=false;
    }
   
}