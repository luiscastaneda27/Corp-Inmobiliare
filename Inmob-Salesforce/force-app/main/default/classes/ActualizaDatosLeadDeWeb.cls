public class ActualizaDatosLeadDeWeb {
  	@InvocableMethod 
    public static void ActualizaCuenta(list<lead> leadRecords )/*si es  insert */
    {  integer cont=0;
     
        for(Lead item : leadRecords){
            system.debug('actualizao datos '+item.CI_Monto_de_Ingresos__c);
            
            if (item.CI_Origen__c=='Web' || item.EsWeb__c==true){   
                List<Lead> pw = [SELECT Id, CI_Movil__c,  CI_Origen__c,  Email,Ownerid,
                                 CI_Identificacion__c,CI_Asignado__c,CI_Identificacion_C__c,
                                 CI_Proyecto__c,Status, CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                                 from lead 
                                 where CI_Identificacion__c =:item.CI_Identificacion__c 
                                 and CI_Ref_Web_To_Lead__c<>'S'
                                 order by createddate desc] ;
            cont=pw.size();
          /*  if (pw.size()>1)
              {for(lead ipw:pw)
                 {if (cont==1)
                   {system.debug('Actualizacion '+ipw.id +' cont '+cont);
                     delete pw;  
                   }
                  cont=cont-1;
                 }
              }
             */  
            Set<Lead> accSet = new Set<Lead>();
            system.debug('ActualizacionLead paso item.CI_Origen__c '+item.CI_Origen__c);
            system.debug(' ActualizacionLead paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
            system.debug('item.EsWeb__c '+item.EsWeb__c);

                List<account> cta = [SELECT  Id, ownerid,CI_Proyecto__c, CI_Movil__c,  CI_Origen__c,  CI_Email__c
                                     FROM    account 
                                     WHERE   CI_Identificacion__c =: item.CI_Identificacion__c
                                     and id <>:item.Id];
                
                if(pw.size()>0 ){
                    for(account icta:cta){
                        icta.CI_Email__c= item.Email;
                        icta.CI_Movil__c=item.CI_Movil__c;
                        icta.CI_Origen__c=item.CI_Origen__c;
                    }
                    update cta;
                    
                    for(lead ipw:pw){  
                        ipw.Email= item.Email;
                        ipw.CI_Email__c= item.Email;
                        ipw.CI_Movil__c=item.CI_Movil__c;
                        ipw.CI_Origen__c= item.CI_Origen__c;
                        system.debug('actualizao datos '+item.CI_Monto_de_Ingresos__c);
                        if (item.CI_Monto_de_Ingresos__c!=null && item.CI_Monto_de_Ingresos__c!='')
                           {ipw.CI_Monto_de_Ingresos__c=item.CI_Monto_de_Ingresos__c;}
                        
                        if (item.CI_Numero_de_dormitorios__c!=null && item.CI_Numero_de_dormitorios__c!='')
                           {ipw.CI_Numero_de_dormitorios__c=item.CI_Numero_de_dormitorios__c;}
                        
                        if (item.CI_Formulario__c!=null && item.CI_Formulario__c!='')
                           {ipw.CI_Formulario__c=item.CI_Formulario__c;}
                        
                        ipw.EsWeb__c=true;
                        system.debug('id lead '+ipw.id);
                    }
                  
                    update pw;
				   
                }
            }       
        } 
    }
}