public with sharing class DataFactoryTest {
    
    public static void createData(){
        Account acc = new account(name ='Test Account');
        insert acc;

        Contract c = new Contract (AccountId=acc.id, StartDate=System.today() + 3, ContractTerm=12, Status='Draft');
        insert c;

        Id pricebookId = Test.getStandardPricebookId();

        Order o = new Order (AccountId=acc.id, ContractId=c.id, Status='Draft', EffectiveDate=System.today() + 10, pricebook2Id=pricebookId);
        insert o;
       
        Product2 prod1 = new Product2(Name = 'Laptop X200', Family = 'Hardware');
        insert prod1;
        Product2 prod2 = new Product2(Name = 'Laptop X200', Family = 'Hardware');
        insert prod2;
                    
        PricebookEntry pbEntry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id, UnitPrice = 10000, IsActive = true);
        insert pbEntry1;
        
        PricebookEntry pbEntry2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true);
        insert pbEntry2;
        
        OrderItem oi=new OrderItem(orderid=o.id, Product2id=pbEntry1.product2Id, Quantity=1, UnitPrice=500, PricebookEntryId= pbEntry1.id);
        insert oi;
        
    }
    


}
