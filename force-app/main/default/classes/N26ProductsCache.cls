public with sharing class N26ProductsCache implements Cache.CacheBuilder {
    //CacheBuilder interface implementation which returns a Map of N26 Product String Codes (Product+HomeCountry) and the N26 Product and cache them so that they don't need to get retrieved any time the Contact Trigger runs
    private Map<String, Product__c> getN26Products(){
        Map<String, Product__c> N26Products = new Map<String, Product__c>();
        For(Product__c n26Prod : [SELECT Id, Name, Home_Country__c, Product__c, ATM_Fee_in_Other_Currencies__c, Card_Replacement_Cost__c, Cost_per_Calendar_Month__c FROM Product__c WITH SYSTEM_MODE]){
            N26Products.put(n26Prod.Product__c + n26Prod.Home_Country__c, n26Prod);
        }
        return N26Products;
    }
    
    public Object doLoad(String key){
        Object obj;
        obj = (Map<String, Product__c>) getN26Products();
        return obj;
    }

}