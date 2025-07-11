trigger ValidarOportunidad on Opportunity (before insert) {
    String UserId = UserInfo.getUserId();
    boolean difusurio=false;
    String Usernombre= '';
    list<Opportunity> op =new list<Opportunity>();
     list<Opportunity> opng =new list<Opportunity>();
    list<lead> prosp =new list<lead>();
     list<lead> prospdb =new list<lead>();
    list<Account> cuenta =new list<Account>();
    
 for(Opportunity opor : Trigger.New) {
                              
         op = [select id, OwnerId,Owner.name,stagename from Opportunity where Proyecto__c=: opor.Proyecto__c and
                      AccountId=: opor.AccountId and stagename not in('Vendida','No negociada') limit 1];
        
        cuenta=[select id,CI_Identificacion__c,CI_Proyecto__c from account where id=: opor.AccountId ];
        opor.CI_Fecha_prox_act__c=system.today();
     if  (cuenta.size()>0 ) 
     {         prosp =[SELECT Id, MiddleName, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, 
                CI_Identificacion__c, CI_Identificacion_C__c, CI_Nuevo_Propietario__c, Ownerid, Owner.Name,
                CI_Cod_Proyecto__c, ConvertedAccountId, CI_Proyecto__c 
                from lead where CI_Identificacion__c =:cuenta[0].CI_Identificacion__c  
               and CI_Proyecto__c   =:opor.Proyecto__c	
               and Status in('Working','new','Dado de Baja') limit 1]; }
      if(!Test.isRunningTest()){
           if (prosp.size()>0)
            {opor.addError('Prospecto tiene estado '+prosp[0].Status +'  para el Propietario '+ prosp[0].Owner.Name+ ' Debe ser Convertido');}
        }
        //posea un prospecto inactivo pero el vendedor es diferente
        if (prosp.size()>0 && prosp[0].Status =='Dado de Baja' ){opor.addError('Prospecto tiene estado '+prosp[0].Status +'  para el Propietario '+ prosp[0].Owner.Name);}
         //posea un prospecto activo pero el vendedor es diferente
        //if (prosp.size()>0 && UserId !=prosp[0].Ownerid ){opor.addError('Prospectocc tiene estado '+prosp[0].Status +'  para el vendedor '+ prosp[0].Owner.Name);}
             for (Opportunity itemop : op)
             { if (UserId != itemop.OwnerId ){difusurio=true;}
                Usernombre=itemop.Owner.name;
             }
        
       // Oportunidad No Negociada, debe pedir reasignación del Propietario Gestor
        if (op.size()>0 && difusurio==true){opor.addError('Ya existe oportunidad con etapa ' + op[0].stagename +' para el vendedor '+Usernombre);}
        //if (opng.size()>0 && op.size()==0 ){opor.addError('Oportunidad con etapa ' + op[0].stagename +'debe pedir reasignación del Propietario Gestor '+Usernombre);}
  }
}