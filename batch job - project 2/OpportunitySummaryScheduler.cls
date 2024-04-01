global class OpportunitySummaryScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunitySummaryEmailBatch batch = new OpportunitySummaryEmailBatch();

        Database.executeBatch(batch);
    }
}