@IsTest(SeeAllData=true)
public class test_vigenciaprospecto {
   static testMethod void testMethod1() {
        
        List<Id> usuarios = new List<Id>();
        Id usuariopropietario;
        string tiporeasignacion;
        
        list<lead>leadupdate= new list<lead>();
       

        Test.startTest();
        
       
        //Batch_VigenciaProspectoOportunidad obj1 =new Batch_VigenciaProspectoOportunidad();
        //obj1.execute(null);
       Batch_VigenciaProspecto_vi obj2 = new Batch_VigenciaProspecto_vi();
        obj2.execute(null);
        Test.stopTest();
        
    }
}