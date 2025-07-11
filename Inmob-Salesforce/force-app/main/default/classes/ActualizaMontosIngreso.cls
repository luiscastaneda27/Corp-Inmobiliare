public class ActualizaMontosIngreso {
    @InvocableMethod 
    public static void ActualizaMontosIngreso(list<Medio_Web_Prospecto__c> leadRecords )/*si es  insert */
    {  integer cont=0;
       string CI_Identificacion;
     string CI_Email;
      string CI_Movil;
     string CI_Origen;
     string Monto_de_Ingresos;
     string Numero_de_dormitorios;
     string Formulario;
     boolean EsWeb;
     List<Lead> pw = new List<Lead>();
    
        for(Medio_Web_Prospecto__c item : leadRecords){
            CI_Identificacion =item.CI_Identificacion_c__c;
          }
            
            system.debug('actualizao CI_Identificacion '+CI_Identificacion);
     
       
                pw = [SELECT Id, CI_Movil__c,  CI_Origen__c,  Email,Ownerid,
                                 CI_Identificacion__c,CI_Asignado__c,CI_Identificacion_C__c,
                                 CI_Proyecto__c,Status, CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                                 from lead 
                                 where CI_Identificacion__c =:CI_Identificacion
                                 and CI_Ref_Web_To_Lead__c='S'
                                 ] ;
                if (pw.size()>0)
                   {for(lead ipw:pw)
                 {
                   Formulario=ipw.CI_Formulario__c;
                     system.debug('ipw.CI_Formulario__c datos '+ipw.CI_Formulario__c);
                    Monto_de_Ingresos  = ipw.CI_Monto_de_Ingresos__c;
                     system.debug('ipw.CI_Monto_de_Ingresos__c datos '+ipw.CI_Monto_de_Ingresos__c);
                     Numero_de_dormitorios=ipw.CI_Numero_de_dormitorios__c;
                     system.debug('ipw.CI_Numero_de_dormitorios__c datos '+ipw.CI_Numero_de_dormitorios__c);
                 }
              }
                
             pw = [SELECT Id, CI_Movil__c,  CI_Origen__c,  Email,Ownerid,
                                 CI_Identificacion__c,CI_Asignado__c,CI_Identificacion_C__c,
                                 CI_Proyecto__c,Status, CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                                 from lead 
                                 where CI_Identificacion__c =:CI_Identificacion
                                 and CI_Ref_Web_To_Lead__c<>'S'
                              ] ;
                if (pw.size()>0)
                {
                     for(lead ipw:pw){  
                        system.debug('actualizao datos '+Monto_de_Ingresos);
                        if (Monto_de_Ingresos!=null && Monto_de_Ingresos!='')
                           {ipw.CI_Monto_de_Ingresos__c=Monto_de_Ingresos;}
                        
                        if (Numero_de_dormitorios!=null && Numero_de_dormitorios!='')
                           {ipw.CI_Numero_de_dormitorios__c=Numero_de_dormitorios;}
                        
                        if (Formulario!=null && Formulario!='')
                           {ipw.CI_Formulario__c=Formulario;}
                        
                        //ipw.EsWeb__c=true;
                        system.debug('id lead '+ipw.id);
                    }
                  update pw;
                system.debug('actualizao datos x fin ');
                }
              
        
    }
    }