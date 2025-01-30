trigger Rating on Gautam__c (after insert,after update) {
        ParentRating.updateRating(Trigger.new);
}