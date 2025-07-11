public without sharing class CI_OpportunityHelper {
    
    public static List<Opportunity> listOpps = new List<Opportunity>();
    
    public static map<String, Opportunity> mapOpps = new map<String, Opportunity>();
    
    public static List<Permiso_a_Cuenta__c> listPermissions = new List<Permiso_a_Cuenta__c>();
    
    public static List<Permiso_a_Cuenta__c> updatePermissions = new List<Permiso_a_Cuenta__c>();
    
    public static Boolean isFirstTime = true;
    
    public static void validateOpenOpportunities(List<Opportunity> opps) {
        set<Id> idAcc = new set<Id>();
        for(Opportunity op : opps) {
        	idAcc.add(op.AccountId);     
        }
        
        List<Opportunity> listUpdate = new List<Opportunity>();
        List<Opportunity> listValDup = [SELECT Id,Name,CI_Proyecto__c,StageName From Opportunity Where AccountId In: idAcc];
        List<Validate_Duplicates__mdt> mdtValDup = [SELECT CI_Proyecto__c,CI_Etapa__c,CI_Activo__c FROM Validate_Duplicates__mdt];
        
        for(Opportunity op : listValDup) {
        	for(Validate_Duplicates__mdt mdt : mdtValDup) {
                if(op.CI_Proyecto__c == mdt.CI_Proyecto__c && op.StageName == mdt.CI_Etapa__c && mdt.CI_Activo__c == true) {
                    for(Opportunity ops : opps) {
                        if(ops.CI_Proyecto__c == op.CI_Proyecto__c) { 
                            op.CI_Duplicate__c = true;
                            op.Name = op.Name + ' Duplicada';
                            listUpdate.add(op);
                    		//ops.addError('Ya existe una oportunidad abierta para este cliente.');   
                        }                             
                    }               	   
                }
            }
        }
        
        if(!listUpdate.isEmpty()) {
        	Update listUpdate;    
        }
    }
    
	public static void createPermissiontoAccount(List<Opportunity> opps) {
        //Insertando registros en Permiso a Cuenta  
        boolean edicion = false; 
        for(Opportunity op : opps) {
			if(op.StageName == 'Probable' || op.StageName == 'Negociando') { 
                edicion = true; 
            }             
        }
        for(Opportunity op : opps) {
            listPermissions.add(new Permiso_a_Cuenta__c(CI_Cuenta__c = op.AccountId, CI_Proyecto__c = op.CI_Proyecto__c, CI_Oportunidad__c = op.Id, CI_Propietario__c = op.OwnerId, CI_Permite_Edicion__c = edicion));    
        }
        if(!listPermissions.isEmpty()) {
            insert listPermissions;
        }
    }
    
    public static void modifyPermissiontoAccount(List<Opportunity> opps, Map<Id, Opportunity> mapOldOpps) {
        //Actualizando registros en Permiso a Cuenta
        set<Id> idOp = new set<Id>();
        for(Opportunity op : opps) {
            if(op.OwnerId != mapOldOpps.get(op.Id).OwnerId) {
                idOp.add(op.id);
            }    
        }
        
        listPermissions = [SELECT Id, CI_Oportunidad__c, CI_Propietario__c FROM Permiso_a_Cuenta__c WHERE CI_Oportunidad__c In: idOp];

        for(Opportunity op : opps) {
            for(Permiso_a_Cuenta__c pc : listPermissions) {
            	pc.CI_Propietario__c = op.OwnerId;  
                updatePermissions.add(pc);
            }  
        }
        
        if(!updatePermissions.isEmpty()) {
            update listPermissions;
        }
        
    }
    
    //Assign value Gestor field to Email Gestor field
    public static void assignGestor(List<Opportunity> opps) {
    	for (Opportunity obj : opps){
            if (obj.CI_Gestor__c != null && obj.CI_Email_Gestor__c == null && System.Trigger.isUpdate) {
                obj.CI_Email_Gestor__c = obj.CI_Gestor__c;
            }    
        }    
    }
    
}