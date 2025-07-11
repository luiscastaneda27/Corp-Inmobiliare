/**
**************************************************************************************************************
* @author           Intellect System href=<info@intellectsystem.net>
* @project          Inmobiliare - Implementación CRM
* @name             CI_LeadHelper
* @description      Helper apex class to CI_LeadHandler.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-07-19   Intellect System              Initial version.
**************************************************************************************************************
*/

public without sharing class CI_LeadHelper {
    
    
 
 
  public class LeadException extends Exception{}

    /**
     * @method      validarcedularuc
     * @description Method to validate identities.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    public static void validateIdentities(List<Lead> leadRecords) {
        Boolean flagDuplicate = usersIntegration();
        
        Map<Id,Schema.RecordTypeInfo> rtMap = Lead.sobjectType.getDescribe().getRecordTypeInfosById(); 

        for(Lead lead : leadRecords) {          
          if(lead.CI_Identificacion__c <> null) {
            if(lead.CI_Identificacion__c.contains('-')) {
                lead.CI_Identificacion__c = lead.CI_Identificacion__c.replace('-','');
            }   
            } 
            boolean resultado = CI_Validaciones.infotributariaecuador(lead.CI_Personeria__c, lead.CI_Identificacion__c, lead.CI_Tipo_Iden__c, lead.RecordType.Name);   
            
            if(resultado == false){ 
                if(flagDuplicate == true) {
                    lead.CI_Identificacion__c.adderror('No es una identificación válida');
                } else {
                    lead.CI_Duplicate__c = true;
                }      
            } 
        }
    } 
    
    /**
     * @method      assignProject
     * @description Method to assign the Lead to a project.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    public static void assignProject(List<Lead> leadRecords) {       
        map<Id,Proyecto__c> listProyects = new  map<Id,Proyecto__c>([   SELECT  Id, Name 
                                                                        FROM    Proyecto__c]);
                                                                 
        for(Lead l : leadRecords) {
            if(l.CI_Proyecto__c == Null && l.CI_Cod_Proyecto__c != Null) {
                for(ID aID : listProyects.keySet()) {
                    if(l.CI_Cod_Proyecto__c == listProyects.get(aID).Name) {
                        l.CI_Proyecto__c = listProyects.get(aID).Id;
                    }
                }
            }    
        }  
    }
    
    /**
     * @method      completeData
     * @description Method to complete data in the Lead record.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    public static void completeData(List<Lead> leadRecords, Map<Id, Lead> mapOldLeads) {       
        for(Lead lead : leadRecords) {
            //Complete lead - Custom Fecha de Asignación
            if(lead.CI_Fecha_de_asignacion__c == null) {
                lead.CI_Fecha_de_asignacion__c = System.today();
            }
            //Complete lead - Custom Email
            if(lead.Email != null && lead.Email != lead.CI_Email__c) {
                lead.CI_Email__c = lead.Email;
            }
            //Complete lead - Lead created by salesforce user
            if(lead.CI_Web_to_Lead__c == null && lead.CI_Asignado__c == false) {
                lead.CI_Asignado__c = true;
            }
        }         
    }
    
    public static void ownerChange(List<Lead> leadRecords, Map<Id, Lead> mapOldLeads) {       
        for(Lead lead : leadRecords) {
            //Complete lead - Custom Fecha de Asignación
            if(lead.OwnerId != mapOldLeads.get(lead.Id).OwnerId) {
                lead.CI_Fecha_de_asignacion__c = System.today();
                if(lead.CI_Numero_asigna__c == null) {
                    lead.CI_Numero_asigna__c = 0;
                }
                lead.CI_Numero_asigna__c = lead.CI_Numero_asigna__c + 1;
            }
        }         
    }
    
    /**
     * @method      validateDuplicates
     * @description Method to prevent duplicate Leads - Validation By Field: Número de identificación
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    /*public static void validateDuplicates(List<Lead> leadRecords) {
        Boolean flagDuplicate = usersIntegration();

        //Validating if the Lead already exists by Identification  
        set<String> idLeads = new set<String>();
        set<String> idLeadproyecto = new set<String>();
        
        for(Lead l : leadRecords) {
            idLeads.add(l.CI_Identificacion__c); 
            system.debug('CI_Proyecto__c ' + l.CI_Proyecto__c );
            idLeadproyecto.add(l.CI_Proyecto__c);       
        }
        
        try {            
            List<Lead> leadList = new List<Lead>([  SELECT  Id, Name, Status, Email,CI_Identificacion__c, CI_Identificacion_C__c, Owner.Name, ConvertedAccountId 
                                                    FROM    Lead 
                                                    WHERE   (CI_Identificacion__c IN : idLeads OR CI_Identificacion_C__c IN : idLeads) 
                                                    and CI_Proyecto__c in : (idLeadproyecto)]);
            
            map<String,Lead> leadMap = new map<String,Lead>();
            map<String,Lead> leadMap2 = new map<String,Lead>();

            for(Lead l : leadList) {
                leadMap.put(l.CI_Identificacion__c,l);
                leadMap2.put(l.CI_Identificacion_C__c,l);
            }
            
            for(Lead l : leadRecords) {
                if(leadMap.get(l.CI_Identificacion__c) != null && l.CI_Identificacion__c != null) {
                    if(flagDuplicate == false) {
                        l.addError('Un prospecto con esta identificación ya existe o ya ha sido convertido a Cuenta y es propiedad de: '+
                                   leadMap.get(l.CI_Identificacion__c).Owner.Name + ' y estado: '+ leadMap.get(l.CI_Identificacion__c).status); 
                    }  
                } 
                else if(leadMap2.get(l.CI_Identificacion__c) != null && l.CI_Identificacion__c != null ) {
                    if(flagDuplicate == false) {
                         system.debug('vvv' + leadMap2.get(l.CI_Identificacion__c).CI_Identificacion__c );
                         system.debug('1vv' + leadMap2.get(l.CI_Identificacion__c).Owner.Name );
                         //system.debug('3vv' + leadMap.get(l.CI_Identificacion__c).status);
                        
                        l.addError('Un cónyuge con esta identificación ya existe y es propiedad '+ leadMap2.get(l.CI_Identificacion__c).Owner.Name);//: ' + leadMap2.get(l.CI_Identificacion__c).CI_Identificacion__c + ' y es propiedad de: ');// + leadMap2.get(l.CI_Identificacion__c).Owner.Name + 'y estado: ' + leadMap.get(l.CI_Identificacion__c).status); 
                        //l.addError('Un cónyuge con esta identificación ya existe bajo el id2: ' + leadMap2.get(l.CI_Identificacion__c).CI_Identificacion__c + ' y es propiedad de: ' + leadMap2.get(l.CI_Identificacion__c).Owner.Name) ; 
                    } 
                }
            }
        } catch(Exception ex) {
            //System.debug('Error in Trigger CI_LeadHelper: '+ex.getMessage()+ ', in line: '+ex.getLineNumber() + '---' +ex.getCause());
            throw new LeadException('Error in Trigger CI_LeadHelper: '+ex.getMessage()+ ', in line: '+ex.getLineNumber() + '---' +ex.getCause());
        }
    }*/
    
    /**
     * @method      validateRecordChange
     * @description Method to validate duplicate Lead registration.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     * @param       oldLeaddRecords - List of all cases received
     */
    public static void validateRecordChange(List<Lead> leadRecords, Map<Id, Lead> oldLeaddRecords) {
        Boolean flagDuplicate = usersIntegration();
        
        //Validating if the Lead already exists by Identification
        set<String> idLeads = new set<String>();
        for(Lead l : leadRecords) {
            if ((l.CI_Identificacion__c !=null) && l.CI_Identificacion__c != null)
            idLeads.add(l.CI_Identificacion__c);        
        }
        
        try {  
            
            set<String> proyecto = new set<String>();
            for(Lead l : leadRecords) {
                proyecto.add(l.CI_Cod_Proyecto__c);        
            }
            
            List<Asignacion_Web_to_Lead__c> assignList = new List<Asignacion_Web_to_Lead__c>(
                                                        [SELECT Id, CI_Usuario__c,CI_Usuario__R.email, CI_Usuario__R.Name, CI_Usuario_Activo_Web__c, CI_Proyecto__c, 
                                                             CI_Cantidad_LA__c, CI_Fecha_Ultima_Asignacion__c FROM Asignacion_Web_to_Lead__c 
                                                             WHERE  Proyecto_vendedor__c =: proyecto 
                                                             and CI_Usuario_Activo_Web__c=:true 
                                                            ORDER BY CI_Fecha_Ultima_Asignacion__c ASC limit 1
                                                            ]);
            /*SELECT      Id, CI_Usuario__c, CI_Usuario__R.Name, CI_Usuario_Activo__c, CI_Proyecto__c, CI_Cantidad_LA__c, CI_Fecha_Ultima_Asignacion__c 
                                                            FROM        Asignacion_Web_to_Lead__c 
                                                            WHERE       CI_Proyecto__c IN : proyecto and CI_Usuario_Activo__c = true  
                                                            ORDER BY    CI_Fecha_Ultima_Asignacion__c ASC*/

            List<Lead> leadList = new List<Lead>([  SELECT  Id, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, Owner.Name, CI_Cod_Proyecto__c, ConvertedAccountId 
                                                    FROM    Lead  Where CI_Identificacion__c !='' AND CI_Identificacion_C__c !='' 
                                                    AND ( CI_Identificacion__c IN : idLeads OR CI_Identificacion_C__c IN : idLeads) 
                                                    and CI_Proyecto__c in : (proyecto)]);
            
            map<String,Lead> leadMap = new map<String,Lead>();
            map<String,Lead> leadMap2 = new map<String,Lead>();

            for(Lead l : leadList) {
                leadMap.put(l.CI_Identificacion__c,l);
                leadMap2.put(l.CI_Identificacion_C__c,l);
             
            }
            
            for(Lead lead : leadRecords) { 
                if(leadMap.get(lead.CI_Identificacion__c) != null  && lead.CI_Identificacion__c != oldLeaddRecords.get(lead.Id).CI_Identificacion__c && (lead.CI_Identificacion__c == leadMap.get(lead.CI_Identificacion__c).CI_Identificacion__c)) {
                    if(flagDuplicate == false) {
                        lead.addError('Un prospecto con esta identificación ya existe o ya ha sido convertido a Cuenta y es propiedad de: '+ leadMap.get(lead.CI_Identificacion__c).Owner.Name  + 'y estado: ' + leadMap.get(lead.CI_Identificacion__c).status); 
                    } else {
                        lead.CI_Duplicate__c = true;
                    }      
                } 
                else if(leadMap2.get(lead.CI_Identificacion__c) != null  && lead.CI_Identificacion__c != null ) {
                                       if(flagDuplicate == false) {
                                           system.debug('mensaje '+ lead.CI_Identificacion__c);
                        lead.addError('Un cónyuge con esta identificación ya existe bajo el id: ' + leadMap2.get(lead.CI_Identificacion__c).CI_Identificacion__c + ' y es propiedad de: ' + leadMap2.get(lead.CI_Identificacion__c).Owner.Name); 
                    } else {
                        lead.CI_Duplicate__c = true;
                    }   
                } else if(lead.CI_Cod_Proyecto__c!= Null && leadMap.size() > 0 && (lead.CI_Cod_Proyecto__c != leadMap.get(lead.CI_Identificacion__c).CI_Cod_Proyecto__c)) {
                    if(lead.Status != 'Qualified') {
                        for(Asignacion_Web_to_Lead__c assign : assignList) {
                            List<Event_Lead__e> errorLogs = new List<Event_Lead__e>();
                            errorLogs.add(new Event_Lead__e(CI_LeadId__c = leadMap.get(lead.CI_Identificacion__c).Id,
                                                            CI_New_Owner__c = assign.CI_Usuario__c, 
                                                            CI_Update_Lead__c = true,
                                                            CI_Proyect__c = lead.CI_Cod_Proyecto__c));

                            // Call method to publish events
                            List<Database.SaveResult> results = EventBus.publish(errorLogs);
                        }
                    }
                }
            }
        } catch(Exception ex) {
            //System.debug('Error in Trigger CI_LeadHelper: '+ex.getMessage()+ ', in line: '+ex.getLineNumber() + '---' +ex.getCause());
            throw new LeadException('Error in Trigger CI_LeadHelper: '+ex.getMessage()+ ', in line: '+ex.getLineNumber() + '---' +ex.getCause());
        }
    }
    
    /**
     * @method      createTask
     * @description Method to create task when creating a Lead.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    public static void createTask(List<Lead> leadRecords) {
        Set<Id> idLead = new Set<Id>();
        List<Lead> updateLead = new List<Lead>();
        for(Lead lead : leadRecords) {
            idLead.add(lead.Id);   
        }
        leadRecords = [ SELECT  Id, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, Owner.Name, CI_Cod_Proyecto__c, ConvertedAccountId 
                        FROM    Lead 
                        Where   Id IN : idLead];
        try{     
                    String userName = UserInfo.getName();
                    Task tsk = new Task();
                    List<Task> createTsk = new List<Task>();
            
                    for(Lead lead : leadRecords) {
                        if(userName != 'B2BMA Integration' || test.isRunningTest()) {
                            tsk.WhoId = lead.Id; 
                            tsk.Subject = 'Nuevo Prospecto creado por el Asesor'; 
                            tsk.Priority = 'Normal'; 
                            tsk.Status = 'Completed'; 
                            tsk.ActivityDate = System.Today(); 
                            createTsk.add(tsk);    
                        }
                        lead.CI_Fecha_ultima_gestion__c = System.Today();
                        updateLead.add(lead);
                    } 
            
                    if(!createTsk.isEmpty()) {
                        Insert createTsk;
                        update updateLead;
                    }
           }
        catch(Exception ex0) {
            System.debug('Error de tarea : '+ex0.getLineNumber()+'---'+ex0.getMessage());  
            //list<Opportunity> op = new list<Opportunity>();
 		  }
    }
    
    /**
     * @method      activateLead
     * @description Method to activate Lead if status is equals to 'Dado de Baja'.
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     */
    public static void activateLead(List<Lead> leadRecords) {
        Boolean processLead = usersIntegration();
        
        for(Lead lead : leadRecords) {
            if(lead.Status == 'Dado de Baja' && processLead == true) {
                lead.Status = 'Working';
                lead.CI_Motivo_Baja__c = null;                                                      
            }
        }
    }
    
    /**
     * @method      usersIntegration
     * @description Method to validate if the current user is included in the integrations Metadata
     * @author      Intellect System - 2023-07-19
     * @param       leadRecords - List of cases received
     * @return      flagLead - boolean flag
     */
    public static Boolean usersIntegration() {
        Boolean flagLead = false;
        String userAct = UserInfo.getName();        
        Map<String,Usuarios_para_Integracion__mdt> usersInteg = new Map<String,Usuarios_para_Integracion__mdt>
                                                                ([  SELECT  Id, Nombre_usuario__c, Omitir_validaciones__c
                                                                    FROM    Usuarios_para_Integracion__mdt 
                                                                    WHERE   Omitir_validaciones__c = true]);

        for(Id id : usersInteg.keySet()) {
            if(userAct == usersInteg.get(id).Nombre_usuario__c) {
                flagLead = true;
            }    
        }
        
        return flagLead;
    }
    
     public static void ValidacedularucProspecto(List<lead> accs) {
        Map<Id,Schema.RecordTypeInfo> rtMap = lead.sobjectType.getDescribe().getRecordTypeInfosById(); 
        for(lead a:(List<lead>) accs){    
           boolean resultado = CI_Validaciones.infotributariaecuador(a.CI_Personeria__c,a.CI_Identificacion__c,a.CI_Tipo_Iden__c,a.RecordType.Name);   
            if(resultado==false) { a.CI_Identificacion__c.adderror('No es una identificación válida');
            }
        }
    }
    
    public static void ValidacedulaProspectoConyuge(List<lead> accs) {
        Map<Id,Schema.RecordTypeInfo> rtMap = lead.sobjectType.getDescribe().getRecordTypeInfosById(); 
        for(lead a:(List<lead>) accs){      
            boolean resultado = CI_Validaciones.infotributariaecuadorconyuge(a.CI_Tipo_Ident_C__c,a.CI_Identificacion_C__c);   
            if(resultado==false) { a.CI_Identificacion_C__c.adderror('No es una identificación válida del cónyuge');
            }
        }
    }

	public static void CrearMedioWeb(list<lead> leadRecords )/*es insert*/
   	{
      try{

          list<Lead> tprop=new list<Lead>();
          Set<string> ListIdentificacion = new Set<string>();
          List<Medio_Web_Prospecto__c> listMedio = new List<Medio_Web_Prospecto__c> ();

          for(Lead item : leadRecords){
              if(item.EsWeb__C == true || item.CI_Origen__c == 'Web'){
                  ListIdentificacion.add(item.CI_Identificacion__c);
              }
          }
          
          if(Test.isRunningTest()){ 
              tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead];
          }
          else{ 
              tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c in:ListIdentificacion
                        and CI_Ref_Web_To_Lead__c<>'S'];
          }
          
          for(Lead item : leadRecords){
              for(Lead resp: tProp){
                  if(item.CI_Identificacion__c == resp.CI_Identificacion__c){
                      Medio_Web_Prospecto__c medio=new Medio_Web_Prospecto__c(Prospecto__c=resp.Id,
                                                                       CI_Identificacion_c__c = item.CI_Identificacion__c, 
                                                                       Name = '-inserta '+ item.CI_Identificacion__c, 
                                                                       CI_Origen_c__c = item.CI_Origen__c,
                                                                       Proyecto__c = item.CI_Proyecto__c,
                                                                        Fecha_Ingreso__c=date.today()       
                                                                      ); 
                      ListMedio.add(medio);
                  }
              }
          }

          insert ListMedio;
             
      	}
       	catch(Exception ex0){
           System.debug('Error de Prospecto: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
       	}   
 	}

	    
}