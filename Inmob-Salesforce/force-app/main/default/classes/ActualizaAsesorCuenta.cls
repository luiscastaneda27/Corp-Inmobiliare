public class ActualizaAsesorCuenta {
  @InvocableMethod 
   public static void ActualizaCuenta(list<lead> leadRecords )//si es  Update 
       { List<account>updcta = new List<account>();
       // List<Actualizar_Cuenta__c> procesar=new List<Actualizar_Cuenta__c> ();
        set<String> idLeads = new set<String>();
        // system.debug('leadRecords[0].CI_Identificacion__c '+leadRecords[0].CI_Identificacion__c);
        // system.debug('leadRecords[0].ownerid '+leadRecords[0].ownerid);
             for(Lead item : leadRecords) 
                      {system.debug('leadRecords[0].ownerid '+item.ownerid);
                           Actualizar_Cuenta__c nuevo =new Actualizar_Cuenta__c (
                                                          Name = '-inserta '+item.CI_Identificacion__c, 
                                                          Cedula__c=item.CI_Identificacion__c,
                                                         Usuario__c=item.OwnerId,
                                                          Procesado__c=false,
                                                          Proyecto__c=item.CI_Proyecto__c );
                             insert nuevo;
                       //tabla que se llama desde flujo y actualiza dats en la cuenta
                        }
                   
                 
        }
 }