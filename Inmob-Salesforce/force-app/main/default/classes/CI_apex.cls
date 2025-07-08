public without sharing class CI_apex {
    
    String id = ApexPages.currentPage().getParameters().get('id');
    public String idInmueble{get;set;}
    public String img_FA{get;set;}
    public String img_PB{get;set;}
    public String img_PA{get;set;}
    public Decimal saldoPorcent{get;set;}
    
    public Decimal sumAdicionales{get;set;}
    
    public Decimal TotalVenta{get;set;}
    public List<EspecificacionTecnica__c> especificacionesTecnicas { get; set; }
    
    public CI_apex(ApexPages.StandardController controller) { 
        id = controller.getid();
        Cotizacion__c cotizacion = [Select Id, Name,Porcentaje_Cuota_Entrada__c, Modelo__c,CI_Modelo__c, Precio_Venta__c, Implantaci_n_Principal__r.Lote__c, Implantaci_n_Principal__r.Modelo__c from Cotizacion__c where id =: id Limit 1]; 
        AggregateResult[] groupedResults = [Select Sum(Valor_Promocion__c) sum From Detalle_Promocion__c Where Cotizacion__c =: id and Valor_Promocion__c>0];
        sumAdicionales = 0.00;
        saldoPorcent = 100 - cotizacion.Porcentaje_Cuota_Entrada__c;
        if((decimal)groupedResults[0].get('sum')>0) {
            sumAdicionales = (decimal)groupedResults[0].get('sum');
        }
        TotalVenta = cotizacion.Precio_Venta__c + sumAdicionales; 
        
        Modelo__c modelo = [Select id, name from Modelo__c where id =: cotizacion.Implantaci_n_Principal__r.Modelo__c];   
        idInmueble = idInmueble = modelo.Id;
        List<Id> docIds = new List<Id>();
        for(ContentDocumentLink cdl: [Select Id, ContentDocumentId, ContentDocument.Title From ContentDocumentLink where LinkedEntityId = :cotizacion.CI_Modelo__c]){
            String title = cdl.ContentDocument.Title;
            if(title.contains('_PB') || title.contains('_PA') || title.contains('_FA')){
                docIds.add(cdl.ContentDocumentId);
            }
        }
        for(ContentVersion cv: [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :docIds AND IsLatest = true]){
            img_FA = cv.Title.contains('_FA') ? cv.Id : img_FA;
            img_PB = cv.Title.contains('_PB') ? cv.Id : img_PB;
            img_PA = cv.Title.contains('_PA') ? cv.Id : img_PA;
        }
        loadPayments();
    }
    private void loadPayments() {
        Cotizacion__c cot = [Select Id, Lote__c, Lote__r.CI_Modelo_Casa__c, CI_Modelo__c from Cotizacion__c Where Id = :Id];
        especificacionesTecnicas = [Select Caracteristica__r.Name, Descripcion__c from EspecificacionTecnica__c WHERE Modelo__c = :cot.CI_Modelo__c and MostrarCotizacion__c = true];
    }
    public PageReference updateValue() {
        
        List<Lead> leads = [select id, name, CI_Correo_Validado__c from Lead where id = :id and CI_Correo_Validado__c = false];   
        if(leads.size() > 0) {
            leads[0].CI_Correo_Validado__c = true;
            update leads;
        }
        return null;
        
    }
    
    public PageReference updateCotizacion() {
        
        List<Cotizacion__c> cotiza = [select Id, name, CI_Aprobar_cotizacion_pref__c from Cotizacion__c where id = :id and CI_Aprobar_cotizacion_pref__c = false];   
        if(cotiza.size() > 0) {
            cotiza[0].CI_Aprobar_cotizacion_pref__c = true;
            update cotiza;
        }
        return null;
        
    }
    
    @AuraEnabled
    public static string camposCotizacion(Id recordId) {
        list<Cotizacion__c> ListaCotizacion = [Select id,name,Ingresa_Preferencial__c,CI_Aprobar_cotizacion_pref__c FROM Cotizacion__c WHERE id=:recordId];        
        string campos = JSON.serialize(new Map<String,Object> {
            'Preferencial' => ListaCotizacion[0].Ingresa_Preferencial__c,
                'Aprobada' => ListaCotizacion[0].CI_Aprobar_cotizacion_pref__c 
                });
        return campos;
    }
    
    public List<Detalle_Promocion__c> getPromosCotiza() {     
        List<Detalle_Promocion__c> promosCotiza = Database.query('Select id, name, Cotizacion__c, Promocion__c, Promocion__r.Name, CI_Fecha_Promo_Agre__c, Valor_Promocion__c From Detalle_Promocion__c Where Cotizacion__c =: id order by Promocion__r.CI_Valor__c Desc');
        return promosCotiza;
    }
    
    public List<Detalle_Promocion__c> getPromos() {     
        List<Detalle_Promocion__c> promos = Database.query('Select id, name, Cotizacion__c, Promocion__c, Promocion__r.Name, CI_Fecha_Promo_Agre__c From Detalle_Promocion__c Where Cotizacion__c =: id and (Valor_Promocion__c=0 or Valor_Promocion__c=null)');
        return promos;
    }
    
    public List<Detalle_Promocion__c> getAdic() {     
        List<Detalle_Promocion__c> adic = Database.query('Select id, name, Cotizacion__c, Promocion__c, Promocion__r.Name, CI_Fecha_Promo_Agre__c, Valor_Promocion__c From Detalle_Promocion__c Where Cotizacion__c =: id and Valor_Promocion__c>0');
        return adic;
    }
    
    public List<Cuota_Financiamiento__c> getFinanciamiento() {   
        String Tipo = '5'; 
        List<Cuota_Financiamiento__c> financiamiento = Database.query('Select Id, Name, Cotizacion__c, Orden__c, Es_Personalizado__c, Es_Personalizado_Nueva_Cuota__c, Es_Personalizado_Cuota_Original__c, Valor_Saldo__c, Valor_dividendo__c, Valor_Presente__c, Financiamiento__c, Fecha_de_Vencimiento__c, Monto_sin_Descuento__c, toLabel(Tipo__c) From Cuota_Financiamiento__c Where Cotizacion__c =: id and Orden__c!=-1 order by Orden__c Asc Limit 38');
        return financiamiento;
    }
    //Fin Mostrar las primeras 0 - 37 cuotas de entradas
    //Mostrar desde la cuota 39 en adelante
    public List<Cuota_Financiamiento__c> getFinanciamiento3() {   
        String Tipo = '5';  
        List<Cuota_Financiamiento__c> financiamiento3 = Database.query('Select id, name, Cotizacion__c, Tipo__c, Orden__c, Es_Personalizado__c, Es_Personalizado_Nueva_Cuota__c, Es_Personalizado_Cuota_Original__c, Valor_Saldo__c, Valor_dividendo__c, Valor_Presente__c, Financiamiento__c, Fecha_de_Vencimiento__c, Monto_sin_Descuento__c From Cuota_Financiamiento__c Where Cotizacion__c =: id and toLabel(Tipo__c)!=:Tipo and Orden__c>=38 order by Orden__c Asc');
        return financiamiento3;
    }
    //Fin Mostrar desde la cuota 39 en adelante
    
    //Mostrar desde la cuota 0 - 32 del plan de pago
    public List<Cuota_Financiamiento__c> getFinanciamiento4() {   
        String Tipo = '5';  
        List<Cuota_Financiamiento__c> financiamiento4 = Database.query('Select id, name, Cotizacion__c, Tipo__c, Orden__c, Es_Personalizado__c, Es_Personalizado_Nueva_Cuota__c, Es_Personalizado_Cuota_Original__c, Valor_Saldo__c, Valor_dividendo__c, Valor_Presente__c, Financiamiento__c, Fecha_de_Vencimiento__c, Monto_sin_Descuento__c From Cuota_Financiamiento__c Where Cotizacion__c =: id and toLabel(Tipo__c)!=:Tipo and Orden__c!=-1 order by Orden__c Asc Limit 33');
        return financiamiento4;
    }
    
    public List<Cuota_Financiamiento__c> getFinanciamiento2() {   
        String Tipo = '5';  
        List<Cuota_Financiamiento__c> financiamiento2 = Database.query('Select id, name, Cotizacion__c, Tipo__c, Orden__c, Es_Personalizado__c, Es_Personalizado_Nueva_Cuota__c, Es_Personalizado_Cuota_Original__c, Valor_Saldo__c, Valor_dividendo__c, Valor_Presente__c, Financiamiento__c, Fecha_de_Vencimiento__c, Monto_sin_Descuento__c From Cuota_Financiamiento__c Where Cotizacion__c =: id and toLabel(Tipo__c)!=:Tipo and Orden__c>=33 order by Orden__c Asc');
        return financiamiento2;
    }  
    
    public List<ContentDocumentLink> getimagenInmueble() {   
        String Inmueble = 'Inmueble'; List<ContentDocumentLink> imagenInmueble = Database.query('Select id,ContentDocument.LatestPublishedVersionID,ContentDocument.title from ContentDocumentLink where LinkedEntityId=:idInmueble and ContentDocument.title=:Inmueble Limit 1'); return imagenInmueble;
    }
    public List<ContentDocumentLink> getimagenPlano1() {   
        String Inmueble = 'Plano1'; List<ContentDocumentLink> imagenPlano1 = Database.query('Select id,ContentDocument.LatestPublishedVersionID,ContentDocument.title from ContentDocumentLink where LinkedEntityId=:idInmueble and ContentDocument.title=:Inmueble Limit 1'); return imagenPlano1;
    }
    public List<ContentDocumentLink> getimagenPlano2() {   
        String Inmueble = 'Plano2'; List<ContentDocumentLink> imagenPlano2 = Database.query('Select id,ContentDocument.LatestPublishedVersionID,ContentDocument.title from ContentDocumentLink where LinkedEntityId=:idInmueble and ContentDocument.title=:Inmueble Limit 1'); return imagenPlano2;
    }   
    
}