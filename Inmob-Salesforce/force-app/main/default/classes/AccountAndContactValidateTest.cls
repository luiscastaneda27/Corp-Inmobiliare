//Comment: Test class to: CI_Account trigger, CI_AccountHandler, CI_AccountHelper
@IsTest
public class AccountAndContactValidateTest {
    
    static Lead prosp;
    static Account acc;
    static Contact cont;
    
    public static User createUser() {
        Profile profile1 = [Select Id from Profile where name = 'Admin User' or name = 'Administrador del Sistema'];
        System.debug('What is the profile id ' + profile1);
        UserRole portalRole = [Select Id From UserRole Where Name = 'Asesor Comercial Rioja' Limit 1];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = 'Test',
                              lastName = 'Test',
                              email = uniqueName + '@test' + orgId + '.org',
                              Username = uniqueName + '@test' + orgId + '.org',
                              EmailEncodingKey = 'ISO-8859-1',
                              Alias = uniqueName.substring(18, 23),
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              UserRoleId = portalRole.Id,
                              ProfileId = profile1.Id);
        
        insert tuser;
        
        User u1 = [SELECT id from User WHERE Id=: tuser.Id LIMIT 1];
        system.debug('MC Users ='+ ' ' + u1);
        return u1;
    }
    
	@isTest static void ejecuciones1() {
        
        try {

            User us = AccountAndContactValidateTest.createUser();
            
            System.runas(us) {
                
                Proyecto__c pro = new Proyecto__c(Name = 'LA RIOJA', Codigo_Proyecto__c = '5001', CI_Estado__c = 'Activo');
                Insert pro;
        
                prosp = new Lead();
                prosp.LastName = 'TestLead';
                prosp.Email = 'test0123456789@gmail.com';
                prosp.CI_Personeria__c = '1';
                prosp.CI_Tipo_Iden__c = '2';
                prosp.CI_Identificacion__c = '1308095064';
                prosp.CI_Medio_Contacto__c = 'TELÉFONO';
                prosp.CI_Identificacion_C__c = '1303633158';
                prosp.CI_Origen__c = 'OBRA';
                insert prosp;
                
                prosp.LastName = 'TestLead2';
                prosp.Email = 'test111111111@gmail.com';
                prosp.CI_Personeria__c = '1';
                prosp.CI_Tipo_Iden__c = '2';
                prosp.CI_Identificacion__c = '1309736559';
                prosp.CI_Medio_Contacto__c = 'CELULAR';
                prosp.CI_Identificacion_C__c = '1303633158';
                prosp.CI_Movil__c = '123123123';
                update prosp;
                
                acc = new Account();
                acc.LastName = 'TestApe';
                acc.CI_Tipo_de_Cliente__c = 'Prospecto Potencial';
                insert acc;
                
                acc.LastName = 'TestApe2';
                update acc;
                
                cont = new Contact();
                cont.LastName = 'TestApe';
                insert cont;
                
                cont.LastName = 'TestApe2';
                update cont;
                
                Opportunity opp = new Opportunity(Name='test opp', StageName='stage', Probability = 95, CloseDate=system.today());
                insert opp;
                opp.Amount = 1000;
                opp.StageName = 'Closed/Won';
                update opp;
                
                //-----MARCO-----//
                ////METODO OPCIONAL PARA PROBAR LA PRIMERA CONDICION DEL TRIGGER "envioERPTrigger"
                Opportunity opp1 = new Opportunity(Name='test opportunidad 001', StageName='Probable', Probability = 10, CloseDate=system.today());
                insert opp1;
                
                /*Task tarea = new Task();
                tarea.WhatId = acc.Id;
                tarea.ActivityDate = System.today();
                tarea.Priority = 'High';
                tarea.Subject = 'Nueva Cuenta Creada';
                tarea.Status = 'Completed';
                insert tarea;*/
                       
                Cotizacion__c cot = new Cotizacion__c();
                cot.Oportunidad__c = opp1.Id;
                cot.CI_Oportunidad_PD__c = opp1.Id;
                cot.Precio_Venta__c = 80000;
                Insert cot;
                
                Cuota_Financiamiento__c cuota = new Cuota_Financiamiento__c();
                cuota.Cotizacion__c = cot.Id;
                cuota.Monto_Pago__c = 2500;
                insert cuota;
                
                opp1.Amount = 1000;
                opp1.Cotizacion__c = Cot.Id;
                opp1.StageName = 'No negociada'; 
                opp1.Estado_de_Aprobacion__c = 'Enviado'; //cambio el estado de la Aprobacion a True para que cumpla la primera condicion
                update opp1;
                
                //METODO OPCIONAL PARA PROBAR LA SEGUNDA CONDICION DEL TRIGGER "envioERPTrigger" (descartado)
                //Opportunity opp2 = new Opportunity(Name='test opp', StageName='stage', Probability = 95, CloseDate=system.today());
                //Cotizacion__c cot = new Cotizacion__c(Ingresa_Preferencial__c = True, CI_Aprobar_cotizacion_pref__c = True);
                //insert cot;
                //insert opp2;
                //opp2.Amount = 1000;
                //opp2.StageName = 'Closed/Won';
                //opp2.Estado_de_Aprobacion__c = 'Enviado'; 
                //opp2.Cotizacion__r.Ingresa_Preferencial__c = True;
                //opp2.Cotizacion__r.CI_Aprobar_cotizacion_pref__c = True;
                //update cot;
                //update opp2;
                //-----MARCO-----//                
        
                //ValidateEditionInAccountClass.validacionesCuenta(opp.id, opp.AccountId, opp.CI_Proyecto__c, Opp.StageName);
                //ValidateEditionInAccountClass.validacionesCuenta2(opp.AccountId);
                
                Permiso_a_Cuenta__c pc = new Permiso_a_Cuenta__c(CI_Propietario__c = us.Id, CI_Cuenta__c = acc.Id, CI_Oportunidad__c = opp.Id, CI_Permite_Edicion__c = true);
                insert pc;
                
    		}
        } catch(Exception ex) {
            System.debug('Error en test de account: '+ex.getLineNumber()+'---'+ex.getMessage());
        }	            
    }
}