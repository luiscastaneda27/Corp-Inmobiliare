({
	getppsuser: function(component,next,prev,offset,recordsshow) { 
    component.set('v.showSpinner', true);    
	offset = offset || 0;
    recordsshow = recordsshow || 10; 
       var seleccion=component.get("v.userorigen");
       var uorigen= component.get("v.usuarios")[component.get("v.userorigen")]; 
        var action = component.get('c.getopportunitiesbysuser');
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
    	component.set('v.lstOpps', result.lstOpps);
    	component.set('v.totallstOpps', result.totalOP);
        component.set('v.showSpinner', false);   
        });
       $A.enqueueAction(action);
	},
    updateasignacion : function(component, event, helper,idopp,selectedRec) { 
    component.set('v.showSpinner', true);    
    var action = component.get("c.UpdateAsignacionOpp");
        action.setParams({
            'idopp': idopp,
            'asignacion':selectedRec
        });
        action.setCallback(this, function(response) {
           component.set('v.showSpinner', false); 
        });
       $A.enqueueAction(action);
    },
    updateasignacionMass : function(component, event, helper,idopps,selectedRec) {
    component.set('v.showSpinner', true);    
    var action = component.get("c.UpdateAsignacionMassOpp");
        action.setParams({
            'idopps': idopps,
            'asignacion':selectedRec
        });
        action.setCallback(this, function(response) {
            component.set('v.showSpinner', false);
        });
       $A.enqueueAction(action);
    },
    changeowner : function(component, event, idsejecutivos) {
        component.set('v.showSpinner', true);
        var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];
        var udestino= component.get("v.usuarios")[component.get("v.userdestino")];
        var action = component.get("c.ChangeownerOpp");
        action.setParams({
            'userorigen': uorigen.Id,
            'userdestino':udestino.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.showSpinner', false);
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
        component.set('v.showSpinner', true);
        var uorigen= component.get("v.usuarios")[component.get("v.userorigen")];
        var udestino= component.get("v.usuarios")[component.get("v.userdestino")];
        var action = component.get("c.ChangeownerMassOpp");
        action.setParams({
            'userorigen': uorigen.Id,
            'userdestino':udestino.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.showSpinner', false);
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