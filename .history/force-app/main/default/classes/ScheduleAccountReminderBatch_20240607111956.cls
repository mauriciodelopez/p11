/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-07-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ScheduleAccountReminderBatch {
    public static void scheduleJob() {
        String cronExp = '0 0 0 ? 1/1 MON#1 *'; // Primer lunes de cada mes
        String jobName = 'AccountReminderJob';
        AccountReminderScheduler ars = new AccountReminderScheduler();
        System.schedule(jobName, cronExp, ars);
    }
}