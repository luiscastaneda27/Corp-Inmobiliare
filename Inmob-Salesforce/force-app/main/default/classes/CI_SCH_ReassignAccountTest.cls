@isTest
public class CI_SCH_ReassignAccountTest {
	static testMethod void myTestMethod() {  
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        System.debug('accountRecordTypeId: '+accountRecordTypeId);
                    
        //Insert Proyect
        Proyecto__c pro = new Proyecto__c(Name = 'LA RIOJA',CI_Estado__c = 'Activo',Codigo_Proyecto__c = '7001');
        Insert pro;
                   
        //Insert Account
        Account acc = new Account(LastName = 'Test', RecordTypeId = accountRecordTypeId, CI_Proyecto__c=pro.Id);
        Insert acc; 
        System.debug('Acc: '+acc);
        
        Map<String, Account> lstAccount = new Map<String, Account>(); 
        lstAccount.put(acc.Id, acc);
        
        test.starttest();
            CI_SCH_ReassignAccount myClass = new CI_SCH_ReassignAccount(lstAccount);   
        test.stopTest();
    }       
}