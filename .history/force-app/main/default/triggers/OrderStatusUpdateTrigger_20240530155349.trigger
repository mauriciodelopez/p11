/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OrderStatusUpdateTrigger on Order (before update) {
    for (Order o : Trigger.new) {
        if (o.Status == 'Active' && Trigger.oldMap.get(o.Id).Status != 'Active') {
            List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId = :o.Id];
            if (orderItems.isEmpty()) {
                o.addError('Vous devez associer des produits avant de pouvoir activer cet order.');
            }
        }
    }
}
