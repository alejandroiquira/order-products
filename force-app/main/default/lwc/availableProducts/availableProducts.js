import { LightningElement,wire,track,api} from 'lwc';  
 import {refreshApex} from '@salesforce/apex';  
 import getProducts from '@salesforce/apex/ProductUtility.getProductList';  
 const COLS=[  
   {label:'Name',fieldName:'Product2.Name', type:'text'},   
   {label:'Price',fieldName:'UnitPrice', type:'currency'}  
 ];  
 export default class DataTableInLwc extends LightningElement {  
   @api recordId;
   cols=COLS;  
   products;

   @wire(getProducts,{orderId: '$recordId'}) productList (result){
    if(result.data){
      this.products=result.data;
      console.log("productlist:"+result.data);
      console.dir(result.data);
    }
     
   };  

 
 }  