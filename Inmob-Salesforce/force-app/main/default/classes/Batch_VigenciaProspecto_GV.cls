global class Batch_VigenciaProspecto_GV implements Schedulable {
    global void execute(SchedulableContext sc) { 
      list<Proyecto__c> tproy =new list<Proyecto__c>();
      list<Proyecto__c> tproyecto =new list<Proyecto__c>();
      list<lead> tlead =new list<lead>();
      List<lead>updlead = new List<lead>();
      list<Opportunity> op =new list<Opportunity>();
      set<String> idproy = new set<String>();
         string prospecto;
          string Cuenta;
          string lead;
          string Supervisor;
          Datetime myDate;
          string Responsable;
      
      List<string> toAddress = new List<string>();
        string nombre='crespo';
        string codigo='andrade';
   //inicio envio correo proceso        
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
            mail.setSubject('Proceso Vigencia Prospecto por Ejecutarse');
            mail.setplainTextBody('Estimad@, Proceso Vigencia Prospecto LA GRAN VICTORIA ');
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
   //fin envio correo          
        
      system.debug('VigenciaDeProspectos' );
         tproy =[select  id,name,CI_Estado__c,Dia_de_Vigencia__c,Usuario_Resposable__c 
                  from Proyecto__c where CI_Estado__c=:'Activo' and name like '%GRA%VIT%'];
    
        for (Proyecto__c item:tproy)
        {  myDate =DateTime.now()-Integer.valueOf(item.Dia_de_Vigencia__c);//date myDate = system.today();//-item.Dia_de_Vigencia__c; 
            system.debug('fecha '+ myDate.toString() );
            Asignacion_Web_to_Lead__c VEND = [SELECT Id, CI_Usuario__c,CI_Usuario__r.ManagerId
                                           FROM Asignacion_Web_to_Lead__c 
                                           WHERE  Proyecto_vendedor__c =: item.id and CI_Usuario_Activo_Web__c=:true
                                           ORDER BY CI_Fecha_Ultima_Asignacion__c ASC limit 1 ];
            Supervisor=  VEND.CI_Usuario__r.ManagerId;
            Responsable=item.Usuario_Resposable__c;
          idproy.add(item.id);
        }
        tlead=[select id,name,owner.Profile.name,createddate,Fecha_Reasignacion__c,CI_Identificacion__c, CI_Proyecto__c,
                OwnerId,Owner.name,CI_Id_Gestor__c,Status,Owner.isactive ,CI_Origen__c,CI_Proyecto__r.Dia_de_Vigencia__c,
                CI_Proyecto__r.Usuario_Resposable__c
                from lead where CI_Proyecto__c in:(idproy)  
               and((Fecha_Reasignacion__c=null and CreatedDate <=: myDate )or(Fecha_Reasignacion__c!=null and Fecha_Reasignacion__c <=: myDate))
               and Status in('New','Working') 
                and CI_Origen__c !=null limit 120 ];
        
// and owner.Profile.name='Asesor de Ventas' 
            for(lead clead:tlead)
            {   if(clead.Fecha_Reasignacion__c==null)
                  { if ((clead.CreatedDate <= myDate ))
                      {clead.Status='Dado de Baja';
                       clead.CI_Motivo_Baja__c='PLAZO 90 DIAS';
                       clead.Fecha_Reasignacion__c=DateTime.now();
                       system.debug('clead.name '+ clead.name );
                       if (clead.owner.isactive==false)
                          {system.debug('clead.itemlead '+ clead.name + ' Supervisor '+Supervisor);
                           clead.OwnerId=Supervisor;}
                       else
                          {clead.OwnerId=Responsable;}
                       updlead.add(clead);
                      }
                }
                if(clead.Fecha_Reasignacion__c!=null)
                  {if (clead.Fecha_Reasignacion__c <= myDate )
                      {clead.Status='Dado de Baja';
                       clead.CI_Motivo_Baja__c='PLAZO 90 DIAS';
                       clead.Fecha_Reasignacion__c=DateTime.now();
                       system.debug('clead.name '+ clead.name );
                       if (clead.owner.isactive==false)
                          {system.debug('clead.itemlead '+ clead.name + ' Supervisor '+Supervisor);
                           clead.OwnerId=Supervisor;}
                       else
                          {clead.OwnerId=Responsable;}
                       updlead.add(clead);
                      }
                   }
            }
         if (updlead.size()>0){update updlead;}  
    /*******************************************/
       //inicio envio correo proceso        
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
            mail.setSubject('Proceso Vigencia Prospecto FINALIZOs');
            mail.setplainTextBody('Estimad@, Proceso Vigencia Prospecto LA GRAN VICTORIA ');
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
   //fin envio correo          
        
    /*******************************************/
    } 
}