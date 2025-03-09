global class OpportunityFollowUpScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        OpportunityFollowUpBatch batch = new OpportunityFollowUpBatch();
        Database.executeBatch(batch, 200);
    }
}