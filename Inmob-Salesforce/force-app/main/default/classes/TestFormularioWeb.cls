@IsTest public class TestFormularioWeb {
        static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
     static Lead prosp4;
    static account cuenta ;
@isTest static void GeneralesTestProcesoWeb() {
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
      User u1 = new User();
        u1.Firstname = 'mauricie';
        u1.LastName = 'ruiz';
        u1.email = 'mauruiz@outlook.com';
        u1.Alias = 'alias3';
        u1.CommunityNickname = 'commnick3';
        u1.EmailEncodingKey = 'UTF-8';
        u1.Username = 'mauryrui@outlook.com';
        u1.TimeZoneSidKey = 'America/Denver';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive =true;
        u1.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u1.UserRoleId = r.Id;
        insert u1;
            
    User u = new User();
        u.Firstname = 'mauricio';
        u.LastName = 'ruiz';
        u.email = 'mauryruiz@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'mauryruiz123@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u.UserRoleId = r.Id;
        insert u;
        
       
         System.runAs ( u ) {
          Proyecto__c proy = new Proyecto__c();
            proy.Name = 'LA RIOJA';
            proy.CI_Estado__c = 'Activo';
            proy.Codigo_Proyecto__c = '7001';
            insert proy;
            system.debug('proyecto 1 '+proy.id);
             
             Proyecto__c proy2 = new Proyecto__c();
            proy2.Name = 'Villa Italia';
            proy2.CI_Estado__c = 'Activo';
            proy2.Codigo_Proyecto__c = '7002';
            insert proy2;
             
            system.debug('proyecto 2 '+proy2.id);
 		      
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy2.id;
                    vende1.CI_Usuario__c=u.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                     insert vende1;
             
            	
             
                    prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test089@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp.CI_Identificacion_C__c = '0914766324';
                    prosp.CI_Origen__c = 'Web';
                    prosp.CI_Cod_Proyecto__c=null;
                    prosp.CI_Proyecto__c=proy2.Id;
                    prosp.Status='new';
                    insert prosp;
             
                               
                //Insert Account

                cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c limit 1];
             
              
                    opportunity opor1 = new opportunity();
                    opor1.name='esta es una oportunidad';
                    opor1.AccountId=cuenta.Id;
                    opor1.closedate=system.today();
                    opor1.stagename='Nueva';  //opor.Lead__c=cand.id;
                    opor1.Proyecto__c=proy.Id;
                    //opor.OwnerId=asesor;
                    insert opor1;
                        
                    Prospecto_Web__c pw5=new Prospecto_Web__c();  
                    pw5.Identificacion__c=prosp.CI_Identificacion__c;
             		pw5.Procesado__c=false;
                    pw5.Prospecto__c	= prosp.id;
                    pw5.Proyecto__c = proy.id;
                    pw5.con_error__c=false;
                    insert pw5;  
             
                  Procesarformularioweb.ProcesarWeb();
                 //*******************************************************************
                    prosp3 = new Lead();
           			prosp3.LastName = 'TestLead';
                    prosp3.Email = 'test012388775@gmail.com';
                    prosp3.CI_Personeria__c = '1';
                    prosp3.CI_Tipo_Iden__c ='2';
                    prosp3.CI_Identificacion__c = '0914766324';
                    prosp3.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp3.CI_Identificacion_C__c = '0926762014';
                    prosp3.CI_Origen__c = 'Qualified';
                    prosp3.CI_Cod_Proyecto__c=null;
                    prosp3.Status='new';
                    prosp3.CI_Proyecto__c=proy.Id;
                    insert prosp3;
             
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp3.CI_Identificacion__c limit 1];
             
                    Prospecto_Web__c pww=new Prospecto_Web__c();  
                    pww.Identificacion__c=prosp3.CI_Identificacion__c;
             		pww.Procesado__c=false;
                    pww.Prospecto__c	= prosp3.id;
                    pww.Proyecto__c = proy.id;
                    pww.con_error__c=false;
                    insert pww;
             
 				   Procesarformularioweb.ProcesarWeb();
             
                    opportunity opor = new opportunity();
                    opor.name='esta es una oportunidad';
                    opor.AccountId=cuenta.Id;
                    opor.closedate=system.today();
                    opor.stagename='Nueva';  //opor.Lead__c=cand.id;
                    opor.Proyecto__c=proy.Id;
                    //opor.OwnerId=asesor;
                    insert opor;
             
                    Prospecto_Web__c pw3=new Prospecto_Web__c();  
                    pw3.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw3.Procesado__c=false;
                    pw3.Prospecto__c	= prosp3.id;
                    pw3.Proyecto__c = proy.id;
                    pw3.con_error__c=false;
                    insert pw3;
                  //Procesarformularioweb.ProcesarWeb();
             
                   Prospecto_Web__c pw=new Prospecto_Web__c();  
                    pw.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw.Procesado__c=false;
                    pw.Prospecto__c	= prosp3.id;
                    pw.Proyecto__c = proy2.id;
                    pw.con_error__c=false; 
                    insert pw;
             
                   Procesarformularioweb.ProcesarWeb();
             
                   list<lead> plw =[select id,Status,CI_Identificacion__c from lead where CI_Identificacion__c=:'0914766324' ];
                    plw[0].Status='Dado de Baja';
                    plw[0].CI_Motivo_Baja__c='PERFIL FALSO';
                    update plw;
             
             
                   Prospecto_Web__c pw29=new Prospecto_Web__c();  
                    pw29.Identificacion__c=plw[0].CI_Identificacion__c;
             		pw29.Procesado__c=false;
                    pw29.Prospecto__c	= plw[0].id;
                    pw29.Proyecto__c = proy2.id;
                    pw29.con_error__c=false;
                    insert pw29;  
             
                  Procesarformularioweb.ProcesarWeb();
             
               
          

         }
     }
