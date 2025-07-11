public class CI_OpportunityHandler extends TriggerHandler {
	protected override void beforeInsert() {
        CI_OpportunityHelper.validateOpenOpportunities(Trigger.new);
    }
    
	protected override void afterInsert() {
        CI_OpportunityHelper.createPermissiontoAccount(Trigger.new);
    }
    
    protected override void afterUpdate() {
        CI_OpportunityHelper.modifyPermissiontoAccount(Trigger.new, (Map<Id,Opportunity>)Trigger.oldMap);
    }
    
    protected override void beforeUpdate() {
        CI_OpportunityHelper.assignGestor(Trigger.new); 
    }
}