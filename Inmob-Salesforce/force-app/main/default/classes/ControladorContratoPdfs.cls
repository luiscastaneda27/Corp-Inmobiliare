public class ControladorContratoPdfs {

    String contratoId;
    public String edadCuenta {get;set;}
    public String edadConyuge {get;set;}
    public List<EspecificacionTecnica__c> especificacionesTecnicas { get; set; }
    
    
    public ControladorContratoPdfs(ApexPages.StandardController controller) { 
        contratoId = controller.getid();
        Contrato__c contrato = 
            [Select Id, Cuenta__r.CI_Fecha_Nacimiento__c, Cuenta__r.CI_Fecha_Nacimiento_C__c,
             Cotizacion__r.CI_Modelo__c
             From Contrato__c
             Where Id =:contratoId];
        edadCuenta = calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento__c) != null ? calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento__c) + ' AÑOS' : '';
        edadConyuge = calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento_C__c) != null ? calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento_C__c) + ' AÑOS' : '';
        especificacionesTecnicas = [Select Caracteristica__r.Name, Descripcion__c from EspecificacionTecnica__c WHERE Modelo__c = :contrato.Cotizacion__r.CI_Modelo__c and MostrarCotizacion__c = true];
    }
    
    
    public static Integer calcularAnios(Date fechaNacimiento) {
        if (fechaNacimiento == null) {
            return null;
        }
        Date hoy = Date.today();
        Integer edad = hoy.year() - fechaNacimiento.year();
        if (hoy.month() < fechaNacimiento.month() || 
           (hoy.month() == fechaNacimiento.month() && hoy.day() < fechaNacimiento.day())) {
            edad--;
        }
        
        return edad;
    }
}