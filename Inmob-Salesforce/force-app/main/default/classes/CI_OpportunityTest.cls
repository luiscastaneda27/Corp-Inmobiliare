@IsTest
public class CI_OpportunityTest {
    @isTest static void execute() {
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
        
        User uM2 = new User();
        uM2.Firstname = 'Juan';
        uM2.LastName = 'Pérez';
        uM2.email = 'juanperez@outlook.com';
        uM2.Alias = 'alias3';
        uM2.CommunityNickname = 'commnick4';
        uM2.EmailEncodingKey = 'UTF-8';
        uM2.Username = 'juanperez@outlook.com';
        uM2.TimeZoneSidKey = 'America/Denver';
        uM2.LocaleSidKey = 'en_US';
        uM2.EmailEncodingKey = 'UTF-8';
        uM2.LanguageLocaleKey = 'en_US';
        uM2.isActive =true;
        uM2.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        uM2.UserRoleId = rManager.Id;
        insert uM2;
        
        test.startTest();
        
        System.runAs ( uM ) {
            Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            System.debug('accountRecordTypeId: '+accountRecordTypeId);
            
            //Insert Proyect
            Proyecto__c pro = new Proyecto__c(Name = 'LA RIOJA',CI_Estado__c = 'Activo',Codigo_Proyecto__c = '7001');
            Insert pro;
            
            //Insert Account
            Account acc = new Account(LastName = 'Test', RecordTypeId = accountRecordTypeId, CI_Proyecto__c=pro.Id);
            Insert acc; 
            System.debug('Acc: '+acc);
            
            opportunity opor = new opportunity();
            opor.name='LULU NENA PLAZA LAGOS';
            opor.AccountId=acc.id;
            opor.closedate=system.today();
            opor.stagename='Probable';
            opor.OwnerId = uM.Id;
            insert opor; 
            
            opor.OwnerId = uM2.Id;
            Update opor;
            
            //Insert Opportunity
        }
        
        test.stopTest();
    }	
}