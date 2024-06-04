/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Lorsque le champ « Status » passe du statut « Draft » à « Activated », un traitement trigger se déclenche pour
//appeler une classe apex qui vérifie que l’order en question possède des produits. Si l’order ne possède pas de produits, la
//modification est bloquée et un message d’erreur invitant l’utilisateur à saisir des produits avant d’activer l’order est affiché.

//Le Trigger OrderStatusUpdateTrigger est défini sur l'objet Order et il se déclenche avant toute mise à jour. 
//Il appelle la méthode beforeUpdate de la classe OrderStatusUpdateHandler.
trigger OrderTrigger on Order (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OrderTriggerHandler.beforeUpdateOrder(Trigger.new, Trigger.oldMap);
    }
}

//Change le nom du trigger à OrderTrigger KO
//change le nom de la classe à OrderTriggerHandler
//Donc choses a faire c'est Renommer les classes de test avec le bon nom
//faire le @testsetup pour la class test triggerhandler après avoir changer le nom
// La class de test OrderProductValidator enlever l'appel de la methode hasProducts dans le boucle for, rappel toi Pas d'appel de methode hasproducts dans le for, a la place faire une list
//Les risques d'avoir lappel de la methode dans le for, est collapse lorsque on lutilise avec beaucoup des donnes de test 
//Faire une seule class que englobe les class en orderTriggerHandler & OrderProductValidator, c'est n'est pas obligatoire 

