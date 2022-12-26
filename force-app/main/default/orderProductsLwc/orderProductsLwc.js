import { LightningElement,wire,track,api} from 'lwc';  
  import {refreshApex} from '@salesforce/apex';  
  import getOrderProducts from '@salesforce/apex/ProductUtility.getOrderProductsList';  
  const COLS=[  
  {label:'Name',fieldName:'Product2.Name', type:'text'},   
  {label:'Quantity',fieldName:'Quantity', type:'currency'}  ,   
  {label:'Unit Price',fieldName:'UnitPrice', type:'currency'}  ,   
  {label:'Total Price',fieldName:'TotalPrice', type:'currency'}  
  ];  

  export default class DataTableInLwc extends LightningElement {  
  @api recordId;
  cols=COLS;  
  products;
  listaproductos =[];

  @wire(getOrderProducts, {orderid: '$recordId'}) wireproductList (result){
    if(result.data){
        this.products=result.data;
    }
    
  };  


  
  renderedCallback() {
    console.log ("renderedCallback Record Id:"+ this.recordId);
    getOrderProducts ({orderid:this.recordId}).then (result =>
        {
            console.log ("Result UnitPrice:"+result[0].UnitPrice);
            let items=[];
            var orderProductsList = result;

            console.log ("orderProductsList.length:"+orderProductsList.length);
            /*
            for (let i=0; i< orderProductsList.length; i++ )
            {
                var item ={
                    
                label:'ID',fieldName:'Id.Name', type:'text', value:   orderProductsList[i].Id,
                label:'Name',fieldName:'Product2.Name', type:'text', value:   orderProductsList[i].Product2,
                label:'Quantity',fieldName:'Quantity', type:'currency', value:   orderProductsList[i].Quantity,   
                label:'Unit Price',fieldName:'UnitPrice', type:'currency', value:   orderProductsList[i].UnitPrice,
                label:'Total Price',fieldName:'TotalPrice', type:'currency', value:   orderProductsList[i].TotalPrice    
                }
                items.push(item);
                console.log("Item"+ orderProductsList[i].Id);
            }
            console.dir (items);
            this.listaproductos= items;
            console.dir (result);
            */
            //this.products=result;
            }
        );    
    }

    
    activateOrder(evt){
        
        
    };
  
 }  