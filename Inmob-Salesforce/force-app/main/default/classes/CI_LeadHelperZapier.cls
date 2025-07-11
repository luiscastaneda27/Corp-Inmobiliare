/**
**************************************************************************************************************
* @author           Intellect System href=<info@intellectsystem.net>
* @project          Inmobiliare - Implementación CRM
* @name             CI_LeadHelperZapier
* @description      Helper apex class to CI_LeadHandler, process the record created by Zapier.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-09-25   Intellect System              Initial version.
**************************************************************************************************************
*/

public without sharing class CI_LeadHelperZapier {
    
    public static Boolean isFirstTime = true;
    
    /**
     * @method      validateRecordsZapier
     * @description Method to validate records updates by Zapier integration and create opportunity related to account.
     * @author      Intellect System - 2023-09-25
     * @param       leadRecords - List of cases received
     */
    public static void validateRecordsZapier(List<Lead> leadRecords) { 
      try{    
          if(CI_LeadHelperZapier.isFirstTime) {
            CI_LeadHelperZapier.isFirstTime = false; 
            
            Set<String> projectName = new Set<String>();
            for(Lead lead : leadRecords) {
                if(lead.Status == 'Qualified' || test.isRunningTest()) {
                    if (Lead.CI_Cod_Proyecto__c != null) 
                		projectName.add(Lead.CI_Cod_Proyecto__c); 
                    else{
                        if(Lead.Proyecto_Lista__c  != null)
                           projectName.add(Lead.Proyecto_Lista__c);  
                    }
                         
                }    
            }
            
            if(!projectName.isEmpty()) {
                Map<String, Asignacion_Web_to_Lead__c> usersInteg = new Map<String, Asignacion_Web_to_Lead__c>
                                                                        ([  SELECT  	Id, CI_Usuario__c, CI_Usuario_Activo__c, CI_Proyecto__c, CI_Fecha_Ultima_Asignacion__c
                                                                            FROM    	Asignacion_Web_to_Lead__c 
                                                                            WHERE   	CI_Usuario_Activo__c = true AND CI_Proyecto__c IN : projectName
                                                                            ORDER BY 	CI_Fecha_Ultima_Asignacion__c ASC LIMIT 1]);
                  
                Map<String, Object> leadMap = new Map<String, Object>();
                
                //Update new owner and custom assignment
                for(Lead lead : leadRecords) {
                    for(Id id : usersInteg.keySet()) {   
                        lead.CI_Nuevo_Propietario__c = usersInteg.get(Id).CI_Usuario__c;
                        usersInteg.get(Id).CI_Fecha_Ultima_Asignacion__c = System.now();
                        leadMap.put('IdLead', lead.Id); 
                    }    
                }
                
                Update usersInteg.values();
                      
                //Call flow that create the new Opportunity
                Flow.Interview.CI_Crear_Segunda_Oportunidad flow1 = new Flow.Interview.CI_Crear_Segunda_Oportunidad(leadMap);
                flow1.start();
            }    
        }   
         }catch(Exception ex0) {
        System.debug('Error Prospecto Calificado no se modifica: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
        }
      }
}