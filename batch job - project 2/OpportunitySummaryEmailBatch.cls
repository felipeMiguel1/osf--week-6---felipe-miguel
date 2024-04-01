global class OpportunitySummaryEmailBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    Map<Id, Decimal> totalAmountsByAccountId = new Map<Id, Decimal>();
    Map<Id, List<Opportunity>> opportunitiesByAccountId = new Map<Id, List<Opportunity>>();


    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT AccountId, Account.Name, Name, StageName, Amount FROM Opportunity
        ]);
    }

global void execute(Database.BatchableContext BC, List<Opportunity> scope) {


    for (Opportunity opp : scope) {
        if (!totalAmountsByAccountId.containsKey(opp.AccountId)) {
            totalAmountsByAccountId.put(opp.AccountId, 0);
            opportunitiesByAccountId.put(opp.AccountId, new List<Opportunity>());
        }
        totalAmountsByAccountId.put(opp.AccountId, totalAmountsByAccountId.get(opp.AccountId) + opp.Amount);
        opportunitiesByAccountId.get(opp.AccountId).add(opp);
    }

    // Send emails to the specified email address
}
private void sendEmail(String emailAddress, Map<Id, List<Opportunity>> opportunitiesByAccountId) {
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setToAddresses(new List<String>{ emailAddress });
    email.setSubject('Opportunity Summary');

    String body = '<h2>Opportunity Summary</h2>';
    for (Id accountId : opportunitiesByAccountId.keySet()) {
        List<Opportunity> opportunities = opportunitiesByAccountId.get(accountId);
        Decimal totalAmount = 0;
        for (Opportunity opp : opportunities) {
            totalAmount += opp.Amount;
            body += '<p>' + opp.Name + ' - Amount: ' + opp.Amount + '</p>';
        }
        body += '<p>Total Amount for Account ' + accountId + ': ' + totalAmount + '</p>';
    }
    email.setHtmlBody(body);

    Messaging.sendEmail(new List<Messaging.Email>{ email });
}

global void finish(Database.BatchableContext BC) {
    sendEmail('felipeguastim@gmail.com', opportunitiesByAccountId);
}



}
