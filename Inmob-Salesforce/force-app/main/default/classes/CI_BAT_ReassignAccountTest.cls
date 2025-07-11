@isTest 
public class CI_BAT_ReassignAccountTest {
    
    public static User createUser() {
        Profile profile1 = [Select Id from Profile where name = 'Admin User' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser0 = new User(  firstname = 'Test',
                              lastName = 'Test',
                              email = 'josue.blandon@intellectsystem.net',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser0;
        
        User tuser = new User(  firstname = 'Test',
                              lastName = 'Test',
                              email = 'josue.blandon123@intellectsystem.net',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ManagerId = tuser0.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }  
          
    public static testMethod void executeTest() {
        Account acc = new Account();
        
        try{

            User u1 = CI_BAT_ReassignLeadTest.createUser();
            
            System.runas(u1) {    
                
            	Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
                System.debug('accountRecordTypeId: '+accountRecordTypeId);
                    
                //Insert Proyect
                Proyecto__c pro = new Proyecto__c(Name = 'LA RIOJA',CI_Estado__c = 'Activo',Codigo_Proyecto__c = '7001');
                Insert pro;
                    
                //Insert Account
                acc = new Account(LastName = 'Test', RecordTypeId = accountRecordTypeId, CI_Proyecto__c=pro.Id);
                Insert acc; 
                System.debug('Acc: '+acc);
                                
            }
            
        } catch(Exception ex) {
            System.debug('Error: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
        
        Test.startTest();

            list<Account> lstAccount = new list<Account>(); 
            lstAccount.add(acc);
            Database.executeBatch(new CI_BAT_ReassignAccount(lstAccount));
            
        Test.stopTest();
    }
}