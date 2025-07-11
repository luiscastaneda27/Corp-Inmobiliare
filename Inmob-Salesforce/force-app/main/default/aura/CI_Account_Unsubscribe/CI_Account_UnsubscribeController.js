({
    /*handleClick: function(cmp, event, helper) {
        cmp.find('field').forEach(function(f) {
            f.reset();
        });
    },*/
    setDefaults : function(component, event, helper) {
        component.find("Estado").set("v.value", "Dado de Baja");
    },
    handleSuccess: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Registro actualizado!",
            "message": "La cuenta ha sido dado de baja."
        });
        toastEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})