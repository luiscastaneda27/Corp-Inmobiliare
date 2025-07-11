({
    getCampos : function(component, event, helper) {
        var recordId = component.get("v.recordId");
		var action = component.get("c.camposCotizacion");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(data) {           
            var data = JSON.parse(data.getReturnValue());
            console.log('Datos del arreglo :'+data);
            component.set("v.Preferencial", data.Preferencial); 
            component.set("v.Aprobada", data.Aprobada);
            
            if(data.Preferencial==false && data.Aprobada==false){
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/apex/CI_Formato_Cotizacion?id="+recordId,
                    "isredirect": "true"
                });
                urlEvent.fire();
            } else if(data.Preferencial==true && data.Aprobada==true) {
            	var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/apex/CI_Formato_Cotizacion?id="+recordId,
                    "isredirect": "true"
                });
                urlEvent.fire();    
            } else if(data.Preferencial==true && data.Aprobada==false) {
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "No se puede generar el PDF.",
                    "message": "La Cotización Preferencial aún no ha sido aprobada."
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            
        });
        $A.enqueueAction(action);        
	}
})