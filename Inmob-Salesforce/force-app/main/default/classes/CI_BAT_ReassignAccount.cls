global class CI_BAT_ReassignAccount implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    global static Sales_SLA_config__mdt[] listMDT = [SELECT DeveloperName, MasterLabel, Proyecto__c, Valor_de_Comparacion__c FROM Sales_SLA_config__mdt Where DeveloperName = 'MOD2_Dias_Asignacion_Lead_Account'];
        
    global List<String> accsNewList = new List<String>();
    
    public CI_BAT_ReassignAccount(List<Account> lstAccs){
        //System.debug('Las cuentas son: '+lstAccs);
        for(Account acc : lstAccs){
        	accsNewList.add(acc.Id);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        //System.debug('Los valores de la lista: '+accsNewList);
        return Database.getQueryLocator([SELECT Id, OwnerId, Owner.Name, Owner.ManagerId, Owner.Manager.Name, CI_SLA_Total__c FROM Account Where Id IN : accsNewList]);
    }
	
	global void execute(Database.BatchableContext bc, List<Account> scope) {
        //System.debug('scope: '+scope.size());
        //System.debug('scope: '+scope);
    	map<String, Account> allValues = new map<String, Account>();
        for(Account acc : scope) {   
        	allValues.put(acc.Id, acc);
        }
        for(String Key : allValues.keySet()) {   
            allValues.get(Key).OwnerId = allValues.get(Key).Owner.ManagerId;
        }
        
        Database.SaveResult[] srListOpps = Database.update(allValues.values(), false);
    
        // Iterate through each returned result
        for(Database.SaveResult sr : srListOpps) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully update account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
  }  
    
  global void finish(Database.BatchableContext bc) { 
  	AsyncApexJob asyncJob = [SELECT ID,Status,NumberOfErrors FROM 
                                 AsyncApexJob WHERE ID =:bc.getJobId()];
  }
    
}