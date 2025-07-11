@IsTest(SeeAllData=true)
public class Test_VigenciaProspectoOp {
   
static testMethod void testMethod1() {
        
        List<Id> usuarios = new List<Id>();
        Id usuariopropietario;
        string tiporeasignacion;
        
        list<lead>leadupdate= new list<lead>();
         

        Test.startTest();
        
        Batch_VigenciaProspectoOportunidad_LR obj1 =new Batch_VigenciaProspectoOportunidad_LR();
       obj1.execute(null);
      
        Test.stopTest();
        
    }

}