public class CI_AccountHandler extends TriggerHandler {
	protected override void beforeInsert() {
        CI_AccountHelper.validateIdentity(Trigger.new, (Map<Id,Account>)Trigger.oldMap);
		CI_AccountHelper.ValidacedularucAccount(Trigger.new);
        CI_AccountHelper.ValidacedulaAccountConyuge(Trigger.new);
    }
    
	protected override void afterInsert() {
        CI_AccountHelper.createTask_Account(Trigger.new);
    }
    
    protected override void afterUpdate() {
        //CI_AccountHelper.validateIdentity(Trigger.new, (Map<Id,Account>)Trigger.oldMap);
    }
    
    protected override void beforeUpdate() {
        CI_AccountHelper.ValidacedularucAccount(Trigger.new);
        CI_AccountHelper.ValidacedulaAccountConyuge(Trigger.new);
        CI_AccountHelper.ValidateEditionInAccount(Trigger.new);
        // CI_AccountHelper.validateIdentity(Trigger.new, (Map<Id,Account>)Trigger.oldMap);
    }
}