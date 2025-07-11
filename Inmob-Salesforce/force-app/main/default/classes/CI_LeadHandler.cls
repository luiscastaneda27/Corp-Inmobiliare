/**
**************************************************************************************************************
* @author           Intellect System href=<info@intellectsystem.net>
* @project          Inmobiliare - Implementación CRM
* @name             CI_LeadHandler
* @description      Handler apex class to CI_LeadTrigger trigger.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-09-18   Intellect System              Initial version.
**************************************************************************************************************
*/

public without sharing class CI_LeadHandler extends TriggerHandler {
    
    /**
     * @method      beforeInsert
     * @description Call methods of helper class, in before insert trigger execution.
     * @author      Intellect System - 2023-07-19
     */
    protected override void beforeInsert() {
        
      	//CI_LeadHelper.CrearCuentaLead(Trigger.New);
        CI_LeadHelper.validateIdentities(Trigger.New);
        //CI_LeadHelper.validateDuplicates(Trigger.New);
        CI_LeadHelper.assignProject(Trigger.New);
        CI_LeadHelper.ValidacedularucProspecto(Trigger.New);
        CI_LeadHelper.ValidacedulaProspectoConyuge(Trigger.New);
        CI_LeadHelper.completeData(Trigger.New, (Map<Id,Lead>)Trigger.oldMap);
       
    }
    
    /**
     * @method      afterInsert
     * @description Call methods of helper class, in after insert trigger execution.
     * @author      Intellect System - 2023-07-19
     */
	protected override void afterInsert() {
       /// CI_LeadHelper.CrearCuentaLead(Trigger.New);
        CI_LeadHelper.createTask(Trigger.New);
        CI_LeadHelper.CrearMedioWeb(Trigger.New);
    }
    
    /**
     * @method      beforeUpdate
     * @description Call methods of helper class, in before update trigger execution.
     * @author      Intellect System - 2023-07-19
     */
    protected override void beforeUpdate() {
        CI_LeadHelper.validateIdentities(Trigger.New);
        CI_LeadHelper.validateRecordChange(Trigger.New, (Map<Id,Lead>)Trigger.oldMap);
        CI_LeadHelper.activateLead(Trigger.New);
        CI_LeadHelper.ownerChange(Trigger.New, (Map<Id,Lead>)Trigger.oldMap);
        CI_LeadHelper.ValidacedularucProspecto(Trigger.New);
        CI_LeadHelper.ValidacedulaProspectoConyuge(Trigger.New);
        CI_LeadHelperZapier.validateRecordsZapier(Trigger.New);
    }     
}