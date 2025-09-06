public with sharing class ContactTriggerHandler {

    public static void beforeInsert(List<Contact> newContacts) {
        //For each new Contact we search the related N26 PRoduct and Promo and fill the related fields on the Contact
        ContactTriggerHelper.updateN26Product(newContacts);
    }

    public static void beforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldContacts) {
        //For each update Contact we check if the Product or Home country or Promo Type field is changed, if so we search the related N26 PRoduct and Promo and fill the related fields on the Contact
        List<Contact> productUpdatedContacts = checkIfProductUpdated(newContacts, oldContacts);
        if(!productUpdatedContacts.IsEmpty()){
            ContactTriggerHelper.updateN26Product(productUpdatedContacts);
        }
    }

    //Method to check if the Product , Home country or Promotion Type field is changed
    private static List<Contact> checkIfProductUpdated(List<Contact> newContacts, Map<Id, Contact> oldContacts) {
        List<Contact> productUpdatedContacts = new List<Contact>();
        for(Contact cont : newContacts) {
            if(cont.Product__c != oldContacts.get(cont.Id).Product__c || cont.Home_Country__c != oldContacts.get(cont.Id).Home_Country__c || cont.Promotion_Type__c != oldContacts.get(cont.Id).Promotion_Type__c) {
                productUpdatedContacts.add(cont);
            }
        }
        return productUpdatedContacts;
    }
}