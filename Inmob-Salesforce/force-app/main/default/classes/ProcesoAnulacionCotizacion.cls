/**
 **************************************************************************************************************
 * @author         Transformacion Exo 
 * @project        Inmobiliare - Cotización
 * @name           ProcesoRebajaEntradaEntrega
 * @description    Clase programable para anulación de cotización en dependencia al número de días del proyecto.
 * @changes
 * ----------   ---------------------------   -----------------------------------------------------------------
 * Date           Author                        Description
 * ----------   ---------------------------   -----------------------------------------------------------------
 * 15/07/20205    Transformacion Exo             Initial version.
 **************************************************************************************************************
 */
global without sharing class ProcesoAnulacionCotizacion implements Schedulable {
	
     public static final List<String>  ESTADOS_ANULACION = new List<String> {'Nueva','Vigente','En Aprobación','Aprobado'}; 
     global void execute(SchedulableContext sc)     {
        List<Cotizacion__c> cotizacionesUpdate = new List<Cotizacion__c>();
        DateTime hoy = System.now();
         String comentario = 'Cotización anulada por el proceso autómatico';
         for(Cotizacion__c c: 
             [SELECT CreatedDate, CI_Proyecto__r.DiasAnulacionCotizacion__c 
              FROM Cotizacion__c 
              WHERE Estado__c in :ESTADOS_ANULACION
              AND  CI_Proyecto__r.DiasAnulacionCotizacion__c > 0 and CreatedDate < TODAY]){
                  Integer dias = (Integer) c.CI_Proyecto__r.DiasAnulacionCotizacion__c;
                  if(hoy.addDays(- dias) > c.CreatedDate){
                      cotizacionesUpdate.add(
                          new Cotizacion__c (
                              Id = c.Id, 
                              Estado__c = 'Anulada', 
                              ComentarioAnulacion__c = comentario));
                  }
                  
                  
         }
        update cotizacionesUpdate;
    }
}