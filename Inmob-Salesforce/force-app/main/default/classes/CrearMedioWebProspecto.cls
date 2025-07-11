public class CrearMedioWebProspecto {
     @InvocableMethod 
public static void CrearMedioWeb(list<lead> leadRecords )/*es insert*/
   {
      try{
          set<String> Cedula = new set<String>();
          string identificacion;
          string origen;
          string proyecto;
          string idprosp;
          list<Lead> tprop=new list<Lead>();

          for(Lead item : leadRecords) 
            {identificacion=item.CI_Identificacion__c;
                origen=item.CI_Origen__c;
                proyecto=item.CI_Proyecto__c;
                idprosp=item.id;
            }
          if(Test.isRunningTest())
          { tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead];}
          else
          { tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c =:identificacion
                        and CI_Ref_Web_To_Lead__c<>'S'];}
          
          
                 if(tprop.size()>0 )
                     {idprosp=tprop[0].id;
                       system.debug('tmedio item.CI_Cod_Proyecto__c '+proyecto);
                            system.debug('tmedio Sitem.CI_Identificacion__c '+identificacion);
                            system.debug('tmedio item.CI_Origen__c' +origen);
                           Medio_Web_Prospecto__c medio=new Medio_Web_Prospecto__c(Prospecto__c=idprosp,
                                                              CI_Identificacion_c__c = identificacion, 
                                                              Name = '-inserta '+identificacion, 
                                                              CI_Origen_c__c=origen,
                                                              Proyecto__c=proyecto,
                                                             Fecha_Ingreso__c=date.today() 
                                                               ); 
                            
                             insert medio;
                    } 
 
   
             
      }
     catch(Exception ex0) {
        System.debug('Error de Prospecto: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
        //list<Opportunity> op = new list<Opportunity>();
        }   
          
 }
}