@IsTest public class TestCrearMedioWebProspecto {
 
    static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
     static Lead prosp4;
    static account cuenta ;
    @isTest static void CrearMedioWebProspecto() {
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
            
            		prosp = new Lead();
           			prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123456789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '1303633158';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp.CI_Origen__c = 'web';
                    prosp.CI_Proyecto__c=proy.id;
             
                    prosp.Status='new';
                    insert prosp;
            
                   prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'test0123456789@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '1303633158';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    //prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'web';
                    prosp2.CI_Proyecto__c=proy.id;
                    prosp2.Status='new';
                    prosp2.CI_Ref_Web_To_Lead__c='S';
                    prosp2.CI_Monto_de_Ingresos__c='PRUEBA DE ';
                    insert prosp2;
               
                                        Medio_Web_Prospecto__c medio=new Medio_Web_Prospecto__c(Prospecto__c=prosp2.ID,
                                                              CI_Identificacion_c__c = prosp2.CI_Identificacion__c , 
                                                              Name = '-inserta '+ prosp2.CI_Identificacion__c , 
                                                              CI_Origen_c__c=prosp2.CI_Origen__c,
                                                              Proyecto__c=prosp2.CI_Proyecto__c,
                                                             Fecha_Ingreso__c=date.today() 
                                                               ); 
                            
                             insert medio;
             
                list<lead> l_lead=[select Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                                    CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                                    from lead];
             
                 list<Medio_Web_Prospecto__c> tmedio =[select id, CREATEDDATE, CI_Identificacion_c__c, CI_Origen_c__c, Name,
                                                      Prospecto__c, Proyecto__c, oportunidad__c, esweb__c, fecha_ingreso__c
                                                      from Medio_Web_Prospecto__c  ];
                //CrearMedioWebProspecto.CrearMedioWeb(l_lead);
                //actualizaDiasSinGestionar.NuevaTarea(ttarea);              
                  ActualizaMontosIngreso.ActualizaMontosIngreso(tmedio);
                  

         }
     }
  
}