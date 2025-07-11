@IsTest public class TestActualizarDiasSinGestionar {
 
    static Lead prosp;
    static Lead prosp2;
    static Lead prosp3;
     static Lead prosp4;
    static account cuenta ;
    @isTest static void ActualizarDiasSinGestionar() {
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
                    //prosp2.CI_Identificacion_C__c = '0300446010';
                    prosp2.CI_Origen__c = 'web';
                    prosp2.CI_Proyecto__c=proy.id;
                    prosp2.Status='new';
                    insert prosp2;
            
                    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp2.CI_Identificacion__c];             

                         
                Task tar1 = new Task();
                tar1.whoid = prosp2.Id;
                tar1.ActivityDate = System.today();
                tar1.Priority = 'High';
                tar1.Subject = 'Cotizacion';
                tar1.Status = 'Completed';
                insert tar1;
             
                list<task> ttarea=[select id,whoid,WhatId,Subject from task];
                
                actualizaDiasSinGestionar.NuevaTarea(ttarea);              

                  

         }
     }
  
}