/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderProductValidator {
    public static Map<Id,Boolean> hasProducts(List<Id> orderIds) {//hasProducts c'est un method public static  qui prend un argument orderId de type Id, la method return une valeur boolean a la question = est que l'ordre a des produits et return un (true ou false)
        // Verifier les permis CRUD
        if (!Schema.sObjectType.OrderItem.isAccessible()) {
            throw new SecurityException('Vous navez pas de droits suffisants pour pouvoir acceder à OrderItem');
        }
        

        // Requête qui compte le nombre des OrderItem que contiennent l'orderId equal au orderid fournit, le résultat est stocké dans la variable productCount
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];
        return productCount > 0;
    }
}