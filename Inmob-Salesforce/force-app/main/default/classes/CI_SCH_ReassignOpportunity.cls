global class CI_SCH_ReassignOpportunity implements Schedulable {
    global void execute(SchedulableContext sc) {
        // Implement any logic to be scheduled

        // We now call the batch class to be scheduled
        CI_BAT_ReassignOpportunity b = new CI_BAT_ReassignOpportunity();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,50);
    }
}