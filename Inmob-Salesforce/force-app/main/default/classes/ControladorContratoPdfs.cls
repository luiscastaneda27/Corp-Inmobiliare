public class ControladorContratoPdfs {

    String contratoId;
    String tipoPagare;
    public String edadCuenta {get;set;}
    public String edadConyuge {get;set;}
    public List<EspecificacionTecnica__c> especificacionesTecnicas { get; set; }
    public List<FinanciamientoWrapper> coutasFinanciamiento { get; set; }
    public Decimal valorEntradaSaldo {get;set;}
    public String valorEntradaSaldoLetras {get;set;}
    
    
    public ControladorContratoPdfs(ApexPages.StandardController controller) { 
        contratoId = controller.getid();
        tipoPagare = ApexPages.currentPage().getParameters().get('tipoPagare');
        coutasFinanciamiento = new List<FinanciamientoWrapper>();
        Contrato__c contrato = 
            [Select Id, Cuenta__r.CI_Fecha_Nacimiento__c, Cuenta__r.CI_Fecha_Nacimiento_C__c,
             Cotizacion__r.CI_Modelo__c, Cotizacion__c, ValorSaldo__c, ValorEntrada__c 
             From Contrato__c
             Where Id =:contratoId];
        edadCuenta = calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento__c) != null ? calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento__c) + ' AÑOS' : '';
        edadConyuge = calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento_C__c) != null ? calcularAnios(contrato.Cuenta__r.CI_Fecha_Nacimiento_C__c) + ' AÑOS' : '';
        especificacionesTecnicas = [Select Caracteristica__r.Name, Descripcion__c from EspecificacionTecnica__c WHERE Modelo__c = :contrato.Cotizacion__r.CI_Modelo__c and MostrarCotizacion__c = true];
        if(String.isNotBlank(tipoPagare)){
            String query = 'Select Orden__c, Monto_Pago__c, Fecha_de_Vencimiento__c ';
            query += 'From Cuota_Financiamiento__c Where Cotizacion__c =\'' + contrato.Cotizacion__c + '\'';
            query += 'and Orden__c!=-1 and ' + (tipoPagare == 'E' ? 'tipo__c != \'5\' ' : 'tipo__c = \'5\' ');
            query += 'order by Orden__c Asc';
            valorEntradaSaldo = tipoPagare == 'E' ? contrato.ValorEntrada__c : contrato.ValorSaldo__c;
            valorEntradaSaldoLetras = ConvertirNumeros.convertirLetras((Integer) valorEntradaSaldo);
            valorEntradaSaldoLetras += ' CON ' + (Integer)((valorEntradaSaldo - (Integer) valorEntradaSaldo).setScale (2) * 100) +'/100 ';
            valorEntradaSaldoLetras = valorEntradaSaldoLetras.toUpperCase();
            coutasFinanciamiento = new List<FinanciamientoWrapper>();
            for(Cuota_Financiamiento__c item: DataBase.query(query)){
                FinanciamientoWrapper cf = new FinanciamientoWrapper();
                cf.orden = (Integer) item.Orden__c + (tipoPagare == 'E' ? 1 : 0);
                cf.valorNumero = item.Monto_Pago__c;
                Integer valorEntero = (Integer) cf.valorNumero;
                cf.fechaVencimiento = item.Fecha_de_Vencimiento__c;
                cf.valorLetras = ConvertirNumeros.convertirLetras(valorEntero);
                cf.valorLetras += ' CON ' + (Integer)((cf.valorNumero - valorEntero).setScale (2) * 100) +'/100 ';
                cf.valorLetras = cf.valorLetras.toUpperCase();
                coutasFinanciamiento.add(cf);
            }
        }
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
    
    public class FinanciamientoWrapper{
        Public Integer orden{get;set;}
        Public Date fechaVencimiento{get;set;}
        Public Decimal valorNumero{get;set;}
        Public String valorLetras{get;set;}
    }
}