public with sharing class CheckBoxWrapperC {
    public SObject obj {get; set;}
    public Boolean selectedCheckBox {get; set;}
    public CheckBoxWrapperC(SObject o) {
        obj=o;
        selectedCheckBox=false;
    }
}