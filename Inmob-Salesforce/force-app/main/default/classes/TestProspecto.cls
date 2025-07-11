@IsTest public class TestProspecto {
    static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
    static account cuenta ;
    
    
    @isTest static void GeneralesVilla() {
  
            
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
             
                  Empresa__c emp = new Empresa__c(); 
                        emp.Name='MEISTERBLUE CIA. LTDA.';
                        insert emp;
        
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo',Empresa__c=emp.id);
    
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                   prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123489@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Proyecto__c=proy.id;
                    prosp.OwnerId = u.Id;
                    prosp.status='New';
                    insert prosp;
             
             
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Proyecto__c=proy.id;
                    prosp2.OwnerId = u1.Id;
                    insert prosp2;

                 
                               

                  
                        
                /*    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c];
             
                    opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor; 
             
              */
                  // CrearTarea.Nuevatarea(prosp.id,cuenta.id,'I');     

         }
     }
    @isTest static void GeneralesVilla2() {
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
             
                  Empresa__c emp = new Empresa__c(); 
                        emp.Name='MEISTERBLUE CIA. LTDA.';
                        insert emp;
        
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo',Empresa__c=emp.id);
    
            
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy.id;
                    vende1.CI_Usuario__c=u.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
             
                    insert vende1;
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u1.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
                               

                    prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123456789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '1303633158';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'Web';
                    prosp.CI_Cod_Proyecto__c='LA RIOJA';
                    insert prosp;
                     
              
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c];
             
                    opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor; 
             
                   
                    prosp2 = new Lead();
                    prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp2.CI_Origen__c = 'Web';
                    prosp2.CI_Cod_Proyecto__c='LA RIOJA';
                    insert prosp2;
         }
     }
    @isTest static void GeneralesVilla3() {
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
                     
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo');
                 Proyecto__c proy2 = new Proyecto__c(Name = 'Villa Italia', Codigo_Proyecto__c = '5002', CI_Estado__c = 'Activo');
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
            

                               

                    prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123456789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '1303633158';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'OBRA';
                    prosp.OwnerId = U.Id;
                    prosp.CI_Proyecto__c=proy.id;
                    //prosp.Status='Dado de Baja';
                    //prosp.CI_Motivo_Baja__c='ssss';
                    insert prosp;
                     
                     //lead updclt=[select id,OwnerId,Status from lead where id=:prosp.id limit 1];
                //         updclt.OwnerId=u1.id;
                 //        updclt.Status='Dado de Baja';
                //         updclt.CI_Motivo_Baja__c='ssss';
                //    update updclt;
             
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c];
             
 					Prospecto_Web__c pw=new Prospecto_Web__c();  
                    pw.Identificacion__c=prosp.CI_Identificacion__c;
             		pw.Procesado__c=false;
                    pw.Prospecto__c	= prosp.id;
                    pw.Proyecto__c = proy2.id;
                    insert pw;   
             
             
                                    
                    //creartarea.NuevaTarea(prosp.Id, cuenta.Id,'I' );
             
                    prosp2 = new Lead();
                    prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test01239@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '0300446010';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp2.CI_Origen__c = 'OBRA';
                    prosp2.OwnerId = U.Id;
                    prosp2.CI_Proyecto__c=proy.id;
                    //prosp.Status='Dado de Baja';
                    //prosp.CI_Motivo_Baja__c='ssss';
                    insert prosp2;
                        
                   // cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    ///where CI_Identificacion__c =:prosp2.CI_Identificacion__c];
                   
                   /* opportunity opor1 = new opportunity();
                    opor1.name='LULU NENA PLAZA LAGOS';
                    opor1.AccountId=cuenta.id;
                    opor1.closedate=system.today();
                    opor1.stagename='Vendida';
                    opor1.OwnerId = u.Id;
                    insert opor1; */
             
                    Prospecto_Web__c pw1=new Prospecto_Web__c();  
                    pw1.Identificacion__c=prosp2.CI_Identificacion__c;
             		pw1.Procesado__c=false;
                    pw1.Prospecto__c	= prosp2.id;
                    pw1.Proyecto__c =  proy2.id;
                    insert pw1;
             
                   
             
             
                    ProcesarFormularioWeb.ProcesarWeb();
                    
             
             
                   

         }
     }
    @isTest static void GeneralesVilla5() {
  
            
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
             
                  Empresa__c emp = new Empresa__c(); 
                        emp.Name='MEISTERBLUE CIA. LTDA.';
                        insert emp;
        
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo',Empresa__c=emp.id);
    
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                           
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Proyecto__c=proy.id;
                    prosp2.OwnerId = u1.Id;
                    insert prosp2;

              prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123489@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Proyecto__c=proy.id;
                    prosp.OwnerId = u.Id;
                    prosp.status='New';
                    insert prosp;
                 
                               

                  
                        
                /*    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c];
             
                    opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor; 
             
              */
                  // CrearTarea.Nuevatarea(prosp.id,cuenta.id,'I');     

         }
     }

  @isTest static void GeneralesVilla4() {
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
    
            
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
             
                  Empresa__c emp = new Empresa__c(); 
                        emp.Name='MEISTERBLUE CIA. LTDA.';
                        insert emp;
        
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo',Empresa__c=emp.id);
    
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'OFICINA';
                    prosp2.CI_Proyecto__c=proy.id;
                    insert prosp2;
             

                               

                    prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0126789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '1303633158';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'OFICINA';
                    prosp.CI_Proyecto__c=proy.id;
                    insert prosp;
                        
           
         }
     }
}