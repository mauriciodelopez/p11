/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountReminderBatchTest {
    @TestSetup
    static void setup() {
        // Crear cuentas de prueba
        List<Account> testAccounts = TestDataFactory.createAccounts(200);
        
        // Crear órdenes para las primeras 50 cuentas
        List<Account> accountsWithOrders = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accountsWithOrders.add(testAccounts[i]);
        }
        TestDataFactory.createOrdersForAccounts(accountsWithOrders);
        
        // Crear tareas para las cuentas de la 101 a la 200
        List<Account> accountsWithTasks = new List<Account>();
        for (Integer i = 100; i < 200; i++) {
            accountsWithTasks.add(testAccounts[i]);
        }
        TestDataFactory.createTasksForAccounts(accountsWithTasks);
    }

    @isTest
    static void testAccountReminderBatch() {
        // Preparar el contexto de prueba
        Test.startTest();

        // Crear y ejecutar el lote
        AccountReminderBatch batch = new AccountReminderBatch();
        Id batchId = Database.executeBatch(batch);

        // Finalizar el contexto de prueba
        Test.stopTest();

        // Verificar que todas las cuentas tengan al menos una orden o una tarea
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

