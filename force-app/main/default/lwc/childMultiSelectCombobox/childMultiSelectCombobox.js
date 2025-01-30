import { LightningElement,api,track } from 'lwc';

export default class ChildMultiSelectCombobox extends LightningElement {
    @api options;
    @api selectedValue;
    @api selectedValues = [];
    @api label;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track noResultMessage;
    @track showDropdown = false;
    @track singleSelectPillShow;
 
    connectedCallback() {
        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        this.optionData = optionData;
        if(this.multiSelect){
            this.searchString = '0 Option(s) Selected';
        }   
        else{
            this.searchString = null;
        }
            
    }
 
    filterOptions(event) {
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ) {
            this.noResultMessage = '';
            if(this.searchString.length >= 2) {
                var flag = true;
                for(var i = 0; i < this.optionData.length; i++) {
                    if(this.optionData[i].label.toLowerCase().trim().startsWith(this.searchString.toLowerCase().trim())) {
                        this.optionData[i].isVisible = true;
                        flag = false;
                    } else {
                        this.optionData[i].isVisible = false;
                    }
                }
                if(flag) {
                    this.noResultMessage = "No results found for '" + this.searchString + "'";
                }
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
    }
 
    selectItem(event) {
        console.log('selectItem');
        var selectedVal = event.currentTarget.dataset.id;
        console.log(selectedVal);
        if(selectedVal) {
            console.log('selectedVal');
            var count = 0;
            console.log(this.optionData);
            console.log(JSON.parse(JSON.stringify(this.optionData)));
            var options = JSON.parse(JSON.stringify(this.optionData));
            for(var i = 0; i < options.length; i++) {
                if(options[i].value === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].value)) {
                            this.values.splice(this.values.indexOf(options[i].value), 1);
                        } else {
                            this.values.push(options[i].value);
                        }
                        options[i].selected = options[i].selected ? false : true;   
                    } else {
                        this.value = options[i].value;
                        this.searchString = options[i].label;
                        this.singleSelectPillShow=true;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
          
            if(this.multiSelect){
                this.searchString = count + ' Option(s) Selected';
                this.showDropdown = true;
            }   
            else{
                this.showDropdown = false;
            }
                
        }
    }
 
    showOptions() {
        console.log('showOptions');
        this.showDropdown = true;
        if(this.disabled == false && this.options) {
            this.noResultMessage = '';
            this.searchString = '';
            var options = this.optionData;
            for(var i = 0; i < options.length; i++) {
                options[i].isVisible = true;
            }
            if(options.length > 0) {
                this.showDropdown = true;
            }
            this.optionData = options;
        }
    }

 
    closePill(event) {
        console.log('closePill');
        var value = event.currentTarget.name;
        var count = 0;
        var options = JSON.parse(JSON.stringify(this.optionData));
        for(var i = 0; i < options.length; i++) {
            if(options[i].value === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].value), 1);
            }
            if(options[i].selected) {
                count++;
            }
        }
        this.optionData = options;
        if(this.multiSelect){
            this.searchString = count + ' Option(s) Selected';
            
            let ev = new CustomEvent('selectoption', {detail:this.values});
            this.dispatchEvent(ev);
        }
    }
 
    handleBlur() {
        console.log('handleBlur');
        var previousLabel;
        var count = 0;
        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].value === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {   
                count++;
            }
        }
        if(this.multiSelect){
            this.searchString = count + ' Option(s) Selected';
        }else{
            this.searchString = previousLabel;
        }
        
        this.showDropdown = false;
    }
    handleMouseOut(){
        this.showDropdown = false;
    }
    handleMouseIn(){
        this.showDropdown = true;
    }
    closeSingleSelectPill(){
        this.searchString = null;
        this.singleSelectPillShow=false
    }
   
    disconnectedCallback(){
        console.log('childdisconnectedCallback');
    }
}