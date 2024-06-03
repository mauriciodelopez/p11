/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Lorsque le champ « Status » passe du statut « Draft » à « Activated », un traitement trigger se déclenche pour
//appeler une classe apex qui vérifie que l’order en question possède des produits. Si l’order ne possède pas de produits, la
//modification est bloquée et un message d’erreur invitant l’utilisateur à saisir des produits avant d’activer l’order est affiché.

//Le Trigger OrderStatusUpdateTrigger est défini sur l'objet Order et il se déclenche avant toute mise à jour. 
//Il appelle la méthode beforeUpdate de la classe OrderStatusUpdateHandler.
trigger OrderStatusUpdateTrigger on Order (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderStatusUpdateHandler.beforeUpdateOrder(Trigger.new, Trigger.oldMap);
    }
}

//change le nom du trigger à OrderTrigger
//change le nom de la classe à OrderTriggerHandler
//Donc choses a faire c'est Renommer les classes de test 
//faire le @testsetup pour la class test triggerhandler après avoir changer le nom


