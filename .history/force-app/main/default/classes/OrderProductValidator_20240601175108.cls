/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderProductValidator {
    public static Boolean hasProducts(Id orderId) {//hasProductsc'est un method public static qui s'appel hasproducts qui prend un argument orderId de type Id, la method return une valeur boolean (true ou false)
        // Verifier les permis CRUD
        if (!Schema.sObjectType.OrderItem.isAccessible()) {
            throw new SecurityException('Vous navez pas de droits suffisants pour pouvoir acceder à OrderItem');
        }

        // Requête qui compte le nombre des OrderItem que contiennent l'orderId equal au orderid fournit, le résultat est stocké dans la variable productCount
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];
        return productCount > 0;
    }
}