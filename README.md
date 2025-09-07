<h4>Pre-requisites</h4>
Once created the new dev org please complete these pre-requisite steps:

  1) Activate the Multi Currencies setting (Setup --> Company --> Edit --> Activate Multiple Currencies --> Select EUR as default currency)
  2) Add new currencies (Setup --> Manage Currencies --> New --> Add GBP currency (and EUR if it's not already there)
  3) Submit a cache trial request (Setup -->  Platform Cache --> Request Trial Capacity button)

<h4>Data load</h4>
See csv files in the repository to upload the following records:

1) Insert "insert products.csv" in Product__c object
2) Insert "insert n26 promotions.csv" in N26_Promotion__c object
3) Insert "Product_Promotion_Relationship__c" records relating the above new Products and N26_Promotion__c records. This can be done manually going to a Product record page and check for the Product Promotion relationships related list. You can just create few of them for testing.

<h4>Tests</h4>
To test the solution create new Contacts with the Product, Home Country, Promotion Type fields populated. Promotion Type field should have the same value as "Type" field value on the N26 Promotion records.
You can also update any of those Contact fields to test the solution.
Create then new Cases related to those Contacts.

<h4>Troubleshooting</h4>
In case the N26 Product or N26 Promotion fields are not properly updated on the Contact records try first to clean the N26 cache:

Setup --> Platform Cache --> N26 --> Clear cache
