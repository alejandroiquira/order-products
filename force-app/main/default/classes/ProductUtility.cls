public with sharing class ProductUtility {

    @AuraEnabled(cacheable=true)  
    public static List<PricebookEntry> getProductList(Id orderId){  
        
        Id pricebookId = getPricebookid(orderId);

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
        
        list<OrderItem> productsToUpsert = new list<OrderItem>();
        Map<Id, OrderItem> mapExistentProd = new Map<Id, OrderItem>();
        
        // Get current products related to the order
        for(OrderItem oi: [select id, Product2Id, Quantity from OrderItem where OrderId= :orderId]){
            if(!mapExistentProd.containsKey(oi.Product2Id))
                mapExistentProd.put(oi.Product2Id, oi);
        }
        System.debug('addProductsToOrder mapExistentProd:'+ mapExistentProd);

        // Check if products sent as parameter already exist in the order
        for(PricebookEntry p: productList){
            OrderItem oi;
            // If product already exist add 1 to quantity if not create a new order product
            if(mapExistentProd.containsKey(p.Product2id)){
                oi=mapExistentProd.get(p.Product2id);
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

    @AuraEnabled(cacheable=true)  
    public static List<OrderItem> getOrderProductsList(id orderid){  
        
        return [SELECT Id, Product2id, Product2.Name, Quantity, UnitPrice, TotalPrice
                From OrderItem 
                where OrderId = :orderid];  

    }
}
