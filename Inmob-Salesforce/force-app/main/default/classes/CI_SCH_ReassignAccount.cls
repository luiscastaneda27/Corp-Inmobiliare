global class CI_SCH_ReassignAccount implements Queueable {
    
    List<Account> updateLeases = new List<Account>();

    global CI_SCH_ReassignAccount( Map<String, Account> leases) {
        updateLeases.addAll(leases.Values());
    }

    global void execute(QueueableContext qc) {  

        if (!updateLeases.isEmpty()) { 
           //pass leases to Batch class
		   Database.executeBatch(new CI_BAT_ReassignAccount(updateLeases));
        }
    }
}