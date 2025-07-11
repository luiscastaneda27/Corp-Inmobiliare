@IsTest public class TestActualizaDatosLeadDeWeb {
 
    static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
     static Lead prosp4;
    
    static account cuenta ;
@isTest static void GeneralesTestActualizarLead() {
    list<lead> lista; 
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
      User u1 = new User();
        u1.Firstname = 'mauricie';
        u1.LastName = 'ruiz';
        u1.email = 'mauruiz@outlook.com';
        u1.Alias = 'alias3';
        u1.CommunityNickname = 'commnick3';
        u1.EmailEncodingKey = 'UTF-8';
        u1.Username = 'mauryrui@outlook.com';
        u1.TimeZoneSidKey = 'America/Denver';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
        u1.isActive =true;
        u1.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u1.UserRoleId = r.Id;
        insert u1;
            
    User u = new User();
        u.Firstname = 'mauricio';
        u.LastName = 'ruiz';
        u.email = 'mauryruiz@outlook.com';
        u.Alias = 'alias2';
        u.CommunityNickname = 'commnick2';
        u.EmailEncodingKey = 'UTF-8';
        u.Username = 'mauryruiz123@outlook.com';
        u.TimeZoneSidKey = 'America/Denver';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.isActive =true;
        u.ProfileId = [SELECT id FROM profile where Name = 'Asesor de Ventas' or name = 'Asesor de Ventas'].Id;
        u.UserRoleId = r.Id;
        insert u;

       
         System.runAs ( u ) {
             
 		  Proyecto__c proy = new Proyecto__c();
            proy.Name = 'LA RIOJA';
            proy.CI_Estado__c = 'Activo';
            proy.Codigo_Proyecto__c = '7001';
            insert proy;
            system.debug('proyecto 1 '+proy.id);
             
             Proyecto__c proy2 = new Proyecto__c();
            proy2.Name = 'Villa Italia';
            proy2.CI_Estado__c = 'Activo';
            proy2.Codigo_Proyecto__c = '7002';
            insert proy2;
             
            system.debug('proyecto 2 '+proy2.id);
 		      
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
             
                    Asignacion_Web_to_Lead__c vende1 = new Asignacion_Web_to_Lead__c();
                    vende1.Proyecto_vendedor__c=proy2.id;
                    vende1.CI_Usuario__c=u1.id;
                    vende1.CI_Usuario_Activo_Web__c=true;
                    insert vende1;
             
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test01239@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Web';
                    prosp2.CI_Cod_Proyecto__c=null;
                    prosp2.Status='Qualified';
                    prosp2.CI_Movil__c='2312311';
                    prosp2.CI_Proyecto__c=proy.Id;
                    prosp2.OwnerId =vende.CI_Usuario__c;
              		prosp2.CI_Formulario__c='2222';
            		prosp2.CI_Monto_de_Ingresos__c='22212';
            		prosp2.CI_Numero_de_dormitorios__c='5555';
                    insert prosp2;
                    list<lead> prospp=[select id,CI_Apellidos_C__c,Email,CI_Email__c,CI_Movil__c,ownerid,
                                      CI_Fecha_ultima_gestion__c,CI_Horario__c,CI_Identificacion_C__c,CI_Identificacion__c,CI_Medio_Contacto__c,
                                      FirstName ,LastName,MiddleName,Suffix,CI_Nombre_C__c,CI_Origen__c,CI_Pais__c,CI_Cod_Proyecto__c,
                                      CI_Proyecto__c,CI_Tipo_Ident_C__c,CI_Tipo_Iden__c,CI_Personeria__c,CI_Tipo_de_Cliente__c,MobilePhone, Phone   
                                      from lead where CI_Identificacion__c=:prosp2.CI_Identificacion__c ];
                                      //ActualizaDatosLeadDeWeb.ActualizaCuenta(prospp);
                                      ActualizaAsesorCuenta.ActualizaCuenta(prospp);
             
                               Actualizar_Cuenta__c nuevo =new Actualizar_Cuenta__c (
                                                          Name = '-inserta '+'1303633158', 
                                                          Cedula__c='1303633158',
                                                           Usuario__c=prosp2.OwnerId,
                                                          Procesado__c=false,
                                                          Proyecto__c=proy.Id );
                             insert nuevo;
             
                             list<Actualizar_Cuenta__c> actcta = [select Name,Cedula__c,Usuario__c,Proyecto__c,Procesado__c from Actualizar_Cuenta__c where Cedula__c=:prosp2.CI_Identificacion__c ];
                                      ActualizaCuenta.ActualizaCuentaDatos(actcta);
             
                   
         }
     }
    
}