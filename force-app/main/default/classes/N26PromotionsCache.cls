public with sharing class N26PromotionsCache implements Cache.CacheBuilder {
    //CacheBuilder interface implementation which returns a Map of N26 Product IDs and their Active related Promotions and cache them so that they don't need to get retrieved any time the Contact trigger runs
    private Map<Id, List<N26_Promotion__c>> getN26Promotions(){
        Map<Id, List<N26_Promotion__c>> N26Promotions = new Map<Id, List<N26_Promotion__c>>();
        For(N26_Promotion__c promo : [SELECT Id, Type__c, (SELECT Product__r.Id FROM Product_Promotion_Relationships__r) FROM N26_Promotion__c WHERE Start_Date__c <= TODAY AND End_Date__c >= TODAY WITH SYSTEM_MODE]){
            For(Product_Promotion_Relationship__c productPromo : promo.Product_Promotion_Relationships__r){
                if (!N26Promotions.containsKey(productPromo.Product__r.Id)) {
                    N26Promotions.put(productPromo.Product__r.Id, new List<N26_Promotion__c>());
                }
                N26Promotions.get(productPromo.Product__r.Id).add(promo);
            }
        }
        return N26Promotions;
    }
    
    public Object doLoad(String key){
        Object obj;
        obj = (Map<Id, List<N26_Promotion__c>>) getN26Promotions();
        return obj;
    }

}