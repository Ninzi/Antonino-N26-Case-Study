@IsTest
private with sharing class CaseTrigger_Test {

    private static final String ADMIN_PROFILE_NAME = 'System Administrator';
    
    @TestSetup
    static void setup(){
        TestHelper.createTestUser(true, ADMIN_PROFILE_NAME);
        List<Product__c> testProducts = TestHelper.createProducts(); //Created 2 Products
        TestHelper.createContacts(2, true, testProducts); //Created 4 Contacts
    }

    //Create new Cases and check if the stamp fields are populated with the related Contact product fields
    @isTest
    static void insertNewCases(){
        User testUser = [SELECT Id FROM User WHERE Profile.Name = :ADMIN_PROFILE_NAME LIMIT 1];
        List<Product__c> products = [SELECT Id, Product__c, Home_Country__c FROM Product__c];
        Map<Id, Contact> testContacts = new Map<Id, Contact>([SELECT Id, ATM_Fee_in_Other_Currencies__c, Cost_per_Calendar_Month__c, Card_Replacement_Cost__c FROM Contact]);
        List<Case> testCases = TestHelper.createCases(2, (List<Contact>) testContacts.values(), false); //To create 8 Cases

        Test.startTest();
        System.runAs(testUser){
            insert testCases;
        }
        Test.stopTest();

        List<Case> assertCases = [SELECT ContactId, ATM_Fee_in_Other_Currencies_Stamp__c, Card_Replacement_Cost_Stamp__c, Cost_per_Calendar_Month_Stamp__c FROM Case WHERE Id IN : testCases];
        System.Assert.areEqual(8, assertCases.size());
        For(Case assertCase : assertCases){
            Assert.areEqual(assertCase.ATM_Fee_in_Other_Currencies_Stamp__c, testContacts.get(assertCase.ContactId).ATM_Fee_in_Other_Currencies__c, 'ATM Fee Stamp is wrong');
            Assert.areEqual(assertCase.Card_Replacement_Cost_Stamp__c, testContacts.get(assertCase.ContactId).Card_Replacement_Cost__c, 'Card Replacement Cost Stamp is wrong');
            Assert.areEqual(assertCase.Cost_per_Calendar_Month_Stamp__c, testContacts.get(assertCase.ContactId).Cost_per_Calendar_Month__c, 'Cost Calendar Month Stamp is wrong');
        }

    }

}