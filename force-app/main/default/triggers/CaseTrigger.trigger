trigger CaseTrigger on Case (before insert) {

    Switch on Trigger.operationType {
        when BEFORE_INSERT {
            CaseTriggerHandler.beforeInsert(Trigger.new);
        }
    }

}