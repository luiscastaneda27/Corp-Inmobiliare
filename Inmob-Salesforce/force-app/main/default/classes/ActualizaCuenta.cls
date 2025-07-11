public class ActualizaCuenta {
  @InvocableMethod 
   public static void ActualizaCuentaDatos(list<Actualizar_Cuenta__c> ctaRecords )//si es  Update 
       { List<account>updcta = new List<account>();
       // List<Actualizar_Cuenta__c> procesar=new List<Actualizar_Cuenta__c> ();
        set<String> idLeads = new set<String>();
        // system.debug('leadRecords[0].CI_Identificacion__c '+leadRecords[0].CI_Identificacion__c);
        system.debug('ActualizaCuentaDatos ');
             for(Actualizar_Cuenta__c l : ctaRecords) 
                      {
                      idLeads.add(l.Cedula__c);
                      }
         List<account> cta = [SELECT  Id, ownerid,CI_Proyecto__c, CI_Identificacion__c,  CI_Origen__c,  CI_Email__c
                                                    FROM    account 
                                                    WHERE   CI_Identificacion__c in:(idLeads) ]  ; 
            
       for(Actualizar_Cuenta__c l : ctaRecords)
          {
            for (account lc : cta) 
                {system.debug('l.Cedula__c '+l.Cedula__c);
                 system.debug('lc.CI_Identificacion__c '+lc.CI_Identificacion__c);
                 system.debug('l.Usuario__c '+l.Usuario__c);
                 system.debug('lc.OwnerId '+lc.OwnerId);
                    if((l.Cedula__c==lc.CI_Identificacion__c)  && (l.Usuario__c <> lc.OwnerId)) 
                     { lc.OwnerId=l.Usuario__c;
                       lc.CI_Proyecto__c=l.Proyecto__c; 
                       lc.CI_Reassignment_date_time__c=DateTime.now();
                       updcta.add(lc); 
                      l.Procesado__c=true;
                     }
                }
           update ctaRecords;
          }
       
         if (updcta.size()>0){update updcta;}

 }
}