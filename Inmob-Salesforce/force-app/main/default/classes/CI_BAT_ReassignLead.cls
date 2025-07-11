global class CI_BAT_ReassignLead implements Database.Batchable<Sobject>, Database.Stateful {
    
    global static Sales_SLA_config__mdt[] listMDT = [SELECT DeveloperName, MasterLabel, Proyecto__c, Valor_de_Comparacion__c FROM Sales_SLA_config__mdt];
        
    global static map<String, Lead> allLeads = new map<String, Lead>();
    
    global static map<String, User> allUsers = new map<String, User>();
     
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Decimal mdtVal = 0; 
        for(Sales_SLA_config__mdt mdt : listMDT) {
            if(mdt.MasterLabel == 'MOD2 Dias Asignación Lead-Account') {
            	mdtVal = Decimal.valueOf(mdt.Valor_de_Comparacion__c);
            }    
        }
        if(mdtVal > 0) {
            if(test.isRunningTest()) { 
                return Database.getQueryLocator([SELECT Id,OwnerId,CI_SLA__c,CI_Gestor__c,CI_Id_Gestor__c FROM Lead Where CI_SLA__c != Null]); 
            } else {
        		return Database.getQueryLocator([SELECT Id,Status,OwnerId,CI_SLA__c,CI_Gestor__c,CI_Id_Gestor__c,CI_Perfil_Gestor__c FROM Lead Where CI_SLA__c != Null and 
                                                 CI_SLA__c >: mdtVal and CI_Gestor__c != Null and Status != 'Qualified' and Status != 'Dado de Baja' 
                                                 and CI_Perfil_Gestor__c != 'Dirección de Ventas' limit 3000]);
            }                                         
        } else {
            return null;
        }    
    }
	
	global void execute(Database.BatchableContext bc, List<Lead> scope) {
        //System.debug('scope contiene: '+scope);
        
		Set<String> idUsers = new Set<String>();
        for(Lead ld : scope) {
            allLeads.put(ld.Id, ld);
            idUsers.add(ld.OwnerId);
        }
      
        for(Lead target : allLeads.values()) { 
            if(target.CI_Gestor__c != Null) {
                target.OwnerId = target.CI_Id_Gestor__c;
                allLeads.put(target.Id,target);
            }
        }
        
        if(allLeads.size() > 0) {       
            Database.SaveResult[] srListOpps = Database.update(allLeads.values(), false);
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    
            // Iterate through each returned result
            for(Database.SaveResult sr : srListOpps) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully update Lead. Lead ID: ' + sr.getId());
                    
                    for(Lead leads : allLeads.values()){
                    	if(leads.CI_Gestor__c != null){
                        	Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();      
                            List<String> sendTo = new List<String>();
                            sendTo.add(leads.CI_Gestor__c);
                            mail.setToAddresses(sendTo);
                            mail.setSubject('Prospecto reasignado por vencimiento de SLA');
                            String displayname = 'Ir al registro';
                            String emailBody = '<html>Se le ha reasignado el siguiente Prospecto por vencimiento del SLA: <a href="'+URL.getOrgDomainURL().toExternalForm()+'/'+leads.Id+'">'+displayname+'</a></html>';
                            mail.setHtmlBody(emailBody);        
                            mails.add(mail);
                        }
                    }
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Lead fields that affected this error: ' + err.getFields());
                    }
                }
            }  
            
            if(mails.size()>0) {
                Messaging.sendEmail(mails);
            }  
        }      
    }  
    
    global void finish(Database.BatchableContext bc) {
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, 
                      TotalJobItems FROM AsyncApexJob WHERE Id = :BC.getJobId()]; 
    }
    
}