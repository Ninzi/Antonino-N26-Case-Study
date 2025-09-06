public with sharing class CaseTriggerHandler {
    public static void beforeInsert(List<Case> newCases) {
        CaseTriggerHelper.stampN26ProductInfo(newCases);
    }
}