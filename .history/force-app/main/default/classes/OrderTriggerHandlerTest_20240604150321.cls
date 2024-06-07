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
    static Product2 testProduct;
    static PricebookEntry testPBE

    @TestSetup
    static void setup(){
        // Create test data
        testAccounts = TestDataFactory.createAccounts(1);
        testOrders = TestDataFactory.createOrdersForAccounts(testAccounts, 1);
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');
        PricebookEntry testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);
        List<OrderItem> testOrderItems = TestDataFactory.createOrderItems(testOrders, testPBE.Id, 1, 100.0, 1);    
    }
    @isTest
    static void testBeforeUpdateOrder() {
        // Test scenario: Order status changes from 'Draft' to 'Activated' and the order has associated products
        testOrders[0].Status = 'Activated';
        update testOrders;
        System.assertEquals('Activated', [SELECT Status FROM Order WHERE Id = :testOrders[0].Id].Status, 'Order status should be Activated');

        // Test scenario: Order status changes from 'Draft' to 'Activated' and the order has no associated products
        Order testOrderWithoutProducts = TestDataFactory.createOrder(testAccounts[0].Id, 'Draft');
        insert testOrderWithoutProducts;
        testOrderWithoutProducts.Status = 'Activated';
        Test.startTest();
        Database.SaveResult sr = Database.update(testOrderWithoutProducts, false);
        Test.stopTest();
        //System.assertFalse(!sr.isSuccess(),'Update should have failed when no products are associated');
        System.assertEquals('Vous ne pouvez pas passer le statut de lordre à « Actif » sauf si lordre en question a des produits associés.', sr.getErrors()[0].getMessage(), 'Error message should match expected');
    }
}