/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class OrderTriggerHandlerTest {
    static List<Account> testAccounts;
    static List<Order> testOrders;

    @TestSetup
    static void setup(){
        // Create test data
        testAccounts = TestDataFactory.createAccounts(1);
        if (testAccounts == null || testAccounts.isEmpty()) {
            System.assert(false, 'testAccounts should not be null or empty');
            return;
        }

        testOrders = TestDataFactory.createOrdersForAccounts(testAccounts, 1);
        if (testOrders == null || testOrders.isEmpty()) {
            System.assert(false, 'testOrders should not be null or empty');
            return;
        }

        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');
        if (testProduct == null) {
            System.assert(false, 'testProduct should not be null');
            return;
        }

        PricebookEntry testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);
        if (testPBE == null) {
            System.assert(false, 'testPBE should not be null');
            return;
        }

        List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(testOrders, testPBE.Id, 1, 100.0, 1);
        if (testOrderItems == null || testOrderItems.isEmpty()) {
            System.assert(false, 'testOrderItems should not be null or empty');
            return;
        }
    }

    @isTest
    static void testBeforeUpdateOrder() {
        // Test scenario: Order status changes from 'Draft' to 'Activated' and the order has associated products
        testOrders[0].Status = 'Activated';
        update testOrders;
        System.assertEquals('Activated', [SELECT Status FROM Order WHERE Id = :testOrders[0].Id].Status, 'Order status should be Activated');

        // Test scenario: Order status changes from 'Draft' to 'Activated' and the order has no associated products
        Order testOrderWithoutProducts = TestDataFactory.createOrder(testAccounts[0].Id, 'Draft');
        if (testOrderWithoutProducts == null) {
            System.assert(false, 'testOrderWithoutProducts should not be null');
            return;
        }

        insert testOrderWithoutProducts;
        testOrderWithoutProducts.Status = 'Activated';
        Test.startTest();
        Database.SaveResult sr = Database.update(testOrderWithoutProducts, false);
        Test.stopTest();
        if (sr.isSuccess()) {
            System.assert(false, 'Update should have failed when no products are associated');
        } else {
            if (sr.getErrors() != null && !sr.getErrors().isEmpty()) {
                System.assertEquals('Vous ne pouvez pas passer le statut de lordre à « Actif » sauf si lordre en question a des produits associés.', sr.getErrors()[0].getMessage(), 'Error message should match expected');
            } else {
                System.assert(false, 'sr.getErrors() should not be null or empty');
            }
        }
    }
}