trigger ContactTrigger on Contact (before insert, before update) {
    Switch on Trigger.operationType {
        when BEFORE_INSERT {
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            ContactTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}