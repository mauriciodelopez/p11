/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class OrderTriggerHandlerTest {
    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> testAccounts = TestDataFactory.createAccounts(2);

        // Create test orders for the accounts
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts);

        // Create a test product
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');

        // Create a pricebook entry for the test product
        PricebookEntry testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);

        // Create order items for the first order
        TestDataFactory.createOrderItems(new List<Order>{testOrders[0]}, testPBE.Id, 1, 100.0);
    }

    @isTest
    static void testBeforeUpdateOrderWithItems() {
        // Retrieve the orders created in @TestSetup
        List<Order> testOrders = [SELECT Id, Status FROM Order WHERE Status = 'Draft'];

        // Test scenario: Order status changes from 'Draft' to 'Activated' and the order has associated products
        testOrders[0].Status = 'Activated';
        Test.startTest();
        update testOrders[0];
        Test.stopTest();

        // Retrieve the updated order
        Order updatedOrder = [SELECT Id, Status FROM Order WHERE Id = :testOrders[0].Id];

        // Assert: The order's status should be 'Activated'
        System.assertEquals('Activated', updatedOrder.Status, 'order Status should be Activated after update');
    }

    @isTest
    static void testBeforeUpdateOrderWithoutItems() {
        // Retrieve the orders created in @TestSetup
        List<Order> testOrders = [SELECT Id, Status FROM Order];

        // Test scenario: Order status changes from 'Draft' to 'Activated' but the order has no associated products
        testOrders[1].Status = 'Activated';
        Test.startTest();
        try {
            update testOrders[1];
            System.assert(false, 'An exception should have been thrown');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Vous ne pouvez pas passer le statut de lordre à « Actif » sauf si lordre en question a des produits associés.'), 'Expected DmlException with specific message' );
        }
        Test.stopTest();
    }
    
    @isTest
    static void testHandleAfterDelete() {
        // Retrieve the accounts created in @TestSetup
        List<Account> testAccounts = [SELECT Id, Active__c FROM Account];
    
        // Retrieve the orders created in @TestSetup
        List<Order> testOrders = [SELECT Id, Account FROM Order WHERE AccountId IN :testAccounts];
    
        // Test scenario: Delete an order and check if the associated account's Active__c field is set to 'No'
        Test.startTest();
        delete testOrders[0];
        Test.stopTest();
    
        // Retrieve the updated account
        Account updatedAccount = [SELECT Id, Active__c FROM Account WHERE Id = :testOrders[0].AccountId];
    
        // Assert: The account's Active__c field should be 'No'
        System.assertEquals('No', updatedAccount.Active__c, 'Account Active__c field should be No after deleting all its orders');
    }
}