trigger CreaOportunidad on Event (after insert) {
List<Opportunity> toUpdate = new List<Opportunity>();
     List<account> cuenta = new List<account>();
     List<lead> prosp = new List<lead>();
     String UserId = UserInfo.getUserId();
     List<Id> idop = new List<Id>();
     List<Id> idpr = new List<Id>();
     id idprosp;
     string usuario ='';
    
    event tarea =new event();

    for(event item:trigger.new){
     
           if (item.Subject=='Cita en Obra')// && item.Status=='Completed') 
             {idpr.add(item.whoid); usuario=item.Ownerid ;idprosp=item.whoid;}
   }
    

    If(idpr.size()>0){
        prosp =[SELECT Id, MiddleName, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, 
             CI_Identificacion__c, CI_Identificacion_C__c, CI_Nuevo_Propietario__c, Ownerid, Owner.Name,
             CI_Cod_Proyecto__c, ConvertedAccountId, CI_Proyecto__c 
             from lead where id =:idprosp
             and Status in('Working','new') limit 1];
        
        if (prosp.size()>0)
           {cuenta=[select id,CI_Identificacion__c,CI_Proyecto__c from account 
                    where CI_Identificacion__c =:prosp[0].CI_Identificacion__c limit 1 ];
            IF(cuenta.size()>0)
              {prosp[0].Status ='Qualified';
                update prosp;
                opportunity opor = new opportunity();
                opor.name=prosp[0].name;
                opor.AccountId=cuenta[0].id;
                opor.closedate=system.today();
                opor.stagename='Probable';
                opor.Proyecto__c=prosp[0].CI_Proyecto__c;
                opor.OwnerId = UserId;
                insert opor; 
                CI_AutoConvertLeads.LeadAssign(idpr);
                
              }
            
           }
        }
        
}