import { LightningElement ,wire,track} from 'lwc';
import  getRecords from '@salesforce/apex/MultiSelectComboboxController.getRecords'



export default class MultiSelectCombobox extends LightningElement {
    
    @track selectedValue = '';//selected values
    @track selectedValueList = [];//selected values
    @track options; //= options;
    @track multiSelectShow;
  

 
    //fetch picklist options
    @wire(getRecords)
    wirePickList({ error, data }) {
        if (data) {
            console.log('data-->',data)
            var temp=[];
            for(let rec of data){
                console.log(rec);
                temp.push({ value : rec.Name , label : rec.Name})
            }
            this.options=temp;
            console.log('option--> ',this.options);
        } else if (error) {
            console.log(error);
        }
    }
     
   
    changeToggle(event){
        console.log(event.target.checked);
        this.multiSelectShow=event.target.checked;
        console.log('multiSelectShow--> ',this.multiSelectShow);
    }
    connectedCallback(){
        console.log('parentconnectedCallback');
    
    }
    disconnectedCallback(){
        console.log('parentdisconnectedCallback');
    }
}