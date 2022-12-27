public with sharing class ProductUtility {

  
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
