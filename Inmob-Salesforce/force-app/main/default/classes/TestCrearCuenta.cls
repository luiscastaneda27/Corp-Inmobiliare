@isTest public class TestCrearCuenta {
    static Lead prosp;
    static Lead prosp2;
 
  @isTest static void GeneralesCreartarea() {
     UserRole r = [SELECT Id FROM UserRole WHERE Name='Asesor Comercial Rioja'];
    
            
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
             
 		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo');
    
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Proyecto__c=proy.id;
                    prosp2.Status='new';
                    insert prosp2;
                   list<lead> prospp=[select id,CI_Apellidos_C__c,CI_Ciudad__c,CI_Email__c,CI_Fecha_Nacimiento_C__c,
                                      CI_Fecha_ultima_gestion__c,CI_Horario__c,CI_Identificacion_C__c,CI_Identificacion__c,CI_Medio_Contacto__c,
                                      FirstName ,LastName,MiddleName,Suffix,CI_Nombre_C__c,CI_Origen__c,CI_Pais__c,CI_Cod_Proyecto__c,
                                      CI_Proyecto__c,CI_Tipo_Ident_C__c,CI_Tipo_Iden__c,CI_Personeria__c,CI_Tipo_de_Cliente__c,MobilePhone, Phone   
                                      from lead where CI_Identificacion__c=:prosp2.CI_Identificacion__c ];
                                      CrearCuenta.NuevaTarea(prospp);
           

         }
     }

}