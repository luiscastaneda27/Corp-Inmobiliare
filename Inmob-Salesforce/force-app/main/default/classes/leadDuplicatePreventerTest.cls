@IsTest
public class leadDuplicatePreventerTest {
    
    @isTest static void execute0() {
        
        //try {
            
        UserRole rManager = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User uM = new User();
        uM.Firstname = 'Ivan';
        uM.LastName = 'Hernández';
        uM.email = 'ihernan@outlook.com';
        uM.Alias = 'alias3';
        uM.CommunityNickname = 'commnick3';
        uM.EmailEncodingKey = 'UTF-8';
        uM.Username = 'ihernan123@outlook.com';
        uM.TimeZoneSidKey = 'America/Denver';
        uM.LocaleSidKey = 'en_US';
        uM.EmailEncodingKey = 'UTF-8';
        uM.LanguageLocaleKey = 'en_US';
        uM.isActive =true;
        uM.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        uM.UserRoleId = rManager.Id;
        insert uM;
      
    	UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User u = new User();
        u.Firstname = 'B2BMA';
        u.LastName = 'Integration';
        u.email = 'b2bma@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'b2bma@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        u.UserRoleId = r.Id;
        insert u; 
                
        test.startTest();
        
        System.runAs ( u ) { 
            
            Asignacion_Web_to_Lead__c assign = new Asignacion_Web_to_Lead__c();
            assign.CI_Usuario__c = UM.Id;
            assign.CI_Cantidad_LA__c = 0;
            Insert assign;
            
            Proyecto__c pro = new Proyecto__c();
            pro.Name = 'LA RIOJA';
            pro.CI_Estado__c = 'Activo';
            pro.Codigo_Proyecto__c = '7001';
            insert pro;
            
            RecordType tipoRegistro=[select id,name from RecordType where Name =: 'Prospecto principal'];
            
       		Lead ld = new Lead();
            ld.RecordTypeId = tipoRegistro.Id;
            ld.FirstName = 'Test';
            ld.LastName = '001';
            ld.State = 'New';
            ld.CI_Tipo_Iden__c = '2';
            ld.CI_Personeria__c = '1';
            ld.CI_Identificacion__c = '1703841450';
            ld.Email = 'test002@gmail.com';
            ld.CI_Proyecto__c = pro.Id;
            ld.CI_Medio_Contacto__c = 'EMAIL';
            ld.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld.CI_Origen__c = 'OBRA';
            Insert ld;
            
            Event_Lead__e inkEvent = new Event_Lead__e(CI_LeadId__c=ld.Id, CI_New_Owner__c=uM.Id, CI_Proyect__c = pro.Id, CI_Update_Lead__c = true);
            
            Database.SaveResult sr = EventBus.publish(inkEvent);
            
            database.leadConvert lc = new database.leadConvert();
            lc.setLeadId(ld.id);
                    
            leadStatus convertStatus = [SELECT Id, ApiName, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc.setConvertedStatus(convertStatus.ApiName);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
        }
        
        Test.stopTest();
        
        /*} catch(System.DmlException ex) {
        	System.debug('Error en leadDuplicatePreventer class: '+ex.getLineNumber()+'---'+ex.getMessage());
        }*/
    }

    
	@isTest static void execute() {
        
        try {
            
        UserRole rManager = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User uM = new User();
        uM.Firstname = 'Ivan';
        uM.LastName = 'Hernández';
        uM.email = 'ihernan@outlook.com';
        uM.Alias = 'alias3';
        uM.CommunityNickname = 'commnick3';
        uM.EmailEncodingKey = 'UTF-8';
        uM.Username = 'ihernan123@outlook.com';
        uM.TimeZoneSidKey = 'America/Denver';
        uM.LocaleSidKey = 'en_US';
        uM.EmailEncodingKey = 'UTF-8';
        uM.LanguageLocaleKey = 'en_US';
        uM.isActive =true;
        uM.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        uM.UserRoleId = rManager.Id;
        insert uM;
      
    	UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User u = new User();
        u.Firstname = 'B2BMA';
        u.LastName = 'Integration';
        u.email = 'b2bma@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'b2bma@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        u.UserRoleId = r.Id;
        insert u; 
                
        test.startTest();
        
        System.runAs ( u ) { 
            
            Asignacion_Web_to_Lead__c assign = new Asignacion_Web_to_Lead__c();
            assign.CI_Usuario__c = UM.Id;
            assign.CI_Cantidad_LA__c = 0;
            Insert assign;
            
            Proyecto__c pro = new Proyecto__c();
            pro.Name = 'LA RIOJA';
            pro.CI_Estado__c = 'Activo';
            pro.Codigo_Proyecto__c = '7001';
            insert pro;
            
            RecordType tipoRegistro=[select id,name from RecordType where Name =: 'Prospecto principal'];
            
       		Lead ld = new Lead();
            ld.RecordTypeId = tipoRegistro.Id;
            ld.FirstName = 'Test';
            ld.LastName = '001';
            ld.State = 'New';
            ld.CI_Tipo_Iden__c = '3';
            ld.CI_Personeria__c = '1';
            ld.CI_Identificacion__c = '0100194281091';
            ld.Email = 'test002@gmail.com';
            ld.CI_Proyecto__c = pro.Id;
            ld.CI_Medio_Contacto__c = 'EMAIL';
            ld.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld.CI_Origen__c = 'OBRA';
            Insert ld;
            
            Lead ld3 = new Lead();
            ld3.RecordTypeId = tipoRegistro.Id;
            ld3.FirstName = 'Test';
            ld3.LastName = '001';
            ld3.State = 'New';
            ld3.CI_Tipo_Iden__c = '3';
            ld3.CI_Personeria__c = '1';
            ld3.CI_Identificacion__c = '0100194281091';
            ld3.Email = 'test002@gmail.com';
            ld3.CI_Proyecto__c = pro.Id;
            ld3.CI_Medio_Contacto__c = 'EMAIL';
            ld3.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld3.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld3.CI_Origen__c = 'OBRA';
            Insert ld3;
        }
        
        } catch(System.DmlException ex) {
        	System.debug('Error en leadDuplicatePreventer class: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }
    
    @isTest static void execute2() {
        
        try {
            
        UserRole rManager = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User uM = new User();
        uM.Firstname = 'Ivan';
        uM.LastName = 'Hernández';
        uM.email = 'ihernan@outlook.com';
        uM.Alias = 'alias3';
        uM.CommunityNickname = 'commnick3';
        uM.EmailEncodingKey = 'UTF-8';
        uM.Username = 'ihernan123@outlook.com';
        uM.TimeZoneSidKey = 'America/Denver';
        uM.LocaleSidKey = 'en_US';
        uM.EmailEncodingKey = 'UTF-8';
        uM.LanguageLocaleKey = 'en_US';
        uM.isActive =true;
        uM.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        uM.UserRoleId = rManager.Id;
        insert uM;
      
    	UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User u = new User();
        u.Firstname = 'Juan';
        u.LastName = 'Pérez';
        u.email = 'b2bma@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'b2bma@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        u.UserRoleId = r.Id;
        insert u; 
                
        test.startTest();
        
        System.runAs ( u ) { 
            
            Asignacion_Web_to_Lead__c assign = new Asignacion_Web_to_Lead__c();
            assign.CI_Usuario__c = UM.Id;
            assign.CI_Cantidad_LA__c = 0;
            Insert assign;
            
            Proyecto__c pro = new Proyecto__c();
            pro.Name = 'LA RIOJA';
            pro.CI_Estado__c = 'Activo';
            pro.Codigo_Proyecto__c = '7001';
            insert pro;
            
            RecordType tipoRegistro=[select id,name from RecordType where Name =: 'Prospecto principal'];
            
       		Lead ld = new Lead();
            ld.RecordTypeId = tipoRegistro.Id;
            ld.FirstName = 'Test';
            ld.LastName = '001';
            ld.State = 'New';
            ld.CI_Tipo_Iden__c = '3';
            ld.CI_Personeria__c = '1';
            ld.CI_Identificacion__c = '0100194281091';
            ld.Email = 'test002@gmail.com';
            ld.CI_Proyecto__c = pro.Id;
            ld.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld.CI_Medio_Contacto__c = 'EMAIL';
            ld.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld.CI_Origen__c = 'OBRA';
            Insert ld;
            
            Lead ld3 = new Lead();
            ld3.RecordTypeId = tipoRegistro.Id;
            ld3.FirstName = 'Test';
            ld3.LastName = '001';
            ld3.State = 'New';
            ld3.CI_Tipo_Iden__c = '3';
            ld3.CI_Personeria__c = '1';
            ld3.CI_Identificacion__c = '0100194281091';
            ld3.Email = 'test002@gmail.com';
            ld3.CI_Proyecto__c = pro.Id;
            ld3.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld3.CI_Medio_Contacto__c = 'EMAIL';
            ld3.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld3.CI_Origen__c = 'OBRA';
            Insert ld3;
        }
        
        } catch(System.DmlException ex) {
        	System.debug('Error en leadDuplicatePreventer class: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }
    
    @isTest static void execute3() {
        
        try {
            
        UserRole rManager = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User uM = new User();
        uM.Firstname = 'Ivan';
        uM.LastName = 'Hernández';
        uM.email = 'ihernan@outlook.com';
        uM.Alias = 'alias3';
        uM.CommunityNickname = 'commnick3';
        uM.EmailEncodingKey = 'UTF-8';
        uM.Username = 'ihernan123@outlook.com';
        uM.TimeZoneSidKey = 'America/Denver';
        uM.LocaleSidKey = 'en_US';
        uM.EmailEncodingKey = 'UTF-8';
        uM.LanguageLocaleKey = 'en_US';
        uM.isActive =true;
        uM.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        uM.UserRoleId = rManager.Id;
        insert uM;
      
    	UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
        
        User u = new User();
        u.Firstname = 'Juan';
        u.LastName = 'Pérez';
        u.email = 'b2bma@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'b2bma@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        u.UserRoleId = r.Id;
        insert u; 
                
        test.startTest();
        
        System.runAs ( u ) { 
            
            Asignacion_Web_to_Lead__c assign = new Asignacion_Web_to_Lead__c();
            assign.CI_Usuario__c = UM.Id;
            assign.CI_Cantidad_LA__c = 0;
            Insert assign;
            
            Proyecto__c pro = new Proyecto__c();
            pro.Name = 'LA RIOJA';
            pro.CI_Estado__c = 'Activo';
            pro.Codigo_Proyecto__c = '7001';
            insert pro;
            
            Proyecto__c pro2 = new Proyecto__c();
            pro2.Name = 'VILLA ITALIA';
            pro2.CI_Estado__c = 'Activo';
            pro2.Codigo_Proyecto__c = '9001';
            insert pro2;
            
            RecordType tipoRegistro=[select id,name from RecordType where Name =: 'Prospecto principal'];
            
       		Lead ld = new Lead();
            ld.RecordTypeId = tipoRegistro.Id;
            ld.FirstName = 'Test';
            ld.LastName = '001';
            ld.State = 'New';
            ld.CI_Tipo_Iden__c = '3';
            ld.CI_Personeria__c = '1';
            ld.CI_Identificacion__c = '0100194281091';
            ld.Email = 'test002@gmail.com';
            ld.CI_Proyecto__c = pro.Id;
            ld.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld.CI_Medio_Contacto__c = 'EMAIL';
            ld.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld.CI_Origen__c = 'OBRA';
            Insert ld;
            
            Lead ld3 = new Lead();
            ld3.RecordTypeId = tipoRegistro.Id;
            ld3.FirstName = 'Test';
            ld3.LastName = '001';
            ld3.State = 'New';
            ld3.CI_Tipo_Iden__c = '3';
            ld3.CI_Personeria__c = '1';
            ld3.CI_Identificacion__c = '0100194281091';
            ld3.Email = 'test002@gmail.com';
            ld3.CI_Proyecto__c = pro2.Id;
            ld3.CI_Cod_Proyecto__c = 'LA RIOJA';
            ld3.CI_Medio_Contacto__c = 'EMAIL';
            ld3.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
            ld3.CI_Origen__c = 'OBRA';
            Insert ld3;
        }
        
        } catch(System.DmlException ex) {
        	System.debug('Error en leadDuplicatePreventer class: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }
}