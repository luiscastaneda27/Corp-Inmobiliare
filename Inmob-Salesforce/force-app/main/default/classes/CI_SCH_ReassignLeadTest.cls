@isTest
public class CI_SCH_ReassignLeadTest {
	static testMethod void myTestMethod() {        
         test.starttest();
             CI_SCH_ReassignLead myClass = new CI_SCH_ReassignLead();   
             String chron = '0 0 23 * * ?';        
             system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}