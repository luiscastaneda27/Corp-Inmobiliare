@isTest public class CasosProspectosTest {
    
    static Lead prosp;
    static Lead prosp2;
    static account cuenta ;
    
    @isTest static void GeneralesVilla3() {
     	 UserRole r = [SELECT Id FROM UserRole WHERE Name='Jefe Ventas Rioja'];
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
        u.ProfileId = [SELECT id FROM profile where Name = 'Administrador del sistema'].Id;
        u.UserRoleId = r.Id;
        insert u;
        
         System.runAs ( u ) {
                     
             Proyecto__c proy = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo');
             Proyecto__c proy2 = new Proyecto__c(Name = 'Villa Italia', Codigo_Proyecto__c = '5002', CI_Estado__c = 'Activo');
             
             prosp = new Lead();
             prosp.LastName = 'TestLead';
             prosp.Email = 'ccu78@gmail.com';
             prosp.CI_Personeria__c = '1';
             prosp.CI_Tipo_Iden__c = '2';
             prosp.CI_Identificacion__c = '0926161829';
             prosp.CI_Medio_Contacto__c = 'TELÉFONO';
             // prosp.CI_Identificacion_C__c = '1303633158';
             prosp.CI_Origen__c = 'OBRA';
             prosp.OwnerId = U.Id;
             prosp.CI_Proyecto__c=proy.id;

             insert prosp;
             
             lead updclt=[select id,OwnerId,Status from lead where id=:prosp.id limit 1];
             updclt.Status='Dado de Baja';
             updclt.OwnerId= U1.Id;
             updclt.CI_Motivo_Baja__c  ='CLIENTE SIN PRESUPUESTO';
             update updclt;
             
             lead updclt1=[select id,OwnerId,Status from lead where id=:prosp.id limit 1];
             updclt1.Status='new';
             updclt1.OwnerId= U1.Id;
             updclt1.CI_Motivo_Baja__c  ='CLIENTE SIN PRESUPUESTO';
             update updclt1;
         }
     }
}