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
            helper.getppsuser(component,next,prev);
        }
        else{
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Favor Revisar',
                    message: 'Seleccione un usuario origen',
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
		helper.getppsuser(component,next,prev);
    },
    OnPrevious:function(component,event,helper){
        component.find("selectalloffers").set("v.value", false);
		var next = false;
		var prev = true;
		var offset = component.get("v.offset");         
		helper.getppsuser(component,next,prev); 
	},
     validausuariodestino: function(component, event, helper) {
     var seleccionorigen=component.get("v.userorigen");   
     var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];   
     var udestino= component.get("v.usuarios")[component.get("v.userdestino")];  
       if(seleccionorigen!='Seleccione' && typeof(udestino) != "undefined" ){ 
        if(uorigen.Id==udestino.Id){
             component.set("v.userdestino",'Seleccione');
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Favor Revisar',
                    message: 'La reasignación no puede ser realizada sobre el mismo usuario',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire(); 				           
        }
        else{
            console.log('usuario valido');
        }
       }     
    },
    selectalloffers: function(component, event, helper) {
     var selectedHeaderCheck = event.getSource().get("v.value");        
     var getAllId = component.find("boxofferoneone");
     var registrostotal=0;  
     var getSelectedNumber = component.get("v.ofertaselect"); 
     var objs = component.get('v.idsagregados');    
     var oppactuales =[];
     var oppsactualesfalse =[];   
        if (selectedHeaderCheck == true) {
        for (var i = 0; i < getAllId.length; i++) {
         var idseltrue = objs.indexOf(component.find("boxofferoneone")[i].get("v.text"));
            if(idseltrue<0){     
             component.find("boxofferoneone")[i].set("v.value", true);         
             registrostotal=registrostotal+1;   
             objs.push(component.find("boxofferoneone")[i].get("v.text"));   
          }
          oppactuales.push(component.find("boxofferoneone")[i].get("v.text"));    
        }
        getSelectedNumber=registrostotal+getSelectedNumber;    
        component.set("v.ofertaselect", getSelectedNumber);      
        component.set('v.idsagregados', objs);
        helper.updateasignacionMass(component, event, helper,oppactuales,'true');    
            
        } 
	  else{
          for (var i = 0; i < getAllId.length; i++) {
			  var idselfalse = objs.indexOf(component.find("boxofferoneone")[i].get("v.text"));
              if(idselfalse>=0){     
			   objs.splice(idselfalse, 1);
    		   component.find("boxofferoneone")[i].set("v.value", false);
               registrostotal=registrostotal+1;      
              }        
           oppsactualesfalse.push(component.find("boxofferoneone")[i].get("v.text"));   
  	       }
            component.set('v.idsagregados', objs);
			helper.updateasignacionMass(component, event, helper,oppsactualesfalse,'false');          
            if(getSelectedNumber>=0){ 
              getSelectedNumber=getSelectedNumber-registrostotal;    
              component.set("v.ofertaselect", getSelectedNumber);      
            }     
       } 
 },
    checkboxSelectOffer: function(component, event, helper) {  
      var selectedRec = event.getSource().get("v.value");
      var getSelectedNumber = component.get("v.ofertaselect");
      var totalofertas = component.get("v.totallstOpps");   
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
    var objclientes = component.get('v.idsagregados'); 
    var udestino= component.get("v.usuarios")[component.get("v.userdestino")];      
     if(objclientes.length>0 && typeof(udestino) != "undefined"){
       helper.changeowner(component,event,udestino.Id); 
     }
     else{         
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
         var udestino= component.get("v.usuarios")[component.get("v.userdestino")];
         if(typeof(udestino) != "undefined"){
           helper.changeownerall(component,event,udestino.Id);         
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