@isTest static void GeneralesTestProcesoWeb1() {
     UserRole rj = [SELECT Id FROM UserRole WHERE Name='Jefe Ventas Rioja'];
    
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
      User u1 = new User();
        u1.Firstname = 'mauricie';
        u1.LastName = 'ruiz';
        u1.email = 'mauruiz@outlook.com';
        u1.Alias = 'alias3';
        u1.CommunityNickname = 'commnick3';
        u1.EmailEncodingKey = 'UTF-8';
        u1.Username = 'mauryrui@outlook.com';
        u1.TimeZoneSidKey = 'America/Denver';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive =true;
        u1.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u1.UserRoleId = r.Id;
        insert u1;
    
        User u1a = new User();
        u1a.Firstname = 'mau1ricie';
        u1a.LastName = 'rui1z';
        u1a.email = 'mauruiz1@outlook.com';
        u1a.Alias = 'alias31S';
        u1a.CommunityNickname = 'commnick31S';
        u1a.EmailEncodingKey = 'UTF-8';
        u1a.Username = 'mauruiz1@outlook.com';
        u1a.TimeZoneSidKey = 'America/Denver';
        u1a.LocaleSidKey = 'en_US';
        u1a.EmailEncodingKey = 'UTF-8';
        u1a.LanguageLocaleKey = 'en_US';
        u1a.isActive =true;
        u1a.ProfileId = [SELECT id FROM profile where Name = 'Jefe de Ventas' or name = 'Jefe de Ventas'].Id;
        u1a.UserRoleId = rj.Id;
        insert u1a;
            
    User u = new User();
        u.Firstname = 'mauricio';
        u.LastName = 'ruiz';
        u.email = 'mauryruiz@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'mauryruiz123@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u.UserRoleId = r.Id;
        insert u;
        
       
         System.runAs ( u ) {
          Proyecto__c proy = new Proyecto__c();
            proy.Name = 'LA RIOJA';
            proy.CI_Estado__c = 'Activo';
            proy.Codigo_Proyecto__c = '7001';
            insert proy;
            system.debug('proyecto 1 '+proy.id);
             
             Proyecto__c proy2 = new Proyecto__c();
            proy2.Name = 'Villa Italia';
            proy2.CI_Estado__c = 'Activo';
            proy2.Codigo_Proyecto__c = '7002';
            insert proy2;
             
            system.debug('proyecto 2 '+proy2.id);
 		      
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy2.id;
                    vende1.CI_Usuario__c=u.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                     insert vende1;
             
                    Asignacion_Web_to_Lead__c vende2 = new Asignacion_Web_to_Lead__c();
                    vende2.Proyecto_vendedor__c=proy.id;
                    vende2.CI_Usuario__c=u1a.id;
                    vende2.CI_Usuario_Activo_Web__c=true;
                    insert vende2;
            	
             
                    prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test089@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp.CI_Identificacion_C__c = '0914766324';
                    prosp.CI_Origen__c = 'Web';
                    prosp.CI_Cod_Proyecto__c=null;
                    prosp.CI_Proyecto__c=proy2.Id;
                    prosp.Status='new';
                    //prosp.ownerid=u1a.id;
                    insert prosp;
             
                               
                //Insert Account

                cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c limit 1];
             
              
                    opportunity opor1 = new opportunity();
                    opor1.name='esta es una oportunidad';
                    opor1.AccountId=cuenta.Id;
                    opor1.closedate=system.today();
                    opor1.stagename='Nueva';  //opor.Lead__c=cand.id;
                    opor1.Proyecto__c=proy.Id;
                    //opor.OwnerId=asesor;
                    insert opor1;
                        
                    Prospecto_Web__c pw5=new Prospecto_Web__c();  
                    pw5.Identificacion__c=prosp.CI_Identificacion__c;
             		pw5.Procesado__c=false;
                    pw5.Prospecto__c	= prosp.id;
                    pw5.Proyecto__c = proy.id;
                    pw5.con_error__c=false;
                    insert pw5;  
             
                  Procesarformularioweb.ProcesarWeb();
                 //*******************************************************************
                    prosp3 = new Lead();
           			prosp3.LastName = 'TestLead';
                    prosp3.Email = 'test012388775@gmail.com';
                    prosp3.CI_Personeria__c = '1';
                    prosp3.CI_Tipo_Iden__c ='2';
                    prosp3.CI_Identificacion__c = '0914766324';
                    prosp3.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp3.CI_Identificacion_C__c = '0926762014';
                    prosp3.CI_Origen__c = 'Qualified';
                    prosp3.CI_Cod_Proyecto__c=null;
                    prosp3.Status='new';
                    prosp3.CI_Proyecto__c=proy.Id;
                    insert prosp3;
             
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp3.CI_Identificacion__c limit 1];
             
                    Prospecto_Web__c pww=new Prospecto_Web__c();  
                    pww.Identificacion__c=prosp3.CI_Identificacion__c;
             		pww.Procesado__c=false;
                    pww.Prospecto__c	= prosp3.id;
                    pww.Proyecto__c = proy.id;
                    pww.con_error__c=false;
                    insert pww;
             
 				   Procesarformularioweb.ProcesarWeb();
             
                    opportunity opor = new opportunity();
                    opor.name='esta es una oportunidad';
                    opor.AccountId=cuenta.Id;
                    opor.closedate=system.today();
                    opor.stagename='No negociada';  //opor.Lead__c=cand.id;
                    opor.Proyecto__c=proy2.Id;
                    //opor.OwnerId=asesor;
                    insert opor;
             
                    Prospecto_Web__c pw3=new Prospecto_Web__c();  
                    pw3.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw3.Procesado__c=false;
                    pw3.Prospecto__c	= prosp3.id;
                    pw3.Proyecto__c = proy.id;
                    pw3.con_error__c=false;
                    insert pw3;
                  //Procesarformularioweb.ProcesarWeb();
             
                   Prospecto_Web__c pw=new Prospecto_Web__c();  
                    pw.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw.Procesado__c=false;
                    pw.Prospecto__c	= prosp3.id;
                    pw.Proyecto__c = proy2.id;
                    pw.con_error__c=false; 
                    insert pw;
             
                   Procesarformularioweb.ProcesarWeb();
             
                   list<lead> plw =[select id,Status,CI_Identificacion__c from lead where CI_Identificacion__c=:'0914766324' ];
                    plw[0].Status='Dado de Baja';
                    plw[0].CI_Motivo_Baja__c='PERFIL FALSO';
                    update plw;
             
                   Prospecto_Web__c pw9=new Prospecto_Web__c();  
                    pw9.Identificacion__c=plw[0].CI_Identificacion__c;
             		pw9.Procesado__c=false;
                    pw9.Prospecto__c	= plw[0].id;
                    pw9.Proyecto__c = proy.id;
                    pw9.con_error__c=false;
                    insert pw9;
         Procesarformularioweb.ProcesarWeb();
             
               
          

         }
     }
