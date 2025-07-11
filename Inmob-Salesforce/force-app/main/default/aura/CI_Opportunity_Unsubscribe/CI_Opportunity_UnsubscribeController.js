({
	setDefaults : function(component, event, helper) {
        component.find("Etapa").set("v.value", "No negociada");
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Registro actualizado!",
            "message": "La oportunidad ha sido dado de baja."
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})