import { LightningElement ,api, track} from 'lwc';
export default class ChildClientSidePagination extends LightningElement {
   
    @api record;
    @api field;
    @api recordId;
    @api value;
    nameField;
    urlLink;
   
    
    connectedCallback() {
        console.log('child-connectedCallback');
        if(this.field=='Name'){
           this.nameField=true;
        }
        else{
            this.nameField=false;
        }
        this.value = this.record[this.field];
        this.urlLink=null;
        this.urlLink='/' + this.recordId ;
    }
   
  
      
    constructor(){
        super();
        console.log('child-constructor');
    }
   
    renderedCallback(){
        console.log('child-renderedCallback');
    }

    
}