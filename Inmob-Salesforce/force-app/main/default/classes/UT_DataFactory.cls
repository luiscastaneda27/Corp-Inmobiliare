public class UT_DataFactory {
	public static User createUser() {
        Profile profile1 = [Select Id from Profile where name = 'System Administrator' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test01',
                              lastName = 'Test01',
                              email = uniqueName + '@test01' + orgId + '.org',
                              Username = uniqueName + '@test01' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
  
        return tuser;
    }
    
    public static User createUserAdviser() {
        Profile profile1 = [Select Id from Profile where name = 'Asesor de Ventas'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test02',
                              lastName = 'Test02',
                              email = uniqueName + '@test02' + orgId + '.org',
                              Username = uniqueName + '@test02' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;

        return tuser;
    }
    
    public static Proyecto__c createProject() {
        User us = UT_DataFactory.createUser();
        Proyecto__c pro; 
        System.runAs(us) { 
        	pro = new Proyecto__c();
            pro.Name = 'LA RIOJA';
            pro.CI_Estado__c = 'Activo';
            pro.Codigo_Proyecto__c = '7001';
            insert pro;
        }    
        return pro;   
    }
    
    public static Lead createLead(String identity, Boolean doInsert) {
        User us = UT_DataFactory.createUser();
        Proyecto__c pro = UT_DataFactory.createProject();
        Lead ld; 
        System.runAs(us) { 
        	ld = new Lead(FirstName = 'Test', LastName = 'Lead', Email = 'test001@gmail.com', OwnerId = us.Id,
                          RecordTypeId = Lead.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('CI_Prospecto_principal').getRecordTypeId(), 
                          CI_Proyecto__c = pro.Id, CI_Cod_Proyecto__c = 'VILLA ITALIA', Company = 'Test Company', CI_Personeria__c = '1', 
                          CI_Tipo_Iden__c = '2', CI_Identificacion__c = identity, CI_Medio_Contacto__c = 'EMAIL', CI_Origen__c = 'OBRA');
            if(doInsert) {
            	Insert ld;
            }    
        }    
        return ld;   
    }
    
    public static Lead updateLead() {
        User us = UT_DataFactory.createUser();
        Proyecto__c pro = UT_DataFactory.createProject();
        
        Lead ld; 
        ld = new Lead(FirstName = 'Test', LastName = 'Lead', Email = 'test001@gmail.com', OwnerId = us.Id,
                          RecordTypeId = Lead.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('CI_Prospecto_principal').getRecordTypeId(), 
                          CI_Proyecto__c = pro.Id, CI_Cod_Proyecto__c = 'VILLA ITALIA', Company = 'Test Company', CI_Personeria__c = '1', 
                          CI_Tipo_Iden__c = '2', CI_Identificacion__c = '1712577301', CI_Medio_Contacto__c = 'EMAIL', CI_Origen__c = 'OBRA');
        insert ld;
        
        ld.State = 'Qualified';
        User user = UT_DataFactory.createUserAdviser();
        ld.OwnerId = user.Id;
        update ld;
        
        return ld;   
    }
    
    public static Lead createLeadDuplicate() {
        User us = UT_DataFactory.createUser();
        Proyecto__c pro = UT_DataFactory.createProject();
        Lead ld; 
        System.runAs(us) { 
        	ld = new Lead(FirstName = 'Test', LastName = 'Lead', Email = 'test001@gmail.com', OwnerId = us.Id, 
                          RecordTypeId = Lead.SobjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('CI_Prospecto_principal').getRecordTypeId(), 
                          CI_Cod_Proyecto__c = 'LA RIOJA', Company = 'Test Company', CI_Personeria__c = '1', CI_Tipo_Iden__c = '2', 
                          CI_Identificacion__c = '1712577301', CI_Medio_Contacto__c = 'EMAIL', CI_Origen__c = 'OBRA');
        	Insert ld;
        }    
        return ld;   
    }
}