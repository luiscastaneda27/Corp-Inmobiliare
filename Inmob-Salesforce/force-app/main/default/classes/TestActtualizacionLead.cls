@IsTest public class TestActtualizacionLead {
 
    static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
     static Lead prosp4;
    static account cuenta ;
@isTest static void GeneralesTestActualizarLead() {
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
                    vende1.CI_Usuario__c=u1.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                    insert vende1;
             
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test01239@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Cod_Proyecto__c=null;
                    prosp2.Status='Qualified';
                    prosp2.CI_Proyecto__c=proy.Id;
                    insert prosp2;
             
                   cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp2.CI_Identificacion__c];
             
                   opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor;
                
                    prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test06789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp.CI_Identificacion_C__c = '0300446010';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Cod_Proyecto__c=null;
                    prosp.CI_Proyecto__c=proy.Id;
                    prosp.Status='new';
                    insert prosp;
               
                   

         }
     }
@isTest static void GeneralesTestActualizarLead1() {
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
                    vende1.CI_Usuario__c=u1.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                    insert vende1;
             
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test012349@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '0926762014';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Cod_Proyecto__c=null;
                    prosp2.Status='new';
                    prosp2.CI_Proyecto__c=proy.Id;
                    prosp2.ownerid=vende1.CI_Usuario__c;
                    insert prosp2;
             
                   cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp2.CI_Identificacion__c];
             
                   opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor;
                
                    prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test06789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp.CI_Identificacion_C__c = '0926762014';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Cod_Proyecto__c=null;
                    prosp.CI_Proyecto__c=proy.Id;
                    prosp.ownerid=vende.CI_Usuario__c;
                    prosp.Status='new';
                    insert prosp;
               
                   

         }
     }

@isTest static void GeneralesTestActualizarLead2() {
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
                    vende1.CI_Usuario__c=u1.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                    insert vende1;
             
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test012349@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '0926762014';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Cod_Proyecto__c=null;
                    prosp2.Status='new';
                    prosp2.CI_Proyecto__c=proy.Id;
                    prosp2.ownerid=vende1.CI_Usuario__c;
                    insert prosp2;
             
                   cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp2.CI_Identificacion__c];
             
                   opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor;
                
                    prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test06789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0926762014';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp.CI_Identificacion_C__c = '0926762014';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Cod_Proyecto__c=null;
                    prosp.CI_Proyecto__c=proy.Id;
                    prosp.ownerid=vende.CI_Usuario__c;
                    prosp.Status='Qualified';
                    insert prosp;
               
                   

         }
     }
    
}