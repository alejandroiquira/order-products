import { LightningElement,wire,track,api} from 'lwc';  
  import {refreshApex} from '@salesforce/apex';  
  import getOrderProducts from '@salesforce/apex/ProductUtility.getOrderProductsList'; 
  import getOrderProductsImperative from '@salesforce/apex/ProductUtility.getOrderProductsListImperative';   
  import activateOrder from '@salesforce/apex/ProductUtility.activateOrder';  
  import { ShowToastEvent } from 'lightning/platformShowToastEvent'
  import { subscribe,MessageContext } from 'lightning/messageService';
  import UPDATE_ORDER_PRODUCT_FILE from '@salesforce/messageChannel/updateOrderProducts__c';
  const COLS=[  
  {label:'Name',fieldName:'Product2.Name', type:'text'},   
  {label:'Quantity',fieldName:'Quantity', type:'number'}  ,   
  {label:'Unit Price',fieldName:'UnitPrice', type:'currency'}  ,   
  {label:'Total Price',fieldName:'TotalPrice', type:'currency'}  
  ];  

  export default class DataTableInLwc extends LightningElement {  
  
    @api recordId;
    cols=COLS;  
    products;


    @wire(getOrderProducts, {orderid: '$recordId'}) wireproductList (result){
      if(result.data){
          this.products=result.data;
      }
    };  

    counter =0;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.subscribeToMessageChannel();
    }
    subscribeToMessageChannel(){
        this.subscription = subscribe(
            this.messageContext,
            UPDATE_ORDER_PRODUCT_FILE,
            (message) => this.handleMessage(message)
        );
    }
    handleMessage(message){
        if(message.operator == 'add'){
            this.counter += message.constant;
            getOrderProductsImperative({orderid : this.recordId})
            .then(result=>{
              this.products= result;
              return refreshApex(this.products);  
            })
            .catch(error=>{
              alert('Error refreshing order product Added'+JSON.stringify(error));  
            });
            //return refreshApex(this.products);  
        }
    }
      
    activateOrder(){
        
      console.log("ActivateOrder1");
      activateOrder({orderid : this.recordId}).then(result=>
        {
          console.log("ActivateOrder2");
          this.showToast('Order activated. Please refresh the page.', result, 'Success', 'dismissable');
          //eval("$A.get('e.force:refreshView').fire();");
          this.updateRecordView();
        }
      ).catch(error=>{  
        alert('Error activating order'+JSON.stringify(error));  
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
  
    updateRecordView() {
      setTimeout(() => {
           eval("$A.get('e.force:refreshView').fire();");
      }, 1000); 
    }

 }