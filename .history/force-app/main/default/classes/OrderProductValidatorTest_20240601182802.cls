/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class OrderProductValidatorTest {
    @testSetup
    static void setup() {
        // Création des données de test 
        List<Account> testAccounts = TestDataFactory.createAccounts(1);
        List<Order> testOrders = TestDataFactory.createOrdersForAccounts(testAccounts, 1);
        Product2 testProduct = TestDataFactory.createProduct('Test Product', 'Test Family');
        PricebookEntry testPBE = TestDataFactory.createPricebookEntry(testProduct, 100.0);
        TestDataFactory.createOrderItems(testOrders, testPBE.Id, 1, 100.0, 1);
    }
    @isTest
    static void test
}