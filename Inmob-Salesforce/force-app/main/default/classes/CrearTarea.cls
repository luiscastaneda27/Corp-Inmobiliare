public class CrearTarea {
  
    
    public static void NuevaTarea(id prospecto, id cuenta, string tipo )/*si es insert I o Update U*/
    { List<lead> updlead = new List<lead>();
       task tsk = new task();
     
        updlead=[SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c,
                CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, ConvertedAccountId,CI_Proyecto__c
                from lead 
                where id =: prospecto ];
     List<Opportunity> opor  = [select id, name, Proyecto__c,Prospecto__c, Prospecto__r.name, Cuenta__c, AccountId, 
                        Account.CI_Identificacion__c, Account.CI_Proyecto__c 
                        from Opportunity where Account.CI_Identificacion__c=: updlead[0].CI_Identificacion__c
                        and Proyecto__c =: updlead[0].CI_Proyecto__c
                        and StageName not in('Vendida','No negociada') ];
     
     
     if(opor.size()==0)
        { tsk.WhoId = prospecto; 
        tsk.Subject = 'Cotizacion Web'; 
        tsk.Priority = 'Normal'; 
        tsk.Status = 'Open'; 
        tsk.OwnerId=updlead[0].Ownerid;
        tsk.ActivityDate = System.Today(); 
             insert tsk;}
     else
       { tsk.WhatId = cuenta; 
        tsk.Subject = 'Cotizacion Web'; 
        tsk.Priority = 'High'; 
        tsk.Status = 'Open'; 
        tsk.OwnerId=updlead[0].Ownerid;
        tsk.ActivityDate = System.Today(); 
        insert tsk;}
         
     
        
   
       
    }

}