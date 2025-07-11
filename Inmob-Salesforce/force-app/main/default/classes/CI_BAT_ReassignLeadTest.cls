@isTest 
public class CI_BAT_ReassignLeadTest {
    
    public static User createUserManager() {
        Profile profile1 = [Select Id from Profile where name = 'Admin User' or name = 'Administrador del Sistema'];
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
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
    
    public static User createUser() {
        User um = CI_BAT_ReassignLeadTest.createUserManager();
        
        Profile profile1 = [Select Id from Profile where name = 'Admin User' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test',
                              lastName = 'Test',
                              email = uniqueName + '@test' + orgId + '.org',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ManagerId = um.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
          
    public static testMethod void executeTest() {
        
        try{

            User u1 = CI_BAT_ReassignLeadTest.createUser();
            
            System.runas(u1) {    
                
            	Asignacion_Web_to_Lead__c assign = new Asignacion_Web_to_Lead__c();
                assign.CI_Usuario__c = u1.Id;
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
            
            }
            
        } catch(Exception ex) {
            System.debug('Error: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
        
        Test.startTest();

            CI_BAT_ReassignLead obj = new CI_BAT_ReassignLead();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}