trigger cambiaretapa on Task (after insert,after update) {
     List<Opportunity> toUpdate = new List<Opportunity>();
     List<account> cuenta = new List<account>();
     List<lead> prosp = new List<lead>();
    
     String UserId = UserInfo.getUserId();
     List<Id> idop = new List<Id>();
     List<Id> idpr = new List<Id>();
     List<Id> idopwhoid = new List<Id>();//whoid
     List<Id> idopwhatid = new List<Id>();
     id idprosp;
     string usuario ='';
    
    task tarea =new task();
 //   try{
        for(Task item:trigger.new){
        
        //cambio realizar cambios sobre oportunidades no automaticas
        System.debug('Subject '+item.Subject);
        System.debug('Status '+item.Status);
         System.debug('item.WhatId '+item.WhatId); 
            
      if (item.Subject=='Cotizacion Web' && item.WhatId<>null & item.WhatId<>'') 
             {idop.add(item.WhatId); }   
            
      if (item.Subject=='Llamada' && item.Status=='Completed') 
             {idop.add(item.WhatId); }
        
        if ((item.Subject=='Llamada' || item.Subject=='Email'  || item.Subject=='Mensaje de texto'  )&& item.Status=='Completed' && item.whoid !=null) 
             {prosp =[SELECT Id, MiddleName, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, 
             CI_Identificacion__c, CI_Identificacion_C__c, CI_Nuevo_Propietario__c, Ownerid, Owner.Name,
             CI_Cod_Proyecto__c, ConvertedAccountId, CI_Proyecto__c 
             from lead where id =:item.whoid
             and Status in('Working','new')];
             prosp[0].Status='Working';//para activar el flujo 
              update prosp;
             }
        
           if (item.Subject=='Cotizacion')// && item.Status=='Completed') 
             {idpr.add(item.whoid); usuario=item.Ownerid ;idprosp=item.whoid;}
   }
     System.debug('idop.size() '+idop.size());
    
    If(idop.size()>0){
        toUpdate = [SELECT Id, StageName,name FROM Opportunity WHERE Id IN :idop limit 1];
        List<Opportunity> toUdpOporManual = new List<Opportunity>();
        
        for(Opportunity item:toUpdate){
            System.debug('Hello World! e '+item.StageName);
            if (item.StageName!='No negociada' && item.StageName!='Vendida')
            {  if (item.StageName =='Nueva'){item.StageName = 'Trabajando';}
               item.name =item.name +' ';
               toUdpOporManual.Add(item);
            }
          }
        //Si esta en N Actualiza
        
       if(toUdpOporManual.size()>0)
       {System.debug('Hello World! grabo ');
            update toUdpOporManual;
       }
    }
    If(idpr.size()>0){
        prosp =[SELECT Id, MiddleName, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, 
             CI_Identificacion__c, CI_Identificacion_C__c, CI_Nuevo_Propietario__c, Ownerid, Owner.Name,
             CI_Cod_Proyecto__c, ConvertedAccountId, CI_Proyecto__c 
             from lead where id =:idprosp
             and Status in('Working','new')];
        
        if (prosp.size()>0)
           {cuenta=[select id,CI_Identificacion__c,CI_Proyecto__c from account 
                    where CI_Identificacion__c =:prosp[0].CI_Identificacion__c];
             //and CI_Proyecto__c   =:prosp[0].CI_Proyecto__c
            prosp[0].Status ='Qualified';
            System.debug('se puso Qualified');
            
            update prosp;
            opportunity opor = new opportunity();
            opor.name=prosp[0].name;
            opor.AccountId=cuenta[0].id;
            opor.closedate=system.today();
            opor.stagename='Probable';
            opor.Proyecto__c=prosp[0].CI_Proyecto__c;
            opor.OwnerId = UserId;
            insert opor; 
            
            //CI_AutoConvertLeads.LeadAssign(idpr); 
          
           }
        }
  
  //  }
 //   catch(Exception ex0) {
//        System.debug('Error en la Oportunidad: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
//        }
}