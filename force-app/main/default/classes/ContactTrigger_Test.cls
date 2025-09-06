@IsTest
private with sharing class ContactTrigger_Test {

    private static final String STANDARD_PROFILE_NAME = 'Standard User';
    private static final String SUMMER_PROMOTION_TYPE = 'Summer';
    
    @TestSetup
    static void setup(){
        TestHelper.createTestUser(true, STANDARD_PROFILE_NAME);
        List<Product__c> testProducts = TestHelper.createProducts();
        List<N26_Promotion__c> testPromotions = TestHelper.createPromotions();
        TestHelper.addPromotionToProducts(testPromotions[0], testProducts);
    }

    //Insert new Contacts with Home Country and Product prepopulated and check if they related to the proper Products and PRomotions
    @isTest
    static void insertNewContactWithProduct(){
        User testUser = [SELECT Id FROM User WHERE Profile.Name = :STANDARD_PROFILE_NAME LIMIT 1];
        List<Product__c> products = [SELECT Id, Product__c, Home_Country__c FROM Product__c];
        List<Contact> testContacts = TestHelper.createContacts(2, false, products);
        for(Contact c : testContacts){
            c.Promotion_Type__c = SUMMER_PROMOTION_TYPE;
        }

        Test.startTest();
        System.runAs(testUser){
            insert testContacts;
        }
        Test.stopTest();

        List<Contact> assertContacts = [SELECT ATM_Fee_in_Other_Currencies__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c, N26_Product__c, N26_Promotion__c, Promotion_Type__c, Promotion_Start_Date__c, N26_Product__r.ATM_Fee_in_Other_Currencies__c, N26_Product__r.Cost_per_Calendar_Month__c, N26_Product__r.Card_Replacement_Cost__c, N26_Promotion__r.ATM_Fee_Discount__c, N26_Promotion__r.Card_Replacement_Cost_Discount__c, N26_Promotion__r.Cost_per_Calendar_Month_Discount__c FROM Contact WHERE Id IN : testContacts];
        System.Assert.areEqual(4, assertContacts.size());
        For(Contact assertContact : assertContacts){
            Assert.isNotNull(assertContact.N26_Product__c, 'Product has not been set');
            if(assertContact.Promotion_Type__c == SUMMER_PROMOTION_TYPE){
                Assert.isNotNull(assertContact.N26_Promotion__c, 'Promotion has not been set');
                Assert.isNotNull(assertContact.Promotion_Start_Date__c, 'Promotion Start Date has not been set');
                Assert.areEqual(assertContact.ATM_Fee_in_Other_Currencies__c, finalPriceDiscounted(assertContact.N26_Product__r.ATM_Fee_in_Other_Currencies__c, assertContact.N26_Promotion__r.ATM_Fee_Discount__c), 'Contact ATM Fee is wrong' );
                Assert.areEqual(assertContact.Card_Replacement_Cost__c, finalPriceDiscounted(assertContact.N26_Product__r.Card_Replacement_Cost__c, assertContact.N26_Promotion__r.Card_Replacement_Cost_Discount__c), 'Contact Card Replacement Cost is wrong' );
                Assert.areEqual(assertContact.Cost_per_Calendar_Month__c, finalPriceDiscounted(assertContact.N26_Product__r.Cost_per_Calendar_Month__c, assertContact.N26_Promotion__r.Cost_per_Calendar_Month_Discount__c), 'Contact Calendar Month is wrong' );
            } else {
                Assert.isNull(assertContact.N26_Promotion__c, 'Promotion has been set');
                Assert.areEqual(assertContact.ATM_Fee_in_Other_Currencies__c, assertContact.N26_Product__r.ATM_Fee_in_Other_Currencies__c, 'Contact ATM Fee is wrong' );
                Assert.areEqual(assertContact.Card_Replacement_Cost__c, assertContact.N26_Product__r.Card_Replacement_Cost__c, 'Contact Card Replacement Cost is wrong' );
                Assert.areEqual(assertContact.Cost_per_Calendar_Month__c, assertContact.N26_Product__r.Cost_per_Calendar_Month__c, 'Contact Cost Calendar Month is wrong' );
            }
        }

    }

    //Insert new Contacts with Home Country and Product prepopulated which don't match any Product records
    @isTest
    static void insertNewContactWithNoProduct(){
        User testUser = [SELECT Id FROM User WHERE Profile.Name = :STANDARD_PROFILE_NAME LIMIT 1];
        List<Product__c> products = [SELECT Id, Product__c, Home_Country__c FROM Product__c];
        List<Contact> testContacts = TestHelper.createContacts(2, false, products);
        for(Contact c : testContacts){
            c.Promotion_Type__c = SUMMER_PROMOTION_TYPE;
            c.Product__c = 'Black';//not existing product in the test data
        }

        Test.startTest();
        System.runAs(testUser){
            insert testContacts;
        }
        Test.stopTest();

        List<Contact> assertContacts = [SELECT ATM_Fee_in_Other_Currencies__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c, N26_Product__c, N26_Promotion__c, Promotion_Type__c, Promotion_Start_Date__c FROM Contact WHERE Id IN : testContacts];
        System.Assert.areEqual(4, assertContacts.size());
        For(Contact assertContact : assertContacts){
            Assert.isNull(assertContact.N26_Product__c, 'Product has been set');
            Assert.isNull(assertContact.N26_Promotion__c, 'Promotion has been set');
            Assert.isNull(assertContact.Promotion_Start_Date__c, 'Promotion Start Date has been set');
            Assert.areEqual(assertContact.ATM_Fee_in_Other_Currencies__c, 0, 'ATM Fee has been set');
            Assert.areEqual(assertContact.Cost_per_Calendar_Month__c, 0, 'Card Replacement Cost has been set');
            Assert.areEqual(assertContact.Card_Replacement_Cost__c, 0, 'Cost Calendar Month has been set');
        }

    }

    //Update Promotion Type field of existing Contacts. This should trigger the automatically population of Product and Promotion fields
    @isTest
    static void updateContactWithProduct(){
        User testUser = [SELECT Id FROM User WHERE Profile.Name = :STANDARD_PROFILE_NAME LIMIT 1];
        List<Product__c> products = [SELECT Id, Product__c, Home_Country__c FROM Product__c];
        List<Contact> testContacts = TestHelper.createContacts(2, true, products);
        
        Test.startTest();
        List<Contact> testContactsUpdate = [SELECT Id FROM Contact WHERE Id IN : testContacts];
        for(Contact c : testContactsUpdate){
            c.Promotion_Type__c = SUMMER_PROMOTION_TYPE;
        }
        update testContactsUpdate;
        Test.stopTest();

        List<Contact> assertContacts = [SELECT ATM_Fee_in_Other_Currencies__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c, N26_Product__c, N26_Promotion__c, Promotion_Type__c, Promotion_Start_Date__c, N26_Product__r.ATM_Fee_in_Other_Currencies__c, N26_Product__r.Cost_per_Calendar_Month__c, N26_Product__r.Card_Replacement_Cost__c, N26_Promotion__r.ATM_Fee_Discount__c, N26_Promotion__r.Card_Replacement_Cost_Discount__c, N26_Promotion__r.Cost_per_Calendar_Month_Discount__c FROM Contact WHERE Id IN : testContacts];
        System.Assert.areEqual(4, assertContacts.size());
        For(Contact assertContact : assertContacts){
            Assert.isNotNull(assertContact.N26_Product__c, 'Product has not been set');
            if(assertContact.Promotion_Type__c == SUMMER_PROMOTION_TYPE){
                Assert.isNotNull(assertContact.N26_Promotion__c, 'Promotion has not been set');
                Assert.isNotNull(assertContact.Promotion_Start_Date__c, 'Promotion Start Date has not been set');
                Assert.areEqual(assertContact.ATM_Fee_in_Other_Currencies__c, finalPriceDiscounted(assertContact.N26_Product__r.ATM_Fee_in_Other_Currencies__c, assertContact.N26_Promotion__r.ATM_Fee_Discount__c), 'Contact ATM Fee is wrong' );
                Assert.areEqual(assertContact.Card_Replacement_Cost__c, finalPriceDiscounted(assertContact.N26_Product__r.Card_Replacement_Cost__c, assertContact.N26_Promotion__r.Card_Replacement_Cost_Discount__c), 'Contact Card Replacement Cost is wrong' );
                Assert.areEqual(assertContact.Cost_per_Calendar_Month__c, finalPriceDiscounted(assertContact.N26_Product__r.Cost_per_Calendar_Month__c, assertContact.N26_Promotion__r.Cost_per_Calendar_Month_Discount__c), 'Contact Calendar Month is wrong' );
            } else {
                Assert.isNull(assertContact.N26_Promotion__c, 'Promotion has been set');
                Assert.areEqual(assertContact.ATM_Fee_in_Other_Currencies__c, assertContact.N26_Product__r.ATM_Fee_in_Other_Currencies__c, 'Contact ATM Fee is wrong' );
                Assert.areEqual(assertContact.Card_Replacement_Cost__c, assertContact.N26_Product__r.Card_Replacement_Cost__c, 'Contact Card Replacement Cost is wrong' );
                Assert.areEqual(assertContact.Cost_per_Calendar_Month__c, assertContact.N26_Product__r.Cost_per_Calendar_Month__c, 'Contact Cost Calendar Month is wrong' );
            }
        }

    }

    //Formula to calculate the final price after applying the discount
    private static Decimal finalPriceDiscounted(Decimal value, Decimal discount){
        return value - (value * (discount/100));
    } 
    
}