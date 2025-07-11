global class Batch_VigenciaProspectoOportunidad_VI implements Schedulable {
    
   global void execute(SchedulableContext sc)     {
      string x1;
      string x2;
      string x3;
      string x4;
      list<Proyecto__c> tproy =new list<Proyecto__c>();
      list<lead> tleadFR =new list<lead>();
      list<lead> tleadFC =new list<lead>();
      list<account> cuenta =new list<account>();
      list<Opportunity> op =new list<Opportunity>();
      List<lead>updlead = new List<lead>();
      List<Opportunity>updop = new List<Opportunity>();
      List<string> toAddress = new List<string>();
      set<String> idproy = new set<String>();
      set<String> idcuenta = new set<String>();
      set<String> idcliente = new set<String>();
      List<lead>updleadFC = new List<lead>(); 
      List<lead>updleadFR = new List<lead>();
      string UsuarioUpd;
      string a;
      string b;
      string c;
      string d;
      Datetime myDate;
        system.debug('VigenciaDeProspectos' );
          tproy =[select  id,name,CI_Estado__c,Dia_de_Vigencia__c,Usuario_Resposable__c 
                  from Proyecto__c where CI_Estado__c=:'Activo' and name like '%VI%ITA%'];
        string Supervisor;
        
        for (Proyecto__c item:tproy)
        { myDate =DateTime.now()-Integer.valueOf(item.Dia_de_Vigencia__c);//date myDate = system.today();//-item.Dia_de_Vigencia__c;  
            system.debug('fecha '+ myDate.toString() );
                Asignacion_Web_to_Lead__c VEND = [SELECT Id, CI_Usuario__c,CI_Usuario__r.ManagerId
                                               FROM Asignacion_Web_to_Lead__c 
                                               WHERE  Proyecto_vendedor__c =: item.id and CI_Usuario_Activo_Web__c=:true
                                               and CI_Usuario__r.isactive=true
                                               ORDER BY CI_Fecha_Ultima_Asignacion__c ASC limit 1 ];
                Supervisor=  VEND.CI_Usuario__r.ManagerId;
          idproy.add(item.id);
        }
        
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
       
        /******************************************/
     tleadFC=[select id,name,owner.Profile.name,createddate,Fecha_Reasignacion__c,CI_Identificacion__c, CI_Proyecto__c,
                OwnerId,Owner.name,CI_Id_Gestor__c,Status,Owner.isactive ,CI_Origen__c,CI_Proyecto__r.Dia_de_Vigencia__c,
                CI_Proyecto__r.Usuario_Resposable__c
                from lead where CI_Proyecto__c in:(idproy)  
                and((Fecha_Reasignacion__c=null and CreatedDate <=: myDate )or(Fecha_Reasignacion__c!=null and Fecha_Reasignacion__c <=: myDate))
                 and CI_Origen__c !=null order by createddate  ];     

             for (lead item:tleadFC)
             {idcliente.add(item.CI_Identificacion__c);}
             system.debug('tleadFC 1 '+string.valueof(tleadFC.size()));
        //and owner.Profile.name='Asesor de Ventas'
        //and (CreatedDate<=:myDate or Fecha_Reasignacion__c<=:myDate) and Status!='Dado de Baja' 
              op = [select id, OwnerId,Owner.name,stagename,Proyecto__c,createddate,Owner.isactive,AccountId ,
                    Account.CI_Identificacion__c
                    from Opportunity 
                    where Account.CI_Identificacion__c in:(idcliente)  
                   // and Proyecto__c in:(idproy)  
                    and stagename not in('Vendida','No negociada') 
                    order by Account.CI_Identificacion__c  limit 80];

               for(Opportunity itemop:op)
               {  //system.debug('Account.CI_Identificacion__c 2'+itemop.Account.CI_Identificacion__c);
                   idcuenta.add(itemop.Account.CI_Identificacion__c);}

               tleadFC=[select id,name,owner.Profile.name,createddate,Fecha_Reasignacion__c,CI_Identificacion__c, CI_Proyecto__c,
                OwnerId,Owner.name,CI_Id_Gestor__c,Status,Owner.isactive ,CI_Origen__c,CI_Proyecto__r.Dia_de_Vigencia__c,
                CI_Proyecto__r.Usuario_Resposable__c
                from lead where  CI_Identificacion__c in:(idcuenta)  ];  
               integer ingreso=0; 

               system.debug('tleadFC 2'+string.valueof(tleadFC.size()));

               system.debug('op '+string.valueof(op.size()));

               for(Opportunity itemop:op)
                  { ingreso=0; 
                         system.debug('itemop.Account.CI_Identificacion__c '+itemop.Account.CI_Identificacion__c);
                                
                            for (lead itemlead:tleadFC )
                               {  
                               //system.debug('itemop.Account.CI_Identificacion__c '+itemop.Account.CI_Identificacion__c);
                                //system.debug('entro itemcta '+itemlead.CI_Identificacion__c);
                                    if(itemop.Account.CI_Identificacion__c==itemlead.CI_Identificacion__c)
                                        {//system.debug('entro oport itemop.AccountId '+itemlead.CI_Identificacion__c);
                                                                                          
                                           //--------------------------------------------------------lo nuevo
                                           if ((itemlead.Status=='Qualified' && itemop.createddate<=myDate))
                                              { itemop.stagename='No negociada';
                                                    // itemlead.Fecha_Reasignacion__c=DateTime.now();
                                                      system.debug('LO NUEVO actualiza itemlead.CI_Identificacion__c '+ itemlead.CI_Identificacion__c.toString()+' op '+itemop.id );
                                                    ingreso=1; 
                                              }
                                            //---------------------------------------------------------------------------------------
                                            if (itemlead.Fecha_Reasignacion__c!=null  &&  itemlead.Status!='Qualified')
                                              {system.debug('itemlead.Fecha_Reasignacion__c '+ itemlead.Fecha_Reasignacion__c.toString() );
                                                if ((itemop.Proyecto__c==itemlead.CI_Proyecto__c && itemlead.Fecha_Reasignacion__c<=myDate))
                                                   { itemop.stagename='No negociada';
                                                    // itemlead.Fecha_Reasignacion__c=DateTime.now();
                                                      system.debug('FR MISMO PROY se actualiza itemlead.CI_Identificacion__c '+ itemlead.CI_Identificacion__c.toString()+' op '+itemop.id );
                                                    ingreso=1; 
                                                   }
                                                  system.debug('itemop.createddate '+ itemop.createddate.toString() );
                                                if ((itemop.Proyecto__c!=itemlead.CI_Proyecto__c && itemop.createddate<=myDate))
                                                   { itemop.stagename='No negociada';
                                                     //itemlead.Fecha_Reasignacion__c=DateTime.now();
                                                     system.debug('FR <> PROY se actualiza itemlead.CI_Identificacion__c '+ itemlead.CI_Identificacion__c.toString() +' op '+itemop.id);
                                                     ingreso=1; 
                                                   }
                                              }
                                            
                                           if (itemlead.Fecha_Reasignacion__c==null &&  itemlead.Status!='Qualified')
                                              { system.debug('itemlead.createddate '+ itemlead.createddate.toString() );
                                                 if (itemop.Proyecto__c==itemlead.CI_Proyecto__c && itemlead.createddate<=myDate)
                                                   {itemop.stagename='No negociada';
                                                    //itemlead.Fecha_Reasignacion__c=DateTime.now();
                                                    system.debug('FC == PROY se actualiza itemlead.CI_Identificacion__c '+ itemlead.CI_Identificacion__c.toString()+' op '+itemop.id );
                                                    ingreso=1; 
                                                   }
                                                   system.debug('itemop.createddate '+ itemop.createddate.toString() );
                                                if (itemop.Proyecto__c!=itemlead.CI_Proyecto__c && itemop.createddate<=myDate)
                                                   { itemop.stagename='No negociada';
                                                     //itemlead.Fecha_Reasignacion__c=DateTime.now();
                                                    system.debug('FC <> PROY se actualiza itemlead.CI_Identificacion__c '+ itemlead.CI_Identificacion__c.toString()+' op '+itemop.id );
                                                   ingreso=1; 
                                                    }

                                                }  
                                        }
                                   
                                 }
                  }
                update op;
      /******************************************/
      string j;
      string f;
      string g;
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