public class ActualizaDiasSinGestionar {
  @InvocableMethod 
public static void NuevaTarea(list<task> tarea )
  { date fecha=system.today();
    string prospecto;
    string oportunidad;
   
        for(task item : tarea) 
          {
      
           if(item.whoid  != null && item.Subject != 'Cotizacion Web')
              {
               list<lead> whoid = [SELECT Id, CI_Fecha_ultima_gestion__c,CI_Origen__c FROM lead WHERE Id =:item.whoid limit 1];
               if(whoid.size()>0 )
               { system.debug('whoid[0].CI_Origen__c  '+whoid[0].CI_Origen__c);
                system.debug('whoid[0].Id  '+whoid[0].id);
                system.debug('whoid[0].CI_Fecha_ultima_gestion__c  '+whoid[0].CI_Fecha_ultima_gestion__c);
                system.debug('fecha '+fecha);
                  if (whoid[0].CI_Fecha_ultima_gestion__c != fecha)
                     {whoid[0].CI_Fecha_ultima_gestion__c=fecha;
                      update whoid;
                     }
                }
              }
         if(item.whatid != null && item.Subject != 'Cotizacion Web')
            {list<Opportunity> whaid  = [SELECT Id, StageName,CI_Fecha_prox_act__c FROM Opportunity WHERE Id =:item.WhatId  limit 1];
             if(whaid.size()>0 && whaid[0].CI_Fecha_prox_act__c!=fecha)
              {whaid[0].CI_Fecha_prox_act__c=fecha;
               update whaid;}
            }
          
         
          }
   }
}