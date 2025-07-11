@IsTest public class CreaOportunidadTest {

    static Lead prosp;
    static Lead prosp2;
    static account cuenta ;
    
    
    @isTest static void GeneralesVilla() {
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
             
                  Empresa__c emp = new Empresa__c(); 
                        emp.Name='MEISTERBLUE CIA. LTDA.';
                        insert emp;
        
         		 Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo',Empresa__c=emp.id);
    
            
                    Asignacion_Web_to_Lead__c vende = new Asignacion_Web_to_Lead__c();
                    vende.Proyecto_vendedor__c=proy.id;
                    vende.CI_Usuario__c=u.id;
                    vende.CI_Usuario_Activo_Web__c=true;
             
                    insert vende;
            
            		prosp2 = new Lead();
           			prosp2.LastName = 'TestLead';
                    prosp2.Email = 'ccu87@gmail.com';
                    prosp2.CI_Personeria__c = '1';
                    prosp2.CI_Tipo_Iden__c = '2';
                    prosp2.CI_Identificacion__c = '0920952587';
                    prosp2.CI_Medio_Contacto__c = 'TELÉFONO';
                    prosp2.CI_Identificacion_C__c = '1303442782';
                    prosp2.CI_Origen__c = 'Obra';
                    prosp2.CI_Proyecto__c=proy.id;
                    insert prosp2;
             
                    event even =new event();
                    even.Subject='Cita en Obra';
                    even.WhoId=prosp2.id;
                    even.DurationInMinutes=8;
                    even.ActivityDateTime=system.today();
                    insert even;

                               

                    prosp = new Lead();
                    prosp.LastName = 'TestLead';
                    prosp.Email = 'test0123456789@gmail.com';
                    prosp.CI_Personeria__c = '1';
                    prosp.CI_Tipo_Iden__c = '2';
                    prosp.CI_Identificacion__c = '0300446010';
                    prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                   // prosp.CI_Identificacion_C__c = '1303633158';
                    prosp.CI_Origen__c = 'Obra';
                    prosp.CI_Proyecto__c=proy.id;
                    insert prosp;
                        
                /*    cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                    where CI_Identificacion__c =:prosp.CI_Identificacion__c];
             
                    opportunity opor = new opportunity();
                    opor.name='LULU NENA PLAZA LAGOS';
                    opor.AccountId=cuenta.id;
                    opor.closedate=system.today();
                    opor.stagename='Probable';
                    opor.OwnerId = u.Id;
                    insert opor; 
             
              */
                  // CrearTarea.Nuevatarea(prosp.id,cuenta.id,'I');     

         }
     }
}