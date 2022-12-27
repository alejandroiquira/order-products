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
     

    @AuraEnabled(cacheable=true)  
    public static List<OrderItem> getOrderProductsList(id orderid){  
        
        return [SELECT Id, Product2id, Product2.Name, Quantity, UnitPrice, TotalPrice
                From OrderItem 
                where OrderId = :orderid];  

    }

    @AuraEnabled
    public static void activateOrder(id orderid){  

        system.debug('activateOrder orderid:'+orderid);
        Order o =[select id, ContractId, Status from order where id=:orderid];
        Contract c = [select id, status from contract where id = :o.ContractId];
        
        if(c.status != 'Activated'){
            c.status='Activated';
            update c;
        }
        system.debug('activateOrder Contract updated:'+c);

        o.status='Activated';        
        update o;

    }

}
