({
	cargarusers : function(component, event, helper) {
        component.set('v.showSpinner', true); 
        var action = component.get("c.Getusers");
        action.setCallback(this, function(data) {
                component.set("v.usuarios", data.getReturnValue());
         component.set('v.showSpinner', false);    
         });                  
       $A.enqueueAction(action);		
	},
    loadoffers: function(component, event, helper) {
       var seleccion=component.get("v.userorigen");
       var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];
        if(seleccion!='Seleccione'){
            var next = false;
            var prev = false;
            helper.getleadsuser(component,next,prev);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Favor Revisar',
                    message: 'Seleccione un usuario',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
        }
     },
    OnNext:function(component,event,helper){ 
        component.find("selectalloffers").set("v.value", false);
		var next = true;
		var prev = false;
		var offset = component.get("v.offset");
		var recordsshow= component.get("v.recordstoshow");     
		helper.getleadsuser(component,next,prev,offset,recordsshow);
    },
    OnPrevious:function(component,event,helper){
        component.find("selectalloffers").set("v.value", false);
		var next = false;
		var prev = true;
		var offset = component.get("v.offset");
		var recordsshow= component.get("v.recordstoshow");         
		helper.getleadsuser(component,next,prev,offset,recordsshow); 
	},
    selectAllUser: function(component, event, helper) {
     var selectedHeaderCheck = event.getSource().get("v.value");        
     var getAllId = component.find("boxoneone");    
     var objuser = component.get('v.ejecutivosagreg'); 
        if (selectedHeaderCheck == true) {
        for (var i = 0; i < getAllId.length; i++) {
  		  component.find("boxoneone")[i].set("v.value", true);
          objuser.push(component.find("boxoneone")[i].get("v.text"));  
   		  component.set("v.ejecutivosel", getAllId.length);
        }
        component.set('v.ejecutivosagreg', objuser);    
        } else {
          for (var i = 0; i < getAllId.length; i++) {
             var idselfalse = objuser.indexOf(component.find("boxoneone")[i].get("v.text"));
			 objuser.splice(idselfalse, 1); 
    		 component.find("boxoneone")[i].set("v.value", false);
   			 component.set("v.ejecutivosel", 0);
  	    }
        component.set('v.ejecutivosagreg', objuser);    
       }  
  },
    checkboxSelectUser: function(component, event, helper) {
  var selectedRec = event.getSource().get("v.value");
  var getSelectedNumber = component.get("v.ejecutivosel");
  var objuser = component.get('v.ejecutivosagreg');  
  var idseleccionado = event.getSource().get("v.text");       
     if (selectedRec == true) {
         getSelectedNumber++;
         objuser.push(idseleccionado);  
     } else {
         var pos = objuser.indexOf(idseleccionado);
	     objuser.splice(pos, 1); 
         getSelectedNumber--;
     }
   component.set('v.ejecutivosagreg', objuser);   
   component.set("v.ejecutivosel", getSelectedNumber);
  },
    selectalloffers: function(component, event, helper) {
     var selectedHeaderCheck = event.getSource().get("v.value");        
     var getAllId = component.find("boxofferoneone");
     var registrostotal=0;  
     var getSelectedNumber = component.get("v.ofertaselect"); 
     var objs = component.get('v.idsagregados');    
     var leadsactuales =[];
     var leadsactualesfalse =[];   
        if (selectedHeaderCheck == true) {
        for (var i = 0; i < getAllId.length; i++) {
         var idseltrue = objs.indexOf(component.find("boxofferoneone")[i].get("v.text"));
            if(idseltrue<0){     
             component.find("boxofferoneone")[i].set("v.value", true);         
             registrostotal=registrostotal+1;   
             objs.push(component.find("boxofferoneone")[i].get("v.text"));   
          }
          leadsactuales.push(component.find("boxofferoneone")[i].get("v.text"));    
        }
        getSelectedNumber=registrostotal+getSelectedNumber;    
        component.set("v.ofertaselect", getSelectedNumber);      
        component.set('v.idsagregados', objs);
        helper.updateasignacionMass(component, event, helper,leadsactuales,'true');    
            
        } 
	  else{
          for (var i = 0; i < getAllId.length; i++) {
			  var idselfalse = objs.indexOf(component.find("boxofferoneone")[i].get("v.text"));
              if(idselfalse>=0){     
			   objs.splice(idselfalse, 1);
    		   component.find("boxofferoneone")[i].set("v.value", false);
               registrostotal=registrostotal+1;      
              }        
           leadsactualesfalse.push(component.find("boxofferoneone")[i].get("v.text"));   
  	       }
            component.set('v.idsagregados', objs);
			helper.updateasignacionMass(component, event, helper,leadsactualesfalse,'false');          
            if(getSelectedNumber>=0){ 
              getSelectedNumber=getSelectedNumber-registrostotal;    
              component.set("v.ofertaselect", getSelectedNumber);      
            }     
       } 
 },
    checkboxSelectOffer: function(component, event, helper) {  
      var selectedRec = event.getSource().get("v.value");
      var getSelectedNumber = component.get("v.ofertaselect");
      var totalofertas = component.get("v.totalleads");   
      var idseleccionado = event.getSource().get("v.text");   
      var objs = component.get('v.idsagregados');
         if (selectedRec == true) {
             var idseltrue = objs.indexOf(idseleccionado);
             if(idseltrue<0){
                 getSelectedNumber++;
                 objs.push(idseleccionado);
                 component.set('v.idsagregados', objs); 
             }    
             helper.updateasignacion(component, event, helper,idseleccionado,selectedRec);
         } else {
             getSelectedNumber--;  
             var pos = objs.indexOf(idseleccionado);
             objs.splice(pos, 1);
             helper.updateasignacion(component, event, helper,idseleccionado,selectedRec);
         }        
        if(getSelectedNumber>=0){  
              component.set("v.ofertaselect", getSelectedNumber);   
       }       
 	},
    ChangeOwner: function(component, event, helper) {
   //component.set("v.HideSpinner", true);   
   var objclientes = component.get('v.idsagregados');      
   var objuser = component.get('v.ejecutivosagreg');
     if(objclientes.length>0 && objuser.length>0){
       helper.changeowner(component,event,objuser); 
       //setTimeout(function(){ component.set("v.HideSpinner", false);  }, 1000);   
     }
     else{
         //setTimeout(function(){ component.set("v.HideSpinner", false);  }, 1000);
         
         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Favor Revisar',
                    message: 'Seleccionar una oferta y un usuario destino al menos',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
     }  
 },
    asignarall: function(component, event, helper) { 
         var objuser = component.get('v.ejecutivosagreg');
         if(objuser.length>0){
           helper.changeownerall(component,event,objuser);         
         }   
         else{
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Favor Revisar',
                    message: 'Seleccionar un usuario destino al menos',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
        }
    },  
})