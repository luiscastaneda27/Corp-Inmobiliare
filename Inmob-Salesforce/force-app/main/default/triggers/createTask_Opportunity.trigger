trigger createTask_Opportunity on Opportunity (after insert) { 
    //Crear tarea cuando se crea una Oportunidad
    boolean flag = false;
    String oppId;
    Task tsk =new Task();
    for(Opportunity opor : Trigger.New) {
        if(opor.StageName == 'Probable') { 
            flag = true; 
            oppId = opor.id;
        }
    }
    if(flag) { 
        tsk.WhatId = oppId; 
        tsk.Subject = 'Nueva Oportunidad Creada'; 
        tsk.Priority = 'Normal'; 
        tsk.Status = 'Completed'; 
        tsk.ActivityDate = System.Today(); 
        insert tsk;
    }    
}