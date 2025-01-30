trigger Reparent on Contact (after update) { 
            Reparenting.parent(Trigger.new,Trigger.old);     
}