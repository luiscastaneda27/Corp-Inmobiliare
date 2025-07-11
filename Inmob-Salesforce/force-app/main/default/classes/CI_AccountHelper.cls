public without sharing class CI_AccountHelper {
    
    public static void ValidacedularucAccount(List<Account> accs) {
        Map<Id,Schema.RecordTypeInfo> rtMap = Account.sobjectType.getDescribe().getRecordTypeInfosById(); 
        for(Account a:(List<Account>) accs){    
            boolean resultado = CI_Validaciones.infotributariaecuador(a.CI_Tipo_Persona__c,a.CI_Identificacion__c,a.CI_Tipo_Identi__c,a.RecordType.Name);   
            if(resultado==false) { a.CI_Identificacion__c.adderror('No es una identificación válida');
            }
        }
    }
    
    public static void ValidacedulaAccountConyuge(List<Account> accs) {
        Map<Id,Schema.RecordTypeInfo> rtMap = Account.sobjectType.getDescribe().getRecordTypeInfosById(); 
        for(Account a:(List<Account>) accs){      
            boolean resultado = CI_Validaciones.infotributariaecuadorconyuge(a.CI_Tipo_Ident_C__c,a.CI_Identificacion_C__c);   
            if(resultado==false) { a.CI_Identificacion_C__c.adderror('No es una identificación válida del cónyuge');
            }
        }
    }    
    
    public static void validateIdentity(List<Account> accs, Map<Id,Account> oldAccs) {
        list<string> listIdentidades = new list<string>();
        list<string> listRuc = new list<string>();
        Map<string, integer> mapIdentidades = new map<string, integer>();

        for (Account obj : accs){
            if (obj.CI_Gestor__c != null && System.Trigger.isInsert) { obj.CI_Email_Gestor__c = obj.CI_Gestor__c;
            }  
            if (obj.CI_Identificacion__c != null && (System.Trigger.isInsert || (obj.CI_Identificacion__c != oldAccs.get(obj.Id).CI_Identificacion__c))) {
                listIdentidades.add(obj.CI_Identificacion__c);    
            }
        }
        for(account item : [select CI_Identificacion__c from account where CI_Identificacion__c in :listIdentidades]){
            if(!mapIdentidades.containsKey(item.CI_Identificacion__c)){
                 mapIdentidades.put(item.CI_Identificacion__c, 3);
            }
        }
         
         for (Account obj : accs) { System.debug('Mapa valor es: '+mapIdentidades);
            if(mapIdentidades.containsKey(obj.CI_Identificacion__c) && !test.isRunningTest()){
                obj.CI_Identificacion__c.addError('Se  encontro otra cuenta con la misma identificación.');
                   //se comenta validación para que permita nueva identificacion
           // }else if(obj.CI_Identificacion__c != null && !test.isRunningTest()){
             //  obj.CI_Identificacion__c.addError('Debe ingresar una identificación válida.');
            }
        }
    }
    
    public static void createTask_Account(List<Account> accs) {
        List<Task> insertTasks = new List<Task>();
        Set<Id> idAccs = new Set<Id>();
        for(Account acc : accs) {
            if(acc.CI_Tipo_de_Cliente__c == 'Prospecto Potencial') { 
                task tsk = new task();
                tsk.WhatId = acc.id; 
                tsk.Subject = 'Nueva Cuenta Creada'; 
                tsk.Priority = 'High'; 
                tsk.Status = 'Completed'; 
                tsk.ActivityDate = System.Today(); 
                insertTasks.add(tsk);
                
                //Actualizando la fecha de última gestión en la cuenta
                idAccs.add(acc.Id);
            }
        }
        if(insertTasks.size() > 0) {
            Insert insertTasks;
            if(System.IsBatch() == false && System.isFuture() == false) {
            	updateAccount(idAccs);
            }    
        }
    }
    
    @future
    public static void updateAccount(Set<Id> idAccs){
        List<Account> accs = new List<Account>();
        List<Account> updateAccs = new List<Account>();
        accs = [Select Id, CI_Fecha_ultima_gestion__c From Account Where Id In : idAccs];
        for(Account ac : accs) {
        	ac.CI_Fecha_ultima_gestion__c = System.today();
            updateAccs.add(ac);
        }
        if(updateAccs.size() > 0) {
            Update updateAccs;
        }
    }
    
    public static void ValidateEditionInAccount(List<Account> accs) {
        try {
    
            //Get Id of Account
            Set<String> cliente = new Set<String>();
            for (Account acc : accs) {
                cliente.add(acc.Id);
            }
            //End Get Id of Account
            //Perfil del Usuario
            String ProfileId = UserInfo.getProfileId();
            List<Profile> Profile = [SELECT Id, Name FROM Profile WHERE Id =: ProfileId LIMIT 1];
            String ProfileName = Profile[0].Name; system.debug('ProfileName ' + ProfileName);
            
            //Proyecto del Usuario
            String UserId = UserInfo.getUserId();
            List<User> usuario = [SELECT Id, Name, CI_Nombre_Funcion__c FROM User WHERE Id =: UserId LIMIT 1];
            String UserProyecto = usuario[0].CI_Nombre_Funcion__c; system.debug('UserProyecto ' + UserProyecto);
            
            //Id del Proyecto
            List<Proyecto__c> proyect = [SELECT Id, Name FROM Proyecto__c WHERE Name =: UserProyecto LIMIT 1];
            String UserProyectoId = proyect[0].Id; system.debug('UserProyectoId ' + UserProyectoId);
               
            List<Permiso_a_Cuenta__c> permiso = [Select Id,Name,CI_Proyecto__c,CI_Oportunidad__c,CI_Propietario__c,CI_Permite_Edicion__c 
                                                 from Permiso_a_Cuenta__c where CI_Propietario__c =: UserId and CI_Cuenta__c IN: cliente 
                                                 and CI_Permite_Edicion__c =: True];
            System.debug('permiso ' + permiso);
            
            //Permisos por Jefes
            List<Permiso_a_Cuenta__c> permiso2 = [Select Id,Name,CI_Proyecto__c,CI_Cuenta__c,CI_Oportunidad__c,CI_Propietario__c,
                                                  CI_Permite_Edicion__c from Permiso_a_Cuenta__c where CI_Proyecto__c =: UserProyecto 
                                                  and CI_Cuenta__c IN: cliente and CI_Permite_Edicion__c = True];
            System.debug('Permisos Jefe ' + permiso2.size());
            
            for (Account acc : accs) {     
              //  if(Acc.Id != null && permiso.size() == 0 && ProfileName == 'Asesor de Ventas') { acc.addError('No puede modificar la cuenta porque no tiene oportunidades activas para este registro.');    
               // }
                if((ProfileName == 'Coordinador de Ventas') && acc.CI_Proyecto__c != UserProyectoId && permiso2.size() == 0) {   
                    acc.addError('No puede modificar la cuenta porque no pertenece a este proyecto.');    
                }
            }
                
    	} catch(Exception ex) {
        	System.debug('Error en ValidateEditionInAccout class: '+ex.getLineNumber()+'---'+ex.getMessage());
        }
    }
    
}