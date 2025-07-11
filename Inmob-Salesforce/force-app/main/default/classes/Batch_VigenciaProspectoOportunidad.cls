global class Batch_VigenciaProspectoOportunidad implements Schedulable {
    
    global void execute(SchedulableContext sc)     {
      string x1;
      string x2;
      string x3;
      string x4;
      list<Proyecto__c> tproy =new list<Proyecto__c>();
      list<lead> tlead =new list<lead>();
      list<account> cuenta =new list<account>();
      list<Opportunity> op =new list<Opportunity>();
      List<string> toAddress = new List<string>();
      string a;
      string b;
      string c;
      string d;
        system.debug('VigenciaDeProspectos' );
          tproy =[select  id,name,CI_Estado__c,Dia_de_Vigencia__c,Usuario_Resposable__c 
                  from Proyecto__c where CI_Estado__c=:'Activo'];
        
        if(!Test.isRunningTest()){ 
            user usuario = [select id,name,Profile.name,userrole.name,createddate,email from user where Profile.name like '%adm%sist%'  and isactive=true limit 1];
            toAddress.add(usuario.Email);}
        else{
            toAddress.add('Cristiancrespoandrade@gmail.com');
        } 
        if(toAddress.size()>0){
          OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName like 'Cor%are%Internacional'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setSubject('Proceso Vigencia Prospecto oportunidad por Ejecutarse');
            mail.setplainTextBody('Estimad@, Proceso Vigencia Prospecto por Ejecutarse');
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            try {
                Messaging.sendEmail(allmsg,false);
                //return;
            }catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
        
        for (Proyecto__c item:tproy)
        {   Datetime myDate =DateTime.now()-Integer.valueOf(item.Dia_de_Vigencia__c);//date myDate = system.today();//-item.Dia_de_Vigencia__c; 
            system.debug('fecha '+ myDate.toString() );
         Asignacion_Web_to_Lead__c VEND = [SELECT Id, CI_Usuario__c,CI_Usuario__r.ManagerId
                                           FROM Asignacion_Web_to_Lead__c 
                                           WHERE  Proyecto_vendedor__c =: item.id and CI_Usuario_Activo_Web__c=:true
                                           and CI_Usuario__r.isactive=true
                                           ORDER BY CI_Fecha_Ultima_Asignacion__c ASC limit 1 ];
         
         string Supervisor=  VEND.CI_Usuario__r.ManagerId;
         
         tlead=[select id,name,owner.Profile.name,createddate,Fecha_Reasignacion__c,CI_Identificacion__c, CI_Proyecto__c,
                OwnerId,Owner.name,CI_Id_Gestor__c,Status,Owner.isactive,CI_Origen__c  
                from lead where CI_Proyecto__c =: item.id and (CreatedDate<=:myDate or Fecha_Reasignacion__c<=:myDate) 
                and owner.Profile.name='Asesor de Ventas' and Status!='Dado de Baja' 
                and CI_Origen__c !=null limit 1];
         
         //system.debug ('fecha proepscto '+tlead[0].name + ' fecha creeacion '+ tlead[0].CreatedDate.tostring() );
         //system.debug ('fecha proepscto '+tlead[0].name + ' fecha Fecha_Reasignacion__c '+isnull(tlead[0].Fecha_Reasignacion__c.tostring() ),'') );
         for(lead itemlead:tlead)
             { system.debug ('nombre '+itemlead.name);
                 cuenta=[select id,CI_Identificacion__c,CI_Proyecto__c from account 
                       where CI_Identificacion__c =: itemlead.CI_Identificacion__c and CI_Proyecto__c =: itemlead.CI_Proyecto__c];
                  if (cuenta.size()>0)
                     {op = [select id, OwnerId,Owner.name,stagename,Proyecto__c,createddate,Owner.isactive from Opportunity 
                            where AccountId=: cuenta[0].Id and stagename not in('Vendida','No negociada')];
                       if (op.size()>0)
                          {
                              for(Opportunity itemop:op)
                                 {  //system.debug('Fecha_Reasignacion__c '+ itemlead.Fecha_Reasignacion__c.toString() );
                                   if (itemlead.Fecha_Reasignacion__c!=null)
                                      {system.debug('itemlead.Fecha_Reasignacion__c '+ itemlead.Fecha_Reasignacion__c.toString() );
                                        if ((itemop.Proyecto__c==itemlead.CI_Proyecto__c && itemlead.Fecha_Reasignacion__c<=myDate)||itemop.Owner.isactive==False)
                                           { itemop.stagename='No negociada';
                                             itemlead.OwnerId=item.Usuario_Resposable__c;}
                                          system.debug('itemop.createddate '+ itemop.createddate.toString() );
                                        if ((itemop.Proyecto__c!=itemlead.CI_Proyecto__c && itemop.createddate<=myDate)||itemop.Owner.isactive==False)
                                           { itemop.stagename='No negociada';
                                           itemlead.OwnerId=item.Usuario_Resposable__c;}
                                      }
                                   if (itemlead.Fecha_Reasignacion__c==null)
                                      { system.debug('itemlead.createddate '+ itemlead.createddate.toString() );
                                     if (itemop.Proyecto__c==itemlead.CI_Proyecto__c && itemlead.createddate<=myDate)
                                       {itemop.stagename='No negociada';
                                       itemlead.OwnerId=item.Usuario_Resposable__c;}
                                  system.debug('itemop.createddate '+ itemop.createddate.toString() );
                                    if (itemop.Proyecto__c!=itemlead.CI_Proyecto__c && itemop.createddate<=myDate)
                                       { itemop.stagename='No negociada';
                                      itemlead.OwnerId=item.Usuario_Resposable__c;}
                                  }
                                }
                              
                                update op; 
                          }
                     }
            
                     if (itemlead.owner.isactive==false)
                       {
                           system.debug('itemlead.itemlead '+ itemlead.name + ' Supervisor '+Supervisor);
                         itemlead.OwnerId=Supervisor;
                       }             
             }
            update tlead;
        }
         /*******************************************/
      string j;
      string f;
      string g;
      string h;
      string a1;
      string a2;
      string a3;
      string a4;
      string a5;
      string a6;
      string a7;
      string a8;
        if(!Test.isRunningTest()){ 
            user usuario = [select id,name,Profile.name,userrole.name,createddate,email from user where Profile.name like '%adm%sist%'  and isactive=true limit 1];
            toAddress.add(usuario.Email);}
        else{
            toAddress.add('Cristiancrespoandrade@gmail.com');
        } 
       
        if(toAddress.size()>0){
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName like 'Cor%are%Internacional'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddress);
            mail.setSubject('Proceso Vigencia Prospecto oportunidad Ejecutado Exitosamente');
            mail.setplainTextBody('Estimad@, Proceso Vigencia Prospecto oportunidad Ejecutado Exitosamente');
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            try {
                Messaging.sendEmail(allmsg,false);
                return;
            }catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
    /*******************************************/ 
    }
}