/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class AccountReminderBatchTest {
    @TestSetup
    static void setup() {
        // Création test accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(200);
        
        // Create orders pour les premièrs 50 accounts
        List<Account> accountsWithOrders = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accountsWithOrders.add(testAccounts[i]);
        }
        TestDataFactory.createOrdersForAccounts(accountsWithOrders);
        
        // Création de taches pour les accounts du 90 à 200
        List<Account> accountsWithTasks = new List<Account>();
        for (Integer i = 90; i < 200; i++) {
            accountsWithTasks.add(testAccounts[i]);
        }
        TestDataFactory.createTasksForAccounts(accountsWithTasks);
    }

    @isTest
    static void testAccountReminderBatch() {
        // Preparer le context de test 
        Test.startTest();

        // Crear y ejecutar el lote
        AccountReminderBatch batch = new AccountReminderBatch();
        Database.executeBatch(batch);

        // Finaliser le context de test
        Test.stopTest();

        // Vérifier que toutes les accounts ont au moins Verificar que todas las cuentas tengan al menos una orden o una tarea
        List<Order> orders = [SELECT AccountID FROM Order];
        List<Task> tasks = [SELECT WhatId FROM Task];

        Set<ID> oIDs = new Set<ID>();
        Set<ID> tIDs = new Set<ID>();

        for (Order o : orders) {
            oIDs.add(o.AccountID);
        }

        for (Task t : tasks) {
            tIDs.add(t.WhatId);
        }

        List<Account> result = [SELECT ID FROM Account WHERE (ID NOT IN :oIDs AND ID NOT IN :tIDs)];
        System.assertEquals(0, result.size(), 'All accounts should have at least one order or task associated');
    }
}

