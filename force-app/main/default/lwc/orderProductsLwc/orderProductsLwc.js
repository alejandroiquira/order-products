import { LightningElement,wire,track,api} from 'lwc';  
  import {refreshApex} from '@salesforce/apex';  
  import getOrderProducts from '@salesforce/apex/ProductUtility.getOrderProductsList';  
  import activateOrder from '@salesforce/apex/ProductUtility.activateOrder';  
  import { ShowToastEvent } from 'lightning/platformShowToastEvent'
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
    
    activateOrder(){
        
      console.log("ActivateOrder1");
      activateOrder({orderid : this.recordId}).then(result=>
        {
          console.log("ActivateOrder2");
          this.showToast('Success', result, 'Success', 'dismissable');
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