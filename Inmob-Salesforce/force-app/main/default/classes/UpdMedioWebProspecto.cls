public class UpdMedioWebProspecto {
  @InvocableMethod 
   public static void ActualizaCuenta(list<Opportunity> oportunidad )/*si es  insert */
   {  
    string cedula ;
    string proyecto ;
    string idoportunidad ;
       for(Opportunity item : oportunidad) 
         { 
            proyecto=item.Proyecto__c;
            idoportunidad=item.id;       
         }  
       list<Opportunity> oportupd=[ select id, CloseDate, CI_Fecha_Inicio__c,esweb__c, 
                                   Account.CI_Identificacion__c ,CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                                     from Opportunity where id=:idoportunidad
                                    and Proyecto__c=:proyecto limit 1];
       
  
          
              if (oportupd[0].id != null && oportupd.size()>0 )
             {cedula=oportupd[0].Account.CI_Identificacion__c;}
       
      system.debug('cedula '+cedula);
       system.debug('proyecto '+proyecto);
       system.debug('idoportunidad '+idoportunidad);
       
list<lead> pros=[seLECT Id, createddate, fecha_reasignacion__c, CI_Origen__c,
                      Name, Status, CI_Identificacion__c, Ownerid, Owner.Name, 
                      CI_Id_Gestor__c, CI_Cod_Proyecto__c, CI_Proyecto__r.name, EsWeb__c, 
                      CI_Ref_Web_To_Lead__c, email, CI_Email__c, CI_Movil__c,
                      CI_Identificacion_C__c, CI_Asignado__c ,CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                      from lead where CI_Identificacion__c =:cedula];
       if(pros.size()>0)
         {system.debug('pros[0].cedula '+cedula);
           system.debug('pros[0].id '+pros[0].id);
           system.debug('pros[0].CI_Origen__c '+pros[0].CI_Origen__c);
           system.debug('proyecto '+proyecto);
           list<Medio_Web_Prospecto__c> prosweb=[select 
                                      id, CI_Identificacion_c__c, CI_Origen_c__c, Name, Prospecto__c, Proyecto__c,
                                      oportunidad__c 
                                        from Medio_Web_Prospecto__c 
                                        where CI_Identificacion_c__c =:cedula
                                                     and Prospecto__c=:pros[0].id
                                                    and CI_Origen_c__c=:pros[0].CI_Origen__c
                                                    and Proyecto__c =:proyecto 
                                                    and oportunidad__c=:null
                                     order by createddate asc limit 1];
          if(oportupd[0].esweb__c==true)
            {for(Medio_Web_Prospecto__c temweb:prosweb)
                { system.debug('actualizo '+  temweb.CI_Identificacion_c__c);
                 temweb.oportunidad__c=idoportunidad;
                }
                update prosweb;
            }
                
           for(lead itempros:pros)
              {if(itempros.EsWeb__c==true || itempros.CI_Origen__c=='Web')
                {
                   for(Opportunity item : oportupd) 
                      { 
                        item.CI_Formulario__c=itempros.CI_Formulario__c;
                        item.CI_Monto_de_Ingresos__c=itempros.CI_Monto_de_Ingresos__c;
                        item.CI_Numero_de_dormitorios__c=itempros.CI_Numero_de_dormitorios__c;    
                      }  
                    update oportupd;
                }
                  
              }
         }
      

   }
       
  }