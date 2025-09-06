public with sharing class ContactTriggerHelper {

    private static final String N26_PARTITION_NAME = 'local.N26';
    private static Cache.OrgPartition n26Partition = Cache.Org.getPartition(N26_PARTITION_NAME); //Cache Partition created 

    //Retrieve from Cache the products and the promotions
    public static Map<String, Product__c> n26Products = getN26Products();
    public static Map<Id, List<N26_Promotion__c>> n26_Products_Promotions = getN26Promotions();

    public static void updateN26Product(List<Contact> newContacts){
        if(newContacts.IsEmpty()) return;

        For(Contact cont : newContacts){

            String productHomeCountry = cont.Product__c + cont.Home_Country__c;

            if(!n26Products.containsKey(productHomeCountry)){
                blankProductInfo(cont);
                break;
            } 

            Product__c n26_product = n26Products.get(productHomeCountry);
            cont.N26_Product__c = n26_product.Id;
            blankPromotionInfo(cont);//blank promo because new product has been added and then search for new promo if exists

            //search for new promo if exists
            if(n26_Products_Promotions == null || n26_Products_Promotions.IsEmpty() || !n26_Products_Promotions.containsKey(n26_product.Id) || n26_Products_Promotions.get(n26_product.Id).IsEmpty()) return;
            if(String.IsBlank(cont.Promotion_Type__c)) return;
            For(N26_Promotion__c promo : n26_Products_Promotions.get(n26_product.Id)){
                if(cont.Promotion_Type__c==promo.Type__c){//Added type to createa a kind of category for each Promo
                    cont.N26_Promotion__c = promo.Id;
                    cont.Promotion_Start_Date__c = system.today();//This is the started date of the promo for the customer
                }
            }

        }
    }

    public static Map<String, Product__c> getN26Products(){
        return (Map<String, Product__c>) n26Partition.get(N26ProductsCache.class, 'N26ProductsCache');
    }

    public static Map<Id, List<N26_Promotion__c>> getN26Promotions(){
        return (Map<Id, List<N26_Promotion__c>>) n26Partition.get(N26PromotionsCache.class, 'N26PromotionsCache');
    }

    private static void blankProductInfo(Contact cont){
        cont.N26_Product__c = null;
        blankPromotionInfo(cont);
    }

    private static void blankPromotionInfo(Contact cont){
        cont.N26_Promotion__c = null;
        cont.Promotion_Start_Date__c = null;
    }

}