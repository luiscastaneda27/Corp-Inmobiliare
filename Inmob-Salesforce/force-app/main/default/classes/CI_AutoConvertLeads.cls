Public without sharing class CI_AutoConvertLeads {
    @InvocableMethod
    public static void LeadAssign(List<Id> LeadIds) {
        try {
            LeadStatus CLeadStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true Limit 1];
            List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
            
            Lead candidato = [SELECT Id, Name, Status, CI_Identificacion__c FROM Lead WHERE Id IN: LeadIds];
            
            for(id currentlead: LeadIds){
                Database.LeadConvert Leadconvert = new Database.LeadConvert();
                Leadconvert.setLeadId(currentlead);                
                Leadconvert.setConvertedStatus(CLeadStatus.ApiName);
                if(candidato.Status == 'Dado de Baja') {
                    Leadconvert.setDoNotCreateOpportunity(TRUE);
                }
                MassLeadconvert.add(Leadconvert);         
            }
            if (!MassLeadconvert.isEmpty()) {
                List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert);
            }  
        } catch(System.DmlException ex) {
            System.debug('Error al convertir el candidato: '+ex.getMessage());
        }    
    }
}