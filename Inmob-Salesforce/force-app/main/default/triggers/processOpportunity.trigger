trigger processOpportunity on Opportunity (before insert, before update) {
    
    try {
    
    //Asign value Gestor field to Email Gestor field
    for (Opportunity obj : trigger.new){
        if (obj.CI_Gestor__c != null && System.Trigger.isUpdate) {
            obj.CI_Email_Gestor__c = obj.CI_Gestor__c;
        }    
    }
    //End Asign value Gestor field to Email Gestor field
    
    //Insertando registros en Permiso a Cuenta 
    Boolean b = System.isFuture();   
    Boolean b2 = System.isBatch();
    if(b == False) {
        if(b2 == False) {
            for(Opportunity opor : Trigger.new) {
                if((opor.StageName == 'Probable' || opor.StageName == 'Negociando') && opor.Estado_de_Venta__c != 'Vendido' && opor.ReasignadoAlGestor__c == false) {
                    ValidateEditionInAccountClass.validacionesCuenta(opor.Id,opor.AccountId,opor.CI_Proyecto__c,opor.StageName); 
                } else if((opor.StageName == 'Vendida' && opor.Estado_de_Venta__c == 'Vendido') || opor.StageName == 'No negociada' && opor.ReasignadoAlGestor__c == false) {
                    if(!test.isRunningTest()) { ValidateEditionInAccountClass.validacionesCuenta(opor.Id,opor.AccountId,opor.CI_Proyecto__c,opor.StageName); }     
                }
            }
        }    
    }
    
    Map<String, Opportunity> oppMap = new Map<String, Opportunity>(); //Proyecto
    
    for (Opportunity opp : System.Trigger.new) {           
        if ((opp.CI_Proyecto__c != null) && (System.Trigger.isInsert || (opp.CI_Proyecto__c != System.Trigger.oldMap.get(opp.Id).CI_Proyecto__c)) && opp.ReasignadoAlGestor__c == false) {                        
            if (oppMap.containsKey(opp.CI_Proyecto__c)) {
                System.debug('Entramos al if con la opp : '+opp.id);
                opp.CI_Proyecto__c.addError('Ya existen oportunidades con este proyecto.');
            } else {
                System.debug('Entramos al else con la opp : '+opp.id);
                oppMap.put(opp.CI_Proyecto__c, opp);
            }
        }
    }
    
    //Proyecto del Usuario
    String UserId = UserInfo.getUserId();
    List<User> usuario = [SELECT Id, Name, CI_Nombre_Funcion__c FROM User WHERE Id =: UserId LIMIT 1];
    String UserProyecto = usuario[0].CI_Nombre_Funcion__c; 
    //system.debug('UserProyecto ' + UserProyecto);    
    
    //Cuenta de la Oportunidad
    String accid;
    Set<Id> idCuenta = new Set<Id>();
    for(Opportunity opp : trigger.new) {
        idCuenta.add(opp.AccountId);    
    }    
    if(!idCuenta.isEmpty()) {
        List<Account> account = [SELECT Id FROM Account WHERE Id =: idCuenta];    
        for (Opportunity opoId : Trigger.new) {
            if(account != null && account.size()>0) {
                accid = account[0].Id;  
            } 
        }
    }
        
    List<Opportunity> oport = [SELECT Id,Name,StageName,CI_Proyecto__c,Owner.Name,AccountId FROM Opportunity
                      WHERE CI_Proyecto__c =: UserProyecto and AccountId =: accid and (StageName != 'Vendida' and StageName != 'No negociada')]; 
    System.debug('Total Opor: ' + oport.size());
    
    String IdUser = UserInfo.getUserId(); System.debug(IdUser);   
        
    String Name = UserInfo.getName(); 
    System.debug('Usuario que inserta el Lead: '+Name);    
    
    if(Name != 'Automated Process' || test.isRunningTest()) {    
        
        //Perfil del Usuario
        String ProfileId = UserInfo.getProfileId();
        List<Profile> Profile = [SELECT Id, Name FROM Profile WHERE Id =: ProfileId LIMIT 1];
        String ProfileName = Profile[0].Name;
        
        for (Opportunity opp : oport) {
            if(oppMap.get(opp.CI_Proyecto__c)!= null){
                Opportunity newOpp = oppMap.get(opp.CI_Proyecto__c); //System.debug('Oportunidades existentes: ' + oport.size());
                if(opp.OwnerId != IdUser && ProfileName == 'Asesor de Ventas') {  
                    newOpp.addError('Existen oportunidades abiertas para este proyecto por lo cual en este momento no puede crear una nueva.');
                }     
            }
        }
            
    }        
    
    } catch(Exception ex0) {
        System.debug('Error de processOpportunity: '+ex0.getLineNumber()+'---'+ex0.getMessage());    
    } catch(System.LimitException ex) {
            System.debug('Error de processOpportunity LimitException: '+ex.getLineNumber()+'---'+ex.getMessage());
    }    
}