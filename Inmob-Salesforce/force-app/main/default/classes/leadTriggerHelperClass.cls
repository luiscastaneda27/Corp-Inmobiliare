public class leadTriggerHelperClass {
    
    public static boolean flagValidation = false; 
    
    public static void validateIdentity() {
    	// Validando el campo identificación
    	new CI_LeadTriggerHandler().run();    
    }
       
    public static void validateProyect(List<Lead> ld) {
        System.debug('El candidato es: '+ld); 
        
    	// Validando el campo Proyecto
        Set<Id> valProyect = new Set<Id>();
        for (Lead l : ld) {
            if(l.CI_Proyecto__c != Null) {
                valProyect.add(l.CI_Proyecto__c);
            }
        }
        
        //System.debug('valProyect: '+valProyect.size());
        
        if(valProyect.size() > 0) {
            Map<Id, Proyecto__c> proyects = new Map<Id, Proyecto__c>([Select Id, Name from Proyecto__c where Id in :valProyect]);
            Proyecto__c pr = new Proyecto__c();
            for(Lead l : ld) {
                if(l.CI_Cod_Proyecto__c == Null && l.CI_Proyecto__c != Null) {
                    pr = proyects.get(l.CI_Proyecto__c);
                    //System.debug('Proyecto valores: '+pr);
                    l.CI_Cod_Proyecto__c = pr.Name;
                }
            }
        }
    }
    
    public static void assignProject(List<Lead> ld) {
        map<Id,Proyecto__c> listProyects = new  map<Id,Proyecto__c>([Select Id, Name from Proyecto__c]);
        for(Lead l : ld) {
            if(l.CI_Proyecto__c == Null && l.CI_Cod_Proyecto__c != Null) {
                for(ID aID : listProyects.keySet()) {
                    if(l.CI_Cod_Proyecto__c == listProyects.get(aID).Name) {
                        l.CI_Proyecto__c = listProyects.get(aID).Id;   
                    }
                }
            }    
        }    
    }
    
    public static void validateRecordExist(List<Lead> ld) {
        
        String Name = UserInfo.getName(); 
        System.debug('Usuario que inserta el Lead: '+Name);
        
        String UserId = UserInfo.getUserId();
        
        //Validando si los proyectos de los dos usuarios propietarios son diferentes
        boolean convertLead = false;
        User usOld = [Select Id,CI_Nombre_Funcion__c From User Where Id =: ld[0].OwnerId];
        System.debug('usOld: '+usOld);
        User usNew = [Select Id,CI_Nombre_Funcion__c From User Where Id =: UserId];
        System.debug('usNew: '+usNew);
        if(usOld.Id != Null && usNew.Id != Null) {
            System.debug('Entra a la validación de convertLead');
            
            for(Lead l : ld) {
                if(l.CI_Cod_Proyecto__c != Null && usOld.CI_Nombre_Funcion__c != usNew.CI_Nombre_Funcion__c) {
                    //Lead creado desde Pardot
                    convertLead	= true;
                } else {
                    //Lead creado desde Salesforce
                    convertLead	= true;
                }    
            }    
        }   
        
        System.debug('convertLead: '+convertLead);
                        
        //Validando si el Lead ya existe por el Email    
        Map<String,Lead> mapLeadEmail = new Map<String,Lead>();
        for(Lead l : ld) {
     		mapLeadEmail.put(l.Email,l);
        }    
        
        //Almacenando las Cuentas
        //Set<Id> lstCuenta = new Set<Id>();
        
        //Almacenando los proyectos
        String lstProyecto = Null;
        String lstProyecto2 = Null;
        for(Lead l : ld) {
            if(l.CI_Proyecto__c != Null) {
            	lstProyecto = l.CI_Proyecto__c;
            }    
        }
        
        for(Lead l : ld) {
            if(l.CI_Cod_Proyecto__c != Null) {
            	lstProyecto2 = l.CI_Cod_Proyecto__c;
            }    
        }
        
        List<Proyecto__c> proy = new List<Proyecto__c>();
        if(lstProyecto != NUll) {
            proy = [Select Id,Name From Proyecto__c Where Id =: lstProyecto Limit 1];
        }
        
        if(lstProyecto2 != NUll) {
            proy = [Select Id,Name From Proyecto__c Where Name =: lstProyecto2 Limit 1];
        }
        
        Map<Id,Lead> mapLeadIdentity2 = new Map<Id,Lead>();
            
        List<Asignacion_Web_to_Lead__c> assign = new List<Asignacion_Web_to_Lead__c>();
        if(!proy.isEmpty()) {     
            assign = [Select Id,CI_Usuario__c,CI_Usuario__R.Name,CI_Usuario_Activo__c,CI_Proyecto__c,CI_Cantidad_LA__c,CI_Fecha_Ultima_Asignacion__c 
                      From Asignacion_Web_to_Lead__c where CI_Proyecto__c =: proy[0].Name and
                      CI_Usuario_Activo__c = True order by CI_Fecha_Ultima_Asignacion__c Asc Limit 1];
            
            System.debug('Asignar a: '+assign);
        }
        
        if(mapLeadEmail.size() > 0) {
        	Map<Id,Lead> mapLeadEmail2 = new Map<Id,Lead>([SELECT Id,Name,Status,Email,CI_Identificacion__c,Owner.Name,CI_Proyecto__c,CI_Proyecto__r.Name,ConvertedAccountId FROM Lead WHERE Email IN: mapLeadEmail.keySet()]);
            System.debug('Mapa 1: '+Json.serialize(mapLeadEmail2));
            if(mapLeadEmail2.size() > 0) {
                if(Name == 'B2BMA Integration') {  
                    if(!proy.isEmpty()) {                        
                        for(Id id : mapLeadEmail2.keySet()) {
                            for(Lead l : ld) { System.debug('Datos para crear op: '+mapLeadEmail2.get(id).Id+'--'+assign[0].CI_Usuario__c+'--'+proy[0].Name);
                                List<Event_Lead__e> errorLogs = new List<Event_Lead__e>();
                                errorLogs.add(new Event_Lead__e(CI_LeadId__c = mapLeadEmail2.get(id).Id, CI_New_Owner__c = assign[0].CI_Usuario__c, CI_Update_Lead__c = true, CI_Proyect__c = proy[0].Name));
                                // Call method to publish events
                                List<Database.SaveResult> results = EventBus.publish(errorLogs); System.debug('Primera condición');
                                l.addError('El prospecto ya existe, se creará una nueva oportunidad para el proyecto ingresado.');
                                //leadTriggerHelperClass.createRecord(ld, mapLeadIdentity2, lstCuenta, lstProyecto); 
                                flagValidation = true;
                            } 
                        }    
                    }
                } else {
                    for(Id id : mapLeadEmail2.keySet()) {
                        for(Lead l : ld) {
                            if(l.CI_Proyecto__c == mapLeadEmail2.get(id).CI_Proyecto__c) {
                            	l.addError('Un prospecto con esta dirección de correo electrónico ya existe y es propiedad de: '+mapLeadEmail2.get(id).Owner.Name); 	  
                            } else {
                                System.debug('Se procesde a convertir el Lead');
                                if(convertLead) {
                                    System.debug('Bandera convertLead: '+convertLead);
                                    List<Event_Lead__e> errorLogs = new List<Event_Lead__e>();
                                    errorLogs.add(new Event_Lead__e(CI_LeadId__c = mapLeadEmail2.get(id).Id, CI_New_Owner__c = assign[0].CI_Usuario__c, CI_Proyect__c = proy[0].Name, CI_Update_Lead__c = true));
                                    // Call method to publish events
                                    List<Database.SaveResult> results = EventBus.publish(errorLogs);

                                    l.addError('El prospecto ya existe para otro Proyecto, se creará una nueva oportunidad para el proyecto ingresado.');  
                                }    
                            }    
                        }
                    }    
                }    
            }    
        }
        
        //Validando si el Lead ya existe por la Identificación
        Map<String,Lead> mapLeadIdentity = new Map<String,Lead>();
        for(Lead l : ld) {
     		mapLeadIdentity.put(l.CI_Identificacion__c,l);
        }    
        System.debug('mapLeadIdentity: '+mapLeadIdentity.size());
        
        if(mapLeadIdentity.size() > 0 && flagValidation == false) {
        	mapLeadIdentity2 = new Map<Id,Lead>([SELECT Id,Name,Status,Email,CI_Identificacion__c,Owner.Name,CI_Proyecto__c,CI_Proyecto__r.Name,ConvertedAccountId FROM Lead WHERE CI_Identificacion__c IN: mapLeadIdentity.keySet()]);
            System.debug('Mapa 2: '+Json.serialize(mapLeadIdentity2));
            if(mapLeadIdentity2.size() > 0) {
                if(Name == 'B2BMA Integration') {   
                    if(!proy.isEmpty()) {
                        for(Id id : mapLeadIdentity2.keySet()) {
                            for(Lead l : ld) { System.debug('Datos para crear op 2: '+mapLeadIdentity2.get(id).Id+'--'+assign[0].CI_Usuario__c+'--'+proy[0].Name);
                                List<Event_Lead__e> errorLogs = new List<Event_Lead__e>();
                                errorLogs.add(new Event_Lead__e(CI_LeadId__c = mapLeadIdentity2.get(id).Id, CI_New_Owner__c = assign[0].CI_Usuario__c, CI_Proyect__c = proy[0].Name));
                                // Call method to publish events
                                List<Database.SaveResult> results = EventBus.publish(errorLogs); System.debug('Segunda condición');
                                l.addError('El prospecto ya existe, se creará una nueva oportunidad para el proyecto ingresado.');
                                //leadTriggerHelperClass.createRecord(ld, mapLeadIdentity2, lstCuenta, lstProyecto); 
                            } 
                        }    
                    }    
                } else {
                    for(Id id : mapLeadIdentity2.keySet()) {
                        for(Lead l : ld) {
                            //System.debug('Estos valores: '+l.CI_Proyecto__c+'--'+mapLeadIdentity2.get(id).CI_Proyecto__c);
                            if(l.CI_Proyecto__c == mapLeadIdentity2.get(id).CI_Proyecto__c) {
                            	l.addError('Un prospecto con esta identificación ya existe o ya ha sido convertido a Cuenta y es propiedad de: '+mapLeadIdentity2.get(id).Owner.Name); 	
                            	Break;
                            } else {
                                if(convertLead) {
                                    List<Event_Lead__e> errorLogs = new List<Event_Lead__e>();
                                    errorLogs.add(new Event_Lead__e(CI_LeadId__c = mapLeadIdentity2.get(id).Id, CI_New_Owner__c = assign[0].CI_Usuario__c, CI_Proyect__c = proy[0].Name, CI_Update_Lead__c = true));
                                    // Call method to publish events
                                    List<Database.SaveResult> results = EventBus.publish(errorLogs);
                                   	l.addError('El prospecto ya existe para otro Proyecto, se creará una nueva oportunidad para el proyecto ingresado.');
                                }                                   
                            }    
                        }
                    }
                }    
            }    
        }
        
        //Validando si el Cóntuge ya existe en otro Lead
        Map<String,Lead> mapLeadIdentitySpouse = new Map<String,Lead>();
        for(Lead l : ld) {
            if(l.CI_Identificacion_C__c != Null)
     		mapLeadIdentitySpouse.put(l.CI_Identificacion_C__c,l);
        }    
        System.debug('Datos a mostrar: '+mapLeadIdentitySpouse.size());
        
        if(mapLeadIdentitySpouse.size() > 0 && mapLeadIdentity2.size() == 0) {
        	Map<Id,Lead> mapLeadIdentitySpouse2 = new Map<Id,Lead>([SELECT Id,Name,Email,CI_Identificacion__c,CI_Identificacion_c__c,Owner.Name FROM Lead WHERE CI_Identificacion__c IN: mapLeadIdentitySpouse.keySet() Limit 1]);
			System.debug('mapLeadIdentitySpouse2: '+mapLeadIdentitySpouse2);
            if(mapLeadIdentitySpouse2.size() > 0) {
                for(Id id : mapLeadIdentitySpouse2.keySet()) {
                    System.debug('mapLeadIdentitySpouse2.get(id).CI_Identificacion_c__c: '+mapLeadIdentitySpouse2.get(id).CI_Identificacion_c__c);
                    //if(mapLeadIdentitySpouse2.get(id).CI_Identificacion_c__c != Null) { 
                        for(Lead l : ld) { 
                            l.addError('Un cónyuge con esta identificación ya existe bajo el id: ' +mapLeadIdentitySpouse2.get(id).CI_Identificacion__c+' y es propiedad de: '+mapLeadIdentitySpouse2.get(id).Owner.Name); 	  
                        }
                    //}
                }
            }    
        }
        
        //Validando si el Cónyuge ya existe por la Identificación del Lead
        Map<String,Lead> mapLeadIdentitySpouse2 = new Map<String,Lead>();
        for(Lead l : ld) {
     		mapLeadIdentitySpouse2.put(l.CI_Identificacion__c,l);
        }    
        
        if(mapLeadIdentitySpouse2.size() > 0 && mapLeadIdentity2.size() == 0) {
        	Map<Id,Lead> mapLeadIdentitySpouse3 = new Map<Id,Lead>([SELECT Id,Name,Email,CI_Identificacion__c,CI_Identificacion_c__c,Owner.Name FROM Lead WHERE CI_Identificacion_C__c IN: mapLeadIdentitySpouse2.keySet() Limit 1]);
			System.debug('mapLeadIdentitySpouse3: '+mapLeadIdentitySpouse3);
            if(mapLeadIdentitySpouse3.size() > 0) { 
                for(Id id : mapLeadIdentitySpouse3.keySet()) { 
                    //if(mapLeadIdentitySpouse3.get(id).CI_Identificacion_c__c != Null) { 
                        for(Lead l : ld) { 
                            l.addError('Un cónyuge con esta identificación ya existe en el Lead: ' +mapLeadIdentitySpouse3.get(id).CI_Identificacion__c+' y es propiedad de: '+mapLeadIdentitySpouse3.get(id).Owner.Name); 	  
                        }
                    //}
                }
            }    
        }
    }
}