@isTest
public with sharing class availableProductLwc_Test {
 
    @TestSetup
    static void createTestData() {
        DataFactoryTest.createData();
    }
    
    @istest
    static void gePriceBookProductsTest(){
        Order o = [select pricebook2id, Status from order  limit 1];
        availableProductLwc.gePriceBookProducts(o.id);
    }

    @istest
    static void addProductsToOrderTest(){
        Order o = [select pricebook2id, Status from order  limit 1];

        list<PricebookEntry> pbeList=[SELECT Id, Product2.Name, UnitPrice, Product2Id From PricebookEntry where Pricebook2id=:o.pricebook2id];

        availableProductLwc.addProductsToOrder(pbeList, o.id);
    }

}