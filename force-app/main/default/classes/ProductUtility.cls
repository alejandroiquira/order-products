public with sharing class ProductUtility {

  
    @AuraEnabled(cacheable=true)  
    public static List<availableProductWrapper> gePriceBookProducts(Id orderId){  
        
        Id pricebookId = getPricebookid(orderId);
        list<availableProductWrapper> apWrapperList = new list<availableProductWrapper>();
        for ( PricebookEntry pbE: [SELECT Id, Product2.Name, UnitPrice, Product2Id From PricebookEntry 
                                      where Pricebook2id=:pricebookId limit 50]  ){

            apWrapperList.add(new availableProductWrapper(pbE));
        }
        return apWrapperList;
    }

    @AuraEnabled
    public static List<PricebookEntry> searchPriceBookProducts(Id orderId){  
        
        System.debug('getPriceBookProducts orderid'+orderId);
        Id pricebookId = getPricebookid(orderId);
        System.debug('getPriceBookProducts pricebookId'+pricebookId);
        return [SELECT Id, Product2.Name, UnitPrice, Product2Id
                From PricebookEntry 
                where Pricebook2id=:pricebookId
                limit 4];  
    }

    // Returns Order's pricebookId. If it does not have yet, return Standar pricebook Id
    public static Id getPricebookid(Id orderId){  

        Order o = [select pricebook2id  from order where id=: orderID];
        Id pricebookId = o.pricebook2id;
        System.debug('Pricebookid:'+pricebookId);

        if ( pricebookId==null){
            pricebookId = [Select id from pricebook2 where Pricebook2.IsStandard=true LIMIT 1].Id;
        }
        System.debug('Pricebookid2:'+pricebookId);

        return pricebookId;
    }
     
    @AuraEnabled
    public static void addProductsToOrder(List<PricebookEntry> productList, Id orderId){  
         
        System.debug('addProductsToOrder productList:'+ productList);
        System.debug('addProductsToOrder orderId:'+ orderId);

        Order o = [select pricebook2id  from order where id=: orderID];

        if(o.pricebook2id==null){
            o.pricebook2id = getPricebookid(orderId);
            update o;
        }
        
        
        list<OrderItem> productsToUpsert = new list<OrderItem>();
        
        // Get current products related to the order
        Map<Id, OrderItem> mapExistentProd = new Map<Id, OrderItem>();
        for(OrderItem oi: [select id, Product2Id, Quantity,PricebookEntryId from OrderItem where OrderId= :orderId]){
            if(!mapExistentProd.containsKey(oi.PricebookEntryId))
                mapExistentProd.put(oi.PricebookEntryId, oi);
        }
        System.debug('addProductsToOrder mapExistentProd:'+ mapExistentProd);

        // Check if products sent as parameter already exist in the order
        for(PricebookEntry p: productList){
            OrderItem oi;
            // If product already exist add 1 to the current quantity value if not create a new order product
            if(mapExistentProd.containsKey(p.id)){
                oi=mapExistentProd.get(p.id);
                oi.Quantity+=1;
                System.debug('addProductsToOrder exist oi:'+ oi);
            }else{
                oi=new OrderItem(orderid=orderId, Product2id=p.Product2id, Quantity=1, UnitPrice=p.UnitPrice, PricebookEntryId= p.id);
                System.debug('addProductsToOrder NO exist oi:'+ oi);
            }
            productsToUpsert.add(oi);
        } 
        System.debug('addProductsToOrder productsToInsert:'+ productsToUpsert);
        upsert productsToUpsert;

    }  

    public class availableProductWrapper{
        @AuraEnabled
        public PricebookEntry pbe;
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String productLink;
        @AuraEnabled
        public decimal UnitPrice;

        public availableProductWrapper(PricebookEntry pbe){

            this.pbe = pbe;
            this.Id = pbe.id;
            this.Name = pbe.Product2.Name;
            this.productLink = '/' + pbe.Id;
            this.UnitPrice = pbe.UnitPrice;
        }

    }
}
