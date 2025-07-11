@IsTest(SeeAllData=true)
public class BatchReasigmentLeadsTest {
        
    static testMethod void testMethod1() {
        
        List<Id> usuarios = new List<Id>();
        Id usuariopropietario;
        string tiporeasignacion;
        
        list<lead>leadupdate= new list<lead>();

        Test.startTest();
        
        BatchReasigmentLeads obj = new BatchReasigmentLeads(usuarios,usuariopropietario,tiporeasignacion);
        DataBase.executeBatch(obj);
        
        obj.execute(null,leadupdate);
        
        Batch_VigenciaProspectoOportunidad obj1 =new Batch_VigenciaProspectoOportunidad();
        obj1.execute(null);
        Batch_VigenciaProspecto obj2 = new Batch_VigenciaProspecto();
        obj2.execute(null);
        Test.stopTest();
        
    }

}