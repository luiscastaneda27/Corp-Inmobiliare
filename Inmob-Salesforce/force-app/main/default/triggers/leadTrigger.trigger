trigger leadTrigger on Lead (before insert, before update) {
    //new CI_LeadTriggerHandler().run();
    /*if(Trigger.isInsert) {        
        if(Trigger.isBefore){ 
            leadTriggerHelperClass.validateIdentity();
        }
    }
   
    if(Trigger.isUpdate) {        
        if(Trigger.isBefore) { 
            leadTriggerHelperClass.validateProyect(trigger.New);
        }
    }*/ 
}