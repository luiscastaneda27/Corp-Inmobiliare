@IsTest
public class CI_LeadTrigger_Test {
	@isTest static void createLead() {
        try {
            Test.startTest();
                Lead lead = UT_DataFactory.createLead('1712577301', true);
            Test.stopTest();
            User user = UT_DataFactory.createUserAdviser();
            lead.OwnerId = user.Id;
            update lead;
        } catch(System.DmlException ex) {
          	System.debug('Error en createLead: '+ex.getLineNumber() + '---' + ex.getMessage());    
        }     
    }
    
    @isTest static void createDuplicates() {
        Test.startTest();
            try {
            	Lead ld = UT_DataFactory.createLead('1712577301', true);
            	Lead ld2 = UT_DataFactory.createLeadDuplicate();    
            } catch(System.DmlException ex) {
                System.debug('Error en createDuplicates: '+ex.getLineNumber() + '---' + ex.getMessage());  
            }
        Test.stopTest();
    }
    
    @isTest static void updateLead() {       
    	try {
        	Test.startTest();
            	Lead ld = UT_DataFactory.updateLead();
            Test.stopTest();
        } catch(System.DmlException ex) {
          	System.debug('Error en updateLead: '+ex.getLineNumber() + '---' + ex.getMessage());    
        }       
    }
    
    @isTest static void createLeadError() {
        try {
            Test.startTest();
                Lead cont = UT_DataFactory.createLead('1712-', true);
            Test.stopTest(); 
        } catch(System.DmlException ex) {
          	System.debug('Error en createLeadError: '+ex.getLineNumber() + '---' + ex.getMessage());    
        }     
    }
}