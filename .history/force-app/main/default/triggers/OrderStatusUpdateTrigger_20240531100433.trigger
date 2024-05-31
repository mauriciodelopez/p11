/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-31-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Lorsque le champ « Status » passe du statut « Draft » à « Activated », un traitement trigger se déclenche pour
//appeler une classe apex qui vérifie que l’order en question possède des produits. Si l’order ne possède pas de produits, la
//modification est bloquée et un message d’erreur invitant l’utilisateur à saisir des produits avant d’activer l’order est affiché.

trigger OrderStatusUpdateTrigger on Order(before insert) {

}