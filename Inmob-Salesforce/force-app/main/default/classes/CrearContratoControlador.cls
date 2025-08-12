public class CrearContratoControlador {
    
    @AuraEnabled(cacheable=true)
    public static CotizacionWrapper getQuote(String recordId){
        CotizacionWrapper response = new CotizacionWrapper();
        response.cotizacion = [Select 
                               Id, CI_Cuenta__c, CI_Cuenta__r.Name, CI_Proyecto__c, CI_Proyecto__r.Name, 
                               Lote__c, Lote__r.Name, CI_Manzana__c, CI_Manzana__r.Name, 
                               CI_Etapa__c, CI_Etapa__r.Name, CI_Modelo__c, CI_Modelo__r.Name, 
                               Implantaci_n_Principal__c, Oportunidad__c, Oportunidad__r.OwnerId,
                               Institucion_Financiera__c, Forma_de_pago__c, Fecha_Cuota_Saldo__c
                               From Cotizacion__c
                               Where Id = :recordId];
        
        response.optionsTipo = getPicklistOptions('Contrato__c', 'Tipo__c');
        response.optionsEstados = getPicklistOptions('Contrato__c', 'Estado__c');
        return response;
    }
    
    
    @AuraEnabled
    public static String saveData(String jsonData){
        ResponsenWrapper response = (ResponsenWrapper) JSON.deserialize(jsonData, ResponsenWrapper.class);
        Cotizacion__c cotizacion = getQuote(response.recordId).cotizacion;
        Contrato__c contrato = new Contrato__c(Cotizacion__c = response.recordId);
        contrato.Oportunidad__c = cotizacion.Oportunidad__c;
        contrato.Cuenta__c = cotizacion.CI_Cuenta__c;
        contrato.Proyecto__c = cotizacion.CI_Proyecto__c;
        contrato.Urbanizacion__c = cotizacion.CI_Etapa__c;
        contrato.Implantacion__c = cotizacion.Implantaci_n_Principal__c;
        contrato.Lote__c = cotizacion.Lote__c;
        contrato.Manzana__c = cotizacion.CI_Manzana__c;
        contrato.OwnerId = cotizacion.Oportunidad__r.OwnerId;
        contrato.FechaEntrega__c = cotizacion.Fecha_Cuota_Saldo__c;
        contrato.Estado__c = response.estado;
        contrato.Tipo__c = response.tipo;
        contrato.FormaPago__c = cotizacion.Forma_de_pago__c;
        contrato.InstitucionFinanciera__c = cotizacion.Institucion_Financiera__c;
        contrato.OficialCredito__c = getOficial(contrato.Proyecto__c, 'Crédito');
        contrato.OficialCobranza__c = getOficial(contrato.Proyecto__c, 'Cobranza');
        insert contrato;
        update new Cotizacion__c(Id = contrato.Cotizacion__c, Estado__c = 'Vendido');
        update new Lote__c (Id = contrato.Lote__c, CI_Estado__c = 'V');
        update new Opportunity (Id = contrato.Oportunidad__c, Stagename = 'Vendida', Estado_de_Aprobacion__c = 'Aprobado', Estado_de_Venta__c ='Vendido');
        return contrato.Id;
    }
    
    
    public  static List<PicklistOption> getPicklistOptions(String objApiName, String fieldApiName){
        List<PicklistOption> lOptions = new List<PicklistOption>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objApiName);
        List<Schema.PicklistEntry> ple = objectType.getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry entry : ple)  {
            lOptions.add(new PicklistOption(entry.getValue(), entry.getLabel()));
        }
        return lOptions;
    }
    
    public static String getOficial(String proyecto, String tipo){
        String user;
        for(OficialesCreditoCobranzas__c item: [SELECT Oficial__c FROM OficialesCreditoCobranzas__c 
                                                WHERE Tipo__c =:tipo 
                                                AND Proyecto__c = :proyecto
                                                ORDER BY UltimoContratoAsignado__c ASC 
                                                LIMIT 1]){
            user = item.Oficial__c;
            item.UltimoContratoAsignado__c = System.now();
            update item;
        }
        return user;
    }
    
    
    public class ResponsenWrapper{
        @AuraEnabled public String recordId;
        @AuraEnabled public String estado;
        @AuraEnabled public String tipo;
    }
    
     public class CotizacionWrapper{
        @AuraEnabled public Cotizacion__c cotizacion;
        @AuraEnabled public List<PicklistOption> optionsTipo;
        @AuraEnabled public List<PicklistOption> optionsEstados;
    }
    
    public class PicklistOption{
        @AuraEnabled public String value;
        @AuraEnabled public String label;
        
        public PicklistOption(String value, String label){
            this.value = value;
            this.label = label;
        }
    }
    
    

}