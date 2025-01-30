trigger EmailFieldUpdate on Contact (before insert) {
    if(Trigger.isBefore){
        ContactEmailField.checkEmail(Trigger.new);
    }
}