@isTest static void GeneralesTestProcesoWeb3() {
     UserRole rj = [SELECT Id FROM UserRole WHERE Name='Jefe Ventas Rioja'];
    
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
      User u1 = new User();
        u1.Firstname = 'mauricie';
        u1.LastName = 'ruiz';
        u1.email = 'mauruiz@outlook.com';
        u1.Alias = 'alias3';
        u1.CommunityNickname = 'commnick3';
        u1.EmailEncodingKey = 'UTF-8';
        u1.Username = 'mauryrui@outlook.com';
        u1.TimeZoneSidKey = 'America/Denver';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive =true;
        u1.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u1.UserRoleId = r.Id;
        insert u1;
    
           User u = new User();
        u.Firstname = 'mauricio';
        u.LastName = 'ruiz';
        u.email = 'mauryruiz@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'mauryruiz123@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u.UserRoleId = r.Id;
        insert u;
        
       
         System.runAs ( u ) {
          Proyecto__c proy = new Proyecto__c();
            proy.Name = 'LA RIOJA';
            proy.CI_Estado__c = 'Activo';
            proy.Codigo_Proyecto__c = '7001';
            insert proy;
            system.debug('proyecto 1 '+proy.id);
             
             Proyecto__c proy2 = new Proyecto__c();
            proy2.Name = 'Villa Italia';
            proy2.CI_Estado__c = 'Activo';
            proy2.Codigo_Proyecto__c = '7002';
            insert proy2;
             
            system.debug('proyecto 2 '+proy2.id);
 		      
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy2.id;
                    vende1.CI_Usuario__c=u.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                     insert vende1;
                    	
             
                 //*******************************************************************
                    prosp3 = new Lead();
           			prosp3.LastName = 'TestLead';
                    prosp3.Email = 'test012388775@gmail.com';
                    prosp3.CI_Personeria__c = '1';
                    prosp3.CI_Tipo_Iden__c ='2';
                    prosp3.CI_Identificacion__c = '0914766324';
                    prosp3.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp3.CI_Identificacion_C__c = '0926762014';
                    prosp3.CI_Origen__c = 'Web';
                    prosp3.CI_Cod_Proyecto__c=null;
                    prosp3.Status='new';
                    prosp3.CI_Proyecto__c=proy.Id;
                    insert prosp3;
             
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp3.CI_Identificacion__c limit 1];
             
                    opportunity opor = new opportunity();
                    opor.name='esta es una oportunidad';
                    opor.AccountId=cuenta.Id;
                    opor.closedate=system.today();
                    opor.stagename='No negociada';  //opor.Lead__c=cand.id;
                    opor.Proyecto__c=proy.Id;
                    //opor.OwnerId=asesor;
                    insert opor;
             
                    Prospecto_Web__c pw=new Prospecto_Web__c();  
                    pw.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw.Procesado__c=false;
                    pw.Prospecto__c	= prosp3.id;
                    pw.Proyecto__c = proy.id;
                    pw.con_error__c=false; 
                    insert pw;
             
                   Procesarformularioweb.ProcesarWeb();
  
               
          

         }
     }
