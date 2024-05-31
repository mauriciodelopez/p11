/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OrderProductValidator {
    public static Boolean hasProducts(Id orderId) {//c'est un method public static qui s'appel hasproducts qui prend un argument orderId de type Id, la method return une valeur boolean (true ou false)
        // Verifier les permis CRUD
        if (!Schema.sObjectType.OrderItem.isAccessible()) {
            throw new SecurityException('Vous navez pas de droits suffisants pour pouvoir acceder à OrderItem');
        }

        // Requête  pour vérifier les produits associés à l'ordre
        Integer productCount = [SELECT COUNT() FROM OrderItem WHERE OrderId = :orderId];
        return productCount > 0;
    }
}