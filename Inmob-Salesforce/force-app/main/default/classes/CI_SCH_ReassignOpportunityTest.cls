@isTest
public class CI_SCH_ReassignOpportunityTest {
	static testMethod void myTestMethod() {        
         test.starttest();
             CI_SCH_ReassignOpportunity myClass = new CI_SCH_ReassignOpportunity();   
             String chron = '0 0 23 * * ?';        
             system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}