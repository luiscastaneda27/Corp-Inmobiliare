trigger processEventLead on Event_Lead__e (after insert) {
	if(Trigger.isInsert) {
    	if (Trigger.isAfter) {
            processEventLeadHelper.ProcessLog(trigger.new);
        }
    }
}