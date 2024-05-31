/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderProductValidator {
    public static Boolean hasProducts(Id orderId) {
        // Requête pour vérifier les produits associés à l'ordre
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];
        return productCount > 0;
    }
}