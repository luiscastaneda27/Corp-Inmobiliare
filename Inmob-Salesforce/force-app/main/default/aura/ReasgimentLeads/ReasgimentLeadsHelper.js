({
	getleadsuser: function(component,next,prev,offset,recordsshow) { 
    component.set('v.showSpinner', true);    
	offset = offset || 0;
    recordsshow = recordsshow || 10; 
       var seleccion=component.get("v.userorigen");
       var uorigen= component.get("v.usuarios")[component.get("v.userorigen")]; 
        var action = component.get('c.getleadsuser');
            action.setParams({
            "next" : next,
            "prev" : prev,
            "off" : offset,
            "recordsshow" :recordsshow,
            "iduser": uorigen.Id   
            })
    	var self = this;
        action.setCallback(this, function(actionResult) {
        var result=actionResult.getReturnValue();
        console.log(result);    
        component.set('v.offset',result.offst);
    	component.set('v.next',result.hasnext);
    	component.set('v.prev',result.hasprev);
    	component.set('v.lstLeads', result.lstLeads);
    	component.set('v.totalleads', result.total);
        component.set('v.showSpinner', false);    
        });
       $A.enqueueAction(action);
	},
    updateasignacion : function(component, event, helper,idlead,selectedRec) { 
    component.set('v.showSpinner', true);    
    var action = component.get("c.UpdateAsignacion");
        action.setParams({
            'idlead': idlead,
            'asignacion':selectedRec
        });
        action.setCallback(this, function(response) {
           component.set('v.showSpinner', false); 
        });
       $A.enqueueAction(action);
    },
    updateasignacionMass : function(component, event, helper,idleads,selectedRec) {
    component.set('v.showSpinner', true);    
    var action = component.get("c.UpdateAsignacionMass");
        action.setParams({
            'idleads': idleads,
            'asignacion':selectedRec
        });
        action.setCallback(this, function(response) {
            component.set('v.showSpinner', false);
        });
       $A.enqueueAction(action);
    },
    changeowner : function(component, event, idsejecutivos) {
        var seleccion=component.get("v.userorigen");
        var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];
        var action = component.get("c.Changeowner");
        action.setParams({
            'idejecutivos': idsejecutivos,
            'idusuario':uorigen.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
				var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Operación exitosa',
                    message: 'Recibirá un correo electrónico cuando el proceso finalice',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get("e.force:refreshView").fire();
            }            
        });
        $A.enqueueAction(action);
	},
    changeownerall: function(component, event, idsejecutivos) {
        var seleccion=component.get("v.userorigen");
        var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];
        var action = component.get("c.ChangeownerMass");
        action.setParams({
            'idejecutivos': idsejecutivos,
            'idusuario':uorigen.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
				var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Operación exitosa',
                    message: 'Recibirá un correo electrónico cuando el proceso finalice',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                $A.get("e.force:refreshView").fire();
              }            
        });
        $A.enqueueAction(action);
    }  
})