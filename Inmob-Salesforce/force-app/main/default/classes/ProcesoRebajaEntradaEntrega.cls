/**
 **************************************************************************************************************
 * @author         Transformacion Exo 
 * @project        Inmobiliare - Cotización
 * @name           ProcesoRebajaEntradaEntrega
 * @description    Clase programable para rebaja de meses de entrada y entrega.
 * @changes
 * ----------   ---------------------------   -----------------------------------------------------------------
 * Date           Author                        Description
 * ----------   ---------------------------   -----------------------------------------------------------------
 * 8/07/20205    Transformacion Exo             Initial version.
 **************************************************************************************************************
 */
global without sharing class ProcesoRebajaEntradaEntrega implements Schedulable {
    
    global void execute(SchedulableContext sc)     {
        List<CI_ParametroLote__c> parametrosUpdate = new List<CI_ParametroLote__c>();
        for(CI_ParametroLote__c item: 
            [SELECT Id, CI_Lote__r.CI_Bloque__c, CI_PlazoEntrada__c, CI_PlazoEntrega__c,
             CI_Lote__r.CI_Etapa__r.PlazoEntradaConstruccion__c, CI_Lote__r.CI_Etapa__r.PlazoEntradaConstruir__c, 
             CI_Lote__r.CI_Etapa__r.PlazoEntregaConstruccion__c, CI_Lote__r.CI_Etapa__r.PlazoEntregaConstruir__c 
             FROM CI_ParametroLote__c 
             WHERE CI_Lote__r.CI_Bloque__c != null and CI_Lote__r.CI_Estado__c in ('D','V')]){
                 String bloque = item.CI_Lote__r.CI_Bloque__c.toUpperCase();
                 Integer plazoEntradaConstruccion = (Integer)item.CI_Lote__r.CI_Etapa__r.PlazoEntradaConstruccion__c;
                 Integer plazoEntradaConstruir = (Integer)item.CI_Lote__r.CI_Etapa__r.PlazoEntradaConstruir__c;
                 Integer plazoEntregaConstruccion = (Integer)item.CI_Lote__r.CI_Etapa__r.PlazoEntregaConstruccion__c;
                 Integer plazoEntregaConstruir = (Integer)item.CI_Lote__r.CI_Etapa__r.PlazoEntregaConstruir__c;
                 
                 if(bloque == 'X' && plazoEntradaConstruir > 0 && plazoEntregaConstruir > 0){
                     item.CI_PlazoEntrada__c -= item.CI_PlazoEntrada__c > plazoEntradaConstruir ? 1 : 0;
                     item.CI_PlazoEntrega__c -= item.CI_PlazoEntrega__c > plazoEntregaConstruir ? 1 : 0;
                 }else if(bloque.isNumeric() && plazoEntradaConstruccion > 0 && plazoEntregaConstruccion > 0){
                     item.CI_PlazoEntrada__c -= item.CI_PlazoEntrada__c > plazoEntradaConstruccion ? 1 : 0;
                     item.CI_PlazoEntrega__c -= item.CI_PlazoEntrega__c > plazoEntregaConstruccion ? 1 : 0;
                 }
                 parametrosUpdate.add(item);
             }
        update parametrosUpdate;
    }
}