@isTest static void GeneralesTestProcesoWeb4() {
     UserRole rj = [SELECT Id FROM UserRole WHERE Name='Jefe Ventas Rioja'];
    
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
      User u1 = new User();
        u1.Firstname = 'mauricie';
        u1.LastName = 'ruiz';
        u1.email = 'mauruiz@outlook.com';
        u1.Alias = 'alias3';
        u1.CommunityNickname = 'commnick3';
        u1.EmailEncodingKey = 'UTF-8';
        u1.Username = 'mauryrui@outlook.com';
        u1.TimeZoneSidKey = 'America/Denver';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive =true;
        u1.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u1.UserRoleId = r.Id;
        insert u1;
    
           User u = new User();
        u.Firstname = 'mauricio';
        u.LastName = 'ruiz';
        u.email = 'mauryruiz@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'mauryruiz123@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u.UserRoleId = r.Id;
        insert u;
        
       
         System.runAs ( u ) {
          Proyecto__c proy = new Proyecto__c();
            proy.Name = 'LA RIOJA';
            proy.CI_Estado__c = 'Activo';
            proy.Codigo_Proyecto__c = '7001';
            insert proy;
            system.debug('proyecto 1 '+proy.id);
             
             Proyecto__c proy2 = new Proyecto__c();
            proy2.Name = 'Villa Italia';
            proy2.CI_Estado__c = 'Activo';
            proy2.Codigo_Proyecto__c = '7002';
            insert proy2;
             
            system.debug('proyecto 2 '+proy2.id);
 		      
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy2.id;
                    vende1.CI_Usuario__c=u.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                     insert vende1;
                    	
             
                 //*******************************************************************
                    prosp3 = new Lead();
           			prosp3.LastName = 'TestLead';
                    prosp3.Email = 'test012388775@gmail.com';
                    prosp3.CI_Personeria__c = '1';
                    prosp3.CI_Tipo_Iden__c ='2';
                    prosp3.CI_Identificacion__c = '0914766324';
                    prosp3.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp3.CI_Identificacion_C__c = '0926762014';
                    prosp3.CI_Origen__c = 'Web';
                    prosp3.CI_Cod_Proyecto__c=null;
                    prosp3.Status='Qualified';
                    prosp3.CI_Proyecto__c=proy.Id;
                    insert prosp3;
             
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp3.CI_Identificacion__c limit 1];

                    Prospecto_Web__c pw=new Prospecto_Web__c();  
                    pw.Identificacion__c=prosp3.CI_Identificacion__c;
             		pw.Procesado__c=false;
                    pw.Prospecto__c	= prosp3.id;
                    pw.Proyecto__c = proy.id;
                    pw.con_error__c=false; 
                    insert pw;
             
                   Procesarformularioweb.ProcesarWeb();
  
               
          

         }
     }
}