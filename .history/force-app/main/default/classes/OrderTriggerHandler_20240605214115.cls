/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//classe handler pour gérer la logique du déclencheur et va contenir la logique pour vérifier 
//les conditions métier et appeler la classe de vérification des produits.
public with sharing class OrderTriggerHandler {
    //Creation des List newOrders et comparer con el Id de l'order dans oldorderMap
    //oldOrderMap sert beaucoup quand il faut faire des update, si nous avons besoin de faire seulement un insert, pas besoin de la map
    public static void beforeUpdateOrder(List<Order> newOrders, Map<Id, Order> oldOrderMap) {
        // Créer une liste pour stocker les identifiants de commande
        List<Id> orderIds = new List<Id>();
        
        for (Order ord : newOrders) {//je vais parcourir la liste de type Order chaque nouvelle Order de newOrders et son nom vas être = ord
            Order oldOrder = oldOrderMap.get(ord.Id);// Ici j'obtient un object Order qui vient d'unne OldorderMap qui prent l'Id comme parametre et l'order comme valeur, ici je recupre l'ancien version de l'order
            // Vérifier si le statut passe de 'Draft' à 'Active'
            if (oldOrder.Status == 'Draft' && ord.Status == 'Activated') {
                // Ajouter l'identifiant de la commande à la liste
                orderIds.add(ord.Id);
            }
        }

        // Appeler la méthode hasProducts une seule fois avec la liste des identifiants de commande
        Map<Id, Boolean> hasProductsMap = OrderProductValidator.hasProducts(orderIds);

        for (Order ord : newOrders) {
            Order oldOrder = oldOrderMap.get(ord.Id);
            if (oldOrder.Status == 'Draft' && ord.Status == 'Activated') {
                // Vérifier si la commande a des produits associés en utilisant le résultat retourné par la méthode hasProducts
                if (!hasProductsMap.get(ord.Id)) {
                    ord.addError('Vous ne pouvez pas passer le statut de lordre à « Actif » sauf si lordre en question a des produits associés.');
                }
            }
        }
    }
    
    public static void handleAfterDelete(Map<Id, Order> oldOrderMap){

        // Check CRUD permissions
        if (!Schema.sObjectType.Account.fields.Active__c.isUpdateable()) {
            // Handle lack of update permissions for Active__c field
            throw new System.PermissionException('You do not have permission to update the Active__c field on Account.');
        }
        if (!Schema.sObjectType.Account.isAccessible()) {
            // Handle lack of read permissions for Account object
            throw new System.PermissionException('You do not have permission to access Account records.');
        }

        // Récupérer les Ids des comptes associés aux commandes supprimées
        Set<Id> accountIds = new Set<Id>();
        for (Order order : oldOrderMap.values()) {
            accountIds.add(order.AccountId);
        }

        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> accountsWithOrders = new Map<Id, Account>();

        if (Schema.sObjectType.Account.isAccessible() && Schema.sObjectType.Account.fields.Active__c.isAccessible()) {
            accountsWithOrders = new Map<Id, Account>([
                SELECT Id, Active__c, (SELECT Id FROM Orders)
                FROM Account
                WHERE Id IN :accountIds
            ]);
        }

        for (Account acc : accountsWithOrders.values()) {
            if (acc.Orders.isEmpty()) {
                acc.Active__c = false; // Set Active__c to false
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            // Check update permission on Account
            if (Schema.sObjectType.Account.isUpdateable()) {
                update accountsToUpdate;
            } else {
                throw new System.NoAccessException('You do not have permission to update Account records.');
            }
        }    
    }
}

//Pas d'appel de methode hasproducts dans le for et faire une seule class pour handler et la methode hasproducts