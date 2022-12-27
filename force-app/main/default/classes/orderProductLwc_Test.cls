@isTest 
public with sharing class orderProductLwc_Test {

        @TestSetup
        static void createTestData() {
            DataFactoryTest.createData();
        }
        
        @istest
        static void getInitialProductsListTest(){
            Order o = [select pricebook2id, Status from order  limit 1];
            orderProductLwc.getInitialProductsList(o.id);
        }

        @istest
        static void getOrderProductsListImperativetTest(){
            Order o = [select pricebook2id, Status from order  limit 1];
            orderProductLwc.getOrderProductsListImperative(o.id);
        }

        @istest
        static void activateOrderTest(){
            Order o = [select pricebook2id, Status from order  limit 1];
            orderProductLwc.activateOrder(o.id);
        }
  
}