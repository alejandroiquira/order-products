 import { LightningElement,wire,track,api} from 'lwc';  
 import {refreshApex} from '@salesforce/apex';  
 import gePriceBookProducts from '@salesforce/apex/availableProductLwc.gePriceBookProducts';  
 import addProductsToOrder from '@salesforce/apex/availableProductLwc.addProductsToOrder';  
 import { ShowToastEvent } from 'lightning/platformShowToastEvent'
 import {publish,MessageContext} from 'lightning/messageService';
 import UPDATE_ORDER_PRODUCT_FILE from '@salesforce/messageChannel/updateOrderProducts__c';
 
 const COLS=[ 
    {label : 'Product Name',fieldName : 'productLink',type : 'url',
        typeAttributes :{
            label : {fieldName : 'Name'},
            target : '_blank'
        }
    },  
    {label:'Price',fieldName:'UnitPrice', type:'currency'}  
 ];  

 export default class DataTableInLwc extends LightningElement {
    @api recordId;
    cols=COLS;  
    products;

    @wire(MessageContext)
    messageContext;
  
    @wire(gePriceBookProducts,{orderId: '$recordId'}) productList (result){
      if(result.data){
        this.products=result.data;
        console.log("productlist:"+result.data);
        console.dir(result.data);
      }
    };  
   
    searchKey ='';
    handleOnChange(event){
        let key=event.target.value;
        console.log("Search key recordId:"+this.recordId);
        
      }

    addProducts(){  
      console.log("addProducts"+this.recordId);
      var selectedRecords =  
        this.template.querySelector("lightning-datatable").getSelectedRows();  
        addProductsToOrder({productList: selectedRecords, orderId: this.recordId})  
        .then(result=>{  
            console.log("addProducts selectedRecords",selectedRecords);
            const payload ={
              productAddedMessage :'Product Added'
          };
          console.log("addProducts2");
          publish(this.messageContext,UPDATE_ORDER_PRODUCT_FILE,payload);
          this.showToast('Products added to the order.', result, 'Success', 'dismissable');
          console.log("addProducts3");
        
      })
      .catch(error=>{
        //alert('Error adding products to the Order'+JSON.stringify(error)); 
        this.showToast('Error Adding products:', error.body.message, 'error', 'dismissable'); 
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