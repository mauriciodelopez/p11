/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//classe handler pour gérer la logique du déclencheur et va contenir la logique pour vérifier 
//les conditions métier et appeler la classe de vérification des produits.
public with sharing class OrderStatusUpdateHandler {
    //Creation des List newOrders et comparer con el Id de l'order dans oldorderMap
    //oldOrderMap sert beaucoup quand il faut faire des update, si nous avons besoin de faire seulement un insert, pas besoin de la map
    public static void beforeUpdate(List<Order> newOrders, Map<Id, Order> oldOrderMap) {
        for (Order ord : newOrders) {//je vais parcourir la liste de type Order chaque nouvelle Order de newOrders et son nom vas être = ord
            Order oldOrder = oldOrderMap.get(ord.Id);// Ici j'obtient un object Order qui vient d'unne 
            // Vérifier si le statut passe de 'Draft' à 'Active'
            if (oldOrder.Status == 'Draft' && ord.Status == 'Active') {
                // Vérifier si l'order possède des produits associés
                if (!OrderProductValidator.hasProducts(ord.Id)) {
                    ord.addError('Vous ne pouvez pas passer le statut de l’ordre à « Actif » sauf si l’ordre en question a des produits associés.');
                }
            }
        }
    }
}