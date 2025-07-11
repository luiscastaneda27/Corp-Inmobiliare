@isTest
public class processEventLeadHelperTest {
    
    public static User createUser() {
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
        
        return uM;
    }
    
    @isTest static void execute() {
        
        User us = processEventLeadHelperTest.createUser();
        
        System.runAs(us) { 
        
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
        
    	Event_Lead__e inkEvent = new Event_Lead__e(CI_LeadId__c=ld.Id, CI_New_Owner__c=us.Id);    
        
        Test.startTest();
        
        database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(ld.id);
                
        leadStatus convertStatus = [SELECT Id, ApiName, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.ApiName);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(inkEvent);
            
        Test.stopTest();
            
        }
    }
    
    @isTest static void execute2() {
        
        User us = processEventLeadHelperTest.createUser();
        
        System.runAs(us) { 
        
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
        
    	Event_Lead__e inkEvent = new Event_Lead__e(CI_LeadId__c=ld.Id, CI_New_Owner__c=us.Id, CI_Update_Lead__c = true);    
        
        Test.startTest();
        
        database.leadConvert lc = new database.leadConvert();
        lc.setLeadId(ld.id);
                
        leadStatus convertStatus = [SELECT Id, ApiName, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.ApiName);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        // Publish test event
        Database.SaveResult sr = EventBus.publish(inkEvent);
            
        Test.stopTest();
            
        }
    }

}