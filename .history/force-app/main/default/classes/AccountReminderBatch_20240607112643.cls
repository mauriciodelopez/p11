/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountReminderBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, OwnerId FROM Account WHERE Id NOT IN (SELECT AccountId FROM Order) AND Id NOT IN (SELECT WhatId FROM Task WHERE Subject = \'Call\')';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        List<Task> tasksToInsert = new List<Task>();
        for (Account acc : scope) {
            Task reminder = new Task(
                WhatId = acc.Id,
                OwnerId = acc.OwnerId,
                Subject = 'Call',
                Status = 'Nouvelle',
                Priority = 'Normale',
                ActivityDate = Date.today().addDays(5) // Rappel automatique dans 5 jours
            );
            tasksToInsert.add(reminder);
        }
        insert tasksToInsert;
    }

    public void finish(Database.BatchableContext BC) {
        // Envoyer une notification ou un résumé si nécessaire
    }


        public class AccountReminderScheduler implements Schedulable {
            public void execute(SchedulableContext SC) {
        AccountReminderBatch batch = new AccountReminderBatch();
        Database.executeBatch(batch);
    }
}