({
    /*doInit : function(component, event, helper) {
        var leadId = component.get("v.recordId");
        var action = component.get("c.changeOwnerMethod");
        action.setParams({
            leadId : leadId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
             //console.log("El propietario del Prospecto cambio a su Jefe inmediato");
             var rec = response.getReturnValue();
             //console.log(rec.OwnerId);
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
    },*/
	setDefaults : function(component, event, helper) {
        component.find("Estado").set("v.value", "Dado de Baja");
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Registro actualizado!",
            "message": "El prospecto ha sido dado de baja."
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})