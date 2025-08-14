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
        sendEmail(contrato.Id);
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
    
    public static void sendEmail(String recordId){
        try{
            Contrato__c contrato = [Select Name, Urbanizacion__r.Name, Proyecto__r.Name,
                                    Proyecto__r.CorreosVentaNueva__c, Cuenta__r.Name,
                                    Lote__r.Name, Manzana__r.Name, PrecioCotizado__c,
                                    toLabel(FormaPago__c), Owner.Name, FechaEntrega__c
                                    FROM Contrato__c where Id = :recordId];
            EmailTemplate plantilla = [SELECT Id, Subject, HtmlValue from EmailTemplate where DeveloperName = 'ContratoVentaNueva'];
            String subject = plantilla.Subject;
            String htmlBody = plantilla.HtmlValue;
            subject = subject.replace('{urbanizacion}', contrato.Urbanizacion__r.Name);
            subject = subject.replace('{proyecto}', contrato.Proyecto__r.Name);
            
            htmlBody = htmlBody.replace('{urbanizacion}', contrato.Urbanizacion__r.Name);
            htmlBody = htmlBody.replace('{manzana}', contrato.Manzana__r.Name);
            htmlBody = htmlBody.replace('{cliente}', contrato.Cuenta__r.Name);
            htmlBody = htmlBody.replace('{lote}', contrato.Lote__r.Name);
            htmlBody = htmlBody.replace('{contrato}', contrato.Name);
            htmlBody = htmlBody.replace('{valorContrato}', '$'+contrato.PrecioCotizado__c );
            htmlBody = htmlBody.replace('{fechaEmision}', System.now().format('dd/MM/YYYY'));
            htmlBody = htmlBody.replace('{formaPago}', contrato?.FormaPago__c);
            htmlBody = htmlBody.replace('{ejecutivoVenta}', contrato.Owner.Name);
            htmlBody = htmlBody.replace('{fechaEntrega}', DateTime.newInstance(contrato.FechaEntrega__c.year(), contrato.FechaEntrega__c.month(), contrato.FechaEntrega__c.day()).format('dd/MM/YYYY') );
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(contrato.Proyecto__r.CorreosVentaNueva__c.split(','));
            email.setSubject(subject);
            email.setHtmlBody(htmlBody); 
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            
            for (Messaging.SendEmailResult r : results) {
                System.debug('¿Enviado? ' + r.isSuccess());
                if (!r.isSuccess()) {
                    System.debug('Errores: ' + r.getErrors()[0].getMessage());
                }
            }
        }catch(exception ex){
            System.debug('Error: '+ex.getMessage() +', Línea: '+ex.getLineNumber());
        }
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