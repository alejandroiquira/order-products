public with sharing class orderProductLwc {

    //method used for wire adaptar when the page is loaded.
    @AuraEnabled(cacheable=true)  
    public static List<orderProductWrapper> getInitialProductsList(id orderid){  
        
        system.debug('getOrderProductsList orderId:'+orderId);
        list<orderProductWrapper> oiWrapperList = getOrderProductsList(orderId);
        return oiWrapperList;
    }

    //method used in an imperative way when order products table is refreshed from available products Component
    @AuraEnabled 
    public static List<orderProductWrapper> getOrderProductsListImperative(id orderid){  
        
        list<orderProductWrapper> oiWrapperList = getOrderProductsList(orderId);
        return oiWrapperList;
    }

   public static List<orderProductWrapper> getOrderProductsList(id orderid){  
       
       system.debug('getOrderProductsList orderId:'+orderId);
       list<orderProductWrapper> oiWrapperList = new list<orderProductWrapper>();
       for ( OrderItem oi: [SELECT Id, Product2id, Product2.Name, Quantity, UnitPrice, TotalPrice
                                   From OrderItem where OrderId = :orderid]  ){

           oiWrapperList.add(new orderProductWrapper(oi));
       }
       system.debug('getOrderProductsList oiWrapperList:'+oiWrapperList);
       return oiWrapperList;
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

    public class orderProductWrapper{
        @AuraEnabled
        public OrderItem oi;
        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String productLink;
        @AuraEnabled
        public decimal Quantity;
        @AuraEnabled
        public decimal UnitPrice;
        @AuraEnabled
        public decimal TotalPrice;

        public orderProductWrapper(OrderItem oi){

            this.oi = oi;
            this.Id = oi.Id;
            this.Name = oi.Product2.Name;
            this.productLink = '/' + oi.Id;
            this.Quantity = oi.Quantity;
            this.UnitPrice = oi.UnitPrice;
            this.TotalPrice = oi.TotalPrice;
        }

    }

}
