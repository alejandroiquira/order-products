import { LightningElement,wire,track,api} from 'lwc';  
 import {refreshApex} from '@salesforce/apex';  
 import getProducts from '@salesforce/apex/ProductUtility.getProductList';  
 import addProductsToOrder from '@salesforce/apex/ProductUtility.addProductsToOrder';  
 import { ShowToastEvent } from 'lightning/platformShowToastEvent'
 import {publish,MessageContext} from 'lightning/messageService';
 import UPDATE_ORDER_PRODUCT_FILE from '@salesforce/messageChannel/updateOrderProducts__c';
 
 const COLS=[  
   {label:'Name',fieldName:'Product2.Name', type:'text'},   
   {label:'Price',fieldName:'UnitPrice', type:'currency'}  
 ];  

 export default class DataTableInLwc extends LightningElement {  
    @api recordId;
    cols=COLS;  
    products;

    @wire(MessageContext)
    messageContext;
  
    @wire(getProducts,{orderId: '$recordId'}) productList (result){
      if(result.data){
        this.products=result.data;
        console.log("productlist:"+result.data);
        console.dir(result.data);
      }
    };  

    addProducts(){  
      console.log("addProducts"+this.recordId);
      var selectedRecords =  
        this.template.querySelector("lightning-datatable").getSelectedRows();  
        addProductsToOrder({productList: selectedRecords, orderId: this.recordId})  
        .then(result=>{  
          console.log("addProducts selectedRecords"+selectedRecords[0]);
          console.dir(selectedRecords);
          const payload ={
              operator :'add',
              constant:1
        };
        publish(this.messageContext,UPDATE_ORDER_PRODUCT_FILE,payload);
        this.showToast('Products added to the order.', result, 'Success', 'dismissable');
        return refreshApex(this.products);  
      })  
      .catch(error=>{  
        alert('Error getting Available products'+JSON.stringify(error));  
      })  
    }  

   
    showToast(title, message, variant, mode) {
      const event = new ShowToastEvent({
          title: title,
          message: message,
          variant: variant,
          mode: mode
      });
      this.dispatchEvent(event);
    }

 }  