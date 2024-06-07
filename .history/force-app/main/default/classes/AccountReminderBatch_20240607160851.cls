/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountReminderBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Obtenir les IDs des comptes avec des commandes et des tâches associées
        Set<Id> orderAccountIds = new Map<Id, Order>([SELECT AccountId FROM Order]).keySet();
        Set<Id> taskAccountIds = new Map<Id, Task>([SELECT WhatId FROM Task WHERE Subject = 'Call' AND WhatId != null]).keySet();

        String query = 'SELECT Id, OwnerId FROM Account WHERE Id NOT IN :orderAccountIds AND Id NOT IN :taskAccountIds';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
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

        try {
            if (!tasksToInsert.isEmpty()) {
                insert tasksToInsert;
            }
        } catch (DmlException e) {
            // Manejar la excepción, por ejemplo, registrar el error
            System.debug('Error inserting tasks: ' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Envoyer une notification ou un résumé si nécessaire
        System.debug('Batch processing finished.');
    }
}