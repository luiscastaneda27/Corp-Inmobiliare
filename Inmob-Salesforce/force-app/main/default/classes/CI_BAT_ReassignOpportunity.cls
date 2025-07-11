global class CI_BAT_ReassignOpportunity implements Database.Batchable<Sobject>, Database.Stateful {
    
    global Sales_SLA_config__mdt[] listMDT = [SELECT DeveloperName, MasterLabel, Proyecto__c, Valor_de_Comparacion__c FROM Sales_SLA_config__mdt];
        
    global map<String, Opportunity> allOpps = new map<String, Opportunity>();
    
    global map<String, Account> lstAccs = new map<String, Account>();
     
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Decimal mdtVal = 0; 
        for(Sales_SLA_config__mdt mdt : listMDT) {
            if(mdt.MasterLabel == 'MOD2 Dias Asignación Lead-Account') {
            	mdtVal = Decimal.valueOf(mdt.Valor_de_Comparacion__c);
            }    
        }
        if(mdtVal > 0) {
            if(test.isRunningTest()) {
            	return Database.getQueryLocator([Select Id, Name, OwnerId, Owner.Name, Owner.Manager.Id, Owner.Manager.Name, Owner.Manager.Email, 
                                             Owner.Email, Account.Id, Account.Owner.Id, Account.Owner.Name, Account.Owner.Manager.Email, CI_Gestor__c
                                             from Opportunity]);
            } else {   
            	return Database.getQueryLocator([Select Id, Name, OwnerId, Owner.Name, Owner.Manager.Id, Owner.Manager.Name, Owner.Manager.Email, 
                                             Owner.Email, Account.Id, Account.Owner.Id, Account.Owner.Name, Account.Owner.Manager.Email, Account.CI_Estado_cuenta__c,
                                             CI_Gestor__c from Opportunity where CI_SLA_Total_Oportunidad__c >: mdtVal and Owner.ManagerId != Null and 
                                             Account.CI_Estado_cuenta__c != 'Dado de Baja' and 
                                             (StageName != 'Vendida' or StageName != 'No negociada') limit 1000]);
            }    
        } else {
            return null;
        }    
    }
	
	global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        System.debug('Los registros son: '+scope);
        try {
            for(Opportunity opp : scope) {
            	lstAccs.put(opp.Account.Id,opp.Account);
                opp.OwnerId = opp.Owner.Manager.Id;	
                allOpps.put(opp.Id,opp);
            }
                       
            ID jobID = System.enqueueJob(new CI_SCH_ReassignAccount(lstAccs));
            
            System.debug('Las allOpps son: '+allOpps);
            
            if(allOpps.size() > 0) {
                for(String Key : allOpps.keySet()) {   
                    allOpps.get(Key).OwnerId = allOpps.get(Key).Owner.ManagerId; 
                }
            
                Database.SaveResult[] srListOpps = Database.update(allOpps.values(), false);
                                     
                // Iterate through each returned result
                for(Database.SaveResult sr : srListOpps) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully update opportunity. Opportunity ID: ' + sr.getId());    
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Opportunity fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('Error en el Batch: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }  
    
    global void finish(Database.BatchableContext bc) { 
    	
        Messaging.SingleEmailMessage mailToSend = new Messaging.SingleEmailMessage();
        
        List<OrgWideEmailAddress> lstOrgWideEmailAdd = new List<OrgWideEmailAddress>();
        lstOrgWideEmailAdd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'procesos.automaticos@inmobiliare.com.ec'];
        
        List<Messaging.SingleEmailMessage> listEmails = new List<Messaging.SingleEmailMessage>();
        
        for(Opportunity target : allOpps.values()) {
        	//System.debug('Valores: '+target.Name+'--'+target.Owner.Name+'---'+target.Owner.Manager.Email);
            String[] toAddresses = new String[] {target.Owner.Manager.Email};
            mailToSend.setToAddresses(toAddresses);
            mailToSend.setOrgWideEmailAddressId(lstOrgWideEmailAdd[0].Id);
            mailToSend.setSubject('Oportunidad para dar de baja');
            String displayname = 'Ir al registro';
            String emailBody = '<html>Se le ha reasignado la siguiente oportunidad por vencimiento del SLA: <a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+target.Id+'">'+displayname+'</a></html>';
            mailToSend.setHtmlBody(emailBody); 
            if(target.CI_Gestor__c != Null) {
            	listEmails.add(mailToSend);
            }    
        }
        
        if(!listEmails.isEmpty()){
        	Messaging.sendEmail(listEmails);
        }
    }   
}