@IsTest(SeeAllData=true)
public class Test_CI_CambiarPropietarioLead {
    static Lead prosp;
	static void DataFactory() {
        
        Proyecto__c pro = new Proyecto__c();
        pro.Name = 'LA RIOJA';
        pro.CI_Estado__c = 'Activo';
        pro.Codigo_Proyecto__c = '7001';
        insert pro;
        
        CI_CambiarPropietarioLead cp = new CI_CambiarPropietarioLead();
        
        User u0 = [Select Id, Name, ProfileID, ManagerId, IsActive from User Where Profile.Name = 'Asesor de Ventas' and ManagerId != null and IsActive != false Limit 1];
        
        prosp = new Lead();
        prosp.LastName = 'TestLead';
        prosp.Email = 'test0123456789@gmail.com';
        prosp.CI_Personeria__c = '1';
        prosp.CI_Tipo_Iden__c = '2';
        prosp.CI_Identificacion__c = '1308095064';
        prosp.CI_Medio_Contacto__c = 'TELÉFONO';
        prosp.CI_Identificacion_C__c = '1303633158';
        prosp.OwnerId = u0.Id;
        prosp.CI_Origen__c = 'OBRA';
        prosp.CI_Proyecto__c = pro.Id;
        prosp.CI_Cod_Proyecto__c = 'LA RIOJA';
        insert prosp;
      
    }
    public static testMethod void ventasctas() {
       
        Test.startTest();
        
        DataFactory();
        
        CI_CambiarPropietarioLead.changeOwnerMethod(prosp.Id);
        
        Test.stopTest();
        
    }    
}