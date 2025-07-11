public class processEventLeadHelper {
	public static void ProcessLog(List<Event_Lead__e> record) {
        System.debug('Datos: '+record);
                
        //Buscando la Cuenta
        List<Lead> candidato = [Select Id,Status,ConvertedAccountId,CI_Nuevo_Propietario__c From Lead Where Id =: record[0].CI_LeadId__c]; 
        System.debug('candidato: '+candidato);
        
        if(record[0].CI_Update_Lead__c == true) {
        	//candidato[0].CI_Nuevo_Propietario__c = record[0].CI_New_Owner__c;
            //update candidato;
            processEventLeadHelper.updateLead(record[0].CI_LeadId__c, record[0].CI_New_Owner__c, record[0].CI_Proyect__c);
        }
        
        if(record[0].CI_Proyect__c != Null && !candidato.IsEmpty() && candidato[0].Status == 'Qualified' ) {
            
            System.debug('Candidato convertido a cuenta: '+candidato[0].ConvertedAccountId);
            
            List<Account> cuenta = [Select Id,Name From Account Where Id =: candidato[0].ConvertedAccountId];
            
            if(!cuenta.isEmpty()) {
                System.debug('Datos a filtrar: '+cuenta[0].Id+'---'+record[0].CI_Proyect__c);
                List<Opportunity> opp = [Select Id, AccountId, CI_Proyecto__c From Opportunity Where AccountId =: cuenta[0].Id and CI_Proyecto__c =: record[0].CI_Proyect__c and (StageName = 'Probable' or StageName = 'Negociando')];
                System.debug('Lista de oportunidades: '+opp);
                if(opp.isEmpty()) {      
                    Opportunity opor = new Opportunity();
                    opor.AccountId = cuenta[0].Id;
                    opor.StageName = 'Probable';
                    opor.Name = cuenta[0].Name+' '+System.now();
                    opor.CloseDate = System.today() + 30;
                    opor.OwnerId = record[0].CI_New_Owner__c;
                    Insert opor;
                    System.debug('Nueva oportunidad: '+opor);
                }
            } 
            else {
                System.debug('No se puede crear la oportunidad, porque ya existe una similar.');
            }
        }  
    }
    
    @future
    public static void updateLead(String leadId, String newOwner, String newProyect) {
    	List<Lead> candidato = [Select Id,Status,ConvertedAccountId,CI_Nuevo_Propietario__c From Lead Where Id =: leadId]; 
        System.debug('candidato: '+candidato);
        
        if(!candidato.isEmpty()) {
        	candidato[0].CI_Nuevo_Propietario__c = newOwner;
            candidato[0].CI_Cod_Proyecto__c = newProyect;
            update candidato;
        }    
    }
}