public with sharing class CaseTriggerHelper {
    //Method to stamp the current Contact N26 Product info from the related Contact on the Case record stamp fields
    public static void stampN26ProductInfo(List<Case> newCases) {
        List<Id> contactIDs = new List<Id>();
        for (Case c : newCases) {
            contactIDs.add(c.ContactId);
        }
        if(contactIDs.IsEmpty()) return;
        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, ATM_Fee_in_Other_Currencies__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c FROM Contact WHERE Id IN : contactIDs]);
        for(Case c : newCases){
            if(contactMap.containsKey(c.ContactId)){
                c.ATM_Fee_in_Other_Currencies_Stamp__c = contactMap.get(c.ContactId).ATM_Fee_in_Other_Currencies__c;
                c.Cost_per_Calendar_Month_Stamp__c = contactMap.get(c.ContactId).Cost_per_Calendar_Month__c;
                c.Card_Replacement_Cost_Stamp__c = contactMap.get(c.ContactId).Card_Replacement_Cost__c;
            }
        }
    }
}