/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//classe handler pour gérer la logique du déclencheur et va contenir la logique pour vérifier 
//les conditions métier et appeler la classe de vérification des produits.
public class OrderTriggerHandler {
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

    public static void handleAfterDelete(Map<Id, Order> oldOrderMap) {
        // Récupérer les Ids des comptes associés aux commandes supprimées
        Set<Id> accountIds = new Set<Id>();
        for (Order order : oldOrderMap.values()) {
            accountIds.add(order.AccountId);
        }
    
        // Récupérer les comptes avec leurs commandes
        Map<Id, Account> accountsWithOrders = new Map<Id, Account>([
            SELECT Id, (SELECT Id FROM Orders)
            FROM Account
            WHERE Id IN :accountIds
        ]);
    
        // Liste des comptes à mettre à jour
        List<Account> accountsToUpdate = new List<Account>();
    
        // Parcourir les comptes
        for (Account acc : accountsWithOrders.values()) {
            // Si le compte n'a pas de commandes
            if (acc.Orders.isEmpty()) {
                // Décocher la case Active__c
                acc.Active__c = 'No';
                // Ajouter le compte à la liste des comptes à mettre à jour
                accountsToUpdate.add(acc);
            }
        }
    
        // Si il y a des comptes à mettre à jour
        if (!accountsToUpdate.isEmpty()) {
            // Mettre à jour les comptes
            update accountsToUpdate;
        }
    }

    
}

//Pas d'appel de methode hasproducts dans le for et faire une seule class pour handler et la methode hasproducts