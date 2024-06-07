/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ScheduleBatch implements Schedulable {
    public static String sched = '0 00 01 ? * 2#1';

    public void execute(SchedulableContext SC) {
        AccountReminderBatch batch = new AccountReminderBatch();
        Integer scopeSize = 200; // Tamaño de lote adecuado
        Database.executeBatch(batch, scopeSize);
    }
}