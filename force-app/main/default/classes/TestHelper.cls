@isTest
public with sharing class TestHelper {
    
    public static List<Contact> createContacts(Integer numberOfRecords, Boolean doInsert, List<Product__c> products){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < numberOfRecords; i++){
            for(Integer j = 0; j < products.size(); j++){
                Product__c prod = products.get(j);
                Contact cont = new Contact();
                cont.LastName = 'TestContact' + i;
                cont.Product__c = prod.Product__c;
                cont.Home_Country__c = prod.Home_Country__c;
                contacts.add(cont);
            }
        }
        if(doInsert){
            insert contacts;
        }
        return contacts; 
    }

    public static List<Case> createCases(Integer numberOfRecords, List<SObject> objectList,Boolean doInsert){
        SObjectType sot = objectList.getSObjectType();
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < numberOfRecords; i++){
            for(Integer j = 0; j < objectList.size(); j++){
                Case c = new Case();
                c.Subject = 'Test Case';
                c.Status = 'New';
                if(sot == Contact.getSObjectType()){
                    c.ContactId = (Id) objectList.get(j).get('Id');
                }
                cases.add(c);
            }
        }
        if(doInsert){
            insert cases;
        }
        return cases; 
    }

    public static List<Product__c> createProducts(){
        //Maybe best approach here would have been the usage of Test.LoadData instead of creating the products manually in the test class
        
        List<Product__c> products = new List<Product__c>();

        Product__c prodMetalDE = new Product__c();
        prodMetalDE.Name = 'Metal DE';
        prodMetalDE.ATM_Fee_in_Other_Currencies__c = 10;
        prodMetalDE.Card_Replacement_Cost__c = 10;
        prodMetalDE.Cost_per_Calendar_Month__c = 10;
        prodMetalDE.Product__c = 'Metal';
        prodMetalDE.Home_Country__c = 'DE';
        products.add(prodMetalDE);

        Product__c prodStandardES = new Product__c();
        prodStandardES.Name = 'Standard ES';
        prodStandardES.ATM_Fee_in_Other_Currencies__c = 20;
        prodStandardES.Card_Replacement_Cost__c = 20;
        prodStandardES.Cost_per_Calendar_Month__c = 20;
        prodStandardES.Product__c = 'Standard';
        prodStandardES.Home_Country__c = 'ES';
        products.add(prodStandardES);

        insert products;
        return products;

    }

    public static List<N26_Promotion__c> createPromotions(){
        
        List<N26_Promotion__c> promotions = new List<N26_Promotion__c>();

        N26_Promotion__c promo1 = new N26_Promotion__c();
        promo1.Name = 'Promo1';
        promo1.ATM_Fee_Discount__c = 10;
        promo1.Cost_per_Calendar_Month_Discount__c = 10;
        promo1.Card_Replacement_Cost_Discount__c = 10;
        promo1.Start_Date__c = Date.today();
        promo1.End_Date__c = Date.today().addDays(10);
        promo1.Duration_In_Months__c = 12;
        promo1.Type__c = 'Summer';
        promotions.add(promo1);

        N26_Promotion__c promo2 = new N26_Promotion__c();
        promo2.Name = 'Promo2';
        promo2.ATM_Fee_Discount__c = 20;
        promo2.Cost_per_Calendar_Month_Discount__c = 20;
        promo2.Card_Replacement_Cost_Discount__c = 20;
        promo2.Start_Date__c = Date.today();
        promo2.End_Date__c = Date.today().addDays(10);
        promo2.Duration_In_Months__c = 12;
        promo2.Type__c = 'Christmas';
        promotions.add(promo2);
        
        insert promotions;
        return promotions;

    }

    public static List<Product_Promotion_Relationship__c> addPromotionToProducts(N26_Promotion__c promo, List<Product__c> products){
        
        List<Product_Promotion_Relationship__c> prodPromoRel = new List<Product_Promotion_Relationship__c>();
        for(Product__c prod : products){
            Product_Promotion_Relationship__c prodPromo = new Product_Promotion_Relationship__c();
            prodPromo.Product__c = prod.Id;
            prodPromo.N26_Promotion__c = promo.Id;
            prodPromoRel.add(prodPromo);
        }
        insert prodPromoRel;
        return prodPromoRel;

    }

    public static User createTestUser(Boolean doInsert, String profileName){
        Profile p = [SELECT Id FROM Profile WHERE Name = :profileName];
        return createTestUser(doInsert, p.Id);
    }

    public static User createTestUser(Boolean doInsert, Id profileId){
        User testUser = new User(
            profileId = profileId,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'n26Testuser123@example.com.test'+ DateTime.now().getTime(), // Deve essere univoco
            Alias = 'tuser',
            TimeZoneSidKey = 'Europe/Rome',
            LocaleSidKey = 'it_IT',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'it'
        );
        if(doInsert){
            insert testUser;
        }
        return testUser;
    }

}