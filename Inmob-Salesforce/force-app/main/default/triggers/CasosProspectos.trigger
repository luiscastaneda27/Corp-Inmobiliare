trigger CasosProspectos on Lead (before update) {
   	List<Asignacion_Web_to_Lead__c> VEND = new List<Asignacion_Web_to_Lead__c>();
    List<account> cuenta = new List<account>();
    List<id> mailprosp = new List<id>();
    list<lead> UsuarioAnte=  trigger.old;
    list<lead>  UsuarioNew=  trigger.new;
     
    if (UsuarioAnte[0].ownerid != UsuarioNew[0].OwnerId){
          UsuarioNew[0].Fecha_Reasignacion__c=DateTime.now();
    }
    system.debug('UsuarioAnte[0].OwnerId '+UsuarioAnte[0].Status );
    system.debug('UsuarioNew[0].OwnerId '+UsuarioNew[0].Status );
    system.debug('UsuarioNew[0].proyecto '+UsuarioNew[0].CI_Proyecto__c );
    system.debug('UsuarioNew[0].CI_Identificacion__c '+UsuarioNew[0].CI_Identificacion__c );
    system.debug('UsuarioNew[0].proyecto '+UsuarioNew[0].CI_Proyecto__r.name );
 /*   for(Lead item:trigger.new){
       cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c from account 
                      where CI_Identificacion__c =:item.CI_Identificacion__c limit 1];
   		if(item.Status=='Dado de Baja'){
            if (item.CI_Motivo_Baja__c=='' && !Test.isRunningTest()){
                item.addError('Indique Motivo de baja');
          	}
           if (cuenta.size()>0)
               {
                cuenta[0].OwnerId =item.OwnerId;
                cuenta[0].CI_Proyecto__c=item.CI_Proyecto__c;
                update cuenta;
               }
          }
        
       for(Lead itemold:trigger.old){
    
             system.debug('Casos Prospecto item.OwnerId '+item.OwnerId +' nombre vendedor '+item.Owner.name);
             if (itemold.Status=='Dado de Baja' && item.Status=='New')
                   {  if (cuenta.size()>0){
                      system.debug ('itemold.Status==Dado de Baja && item.Status==New '+itemold.ownerid +' '+item.ownerid);

                       cuenta[0].OwnerId =item.OwnerId;
                       cuenta[0].CI_Proyecto__c=item.CI_Proyecto__c;
                       update cuenta;
                       }
                   }
             if(itemold.owner.isactive==false && item.owner.isactive==true && itemold.ownerid!=null && item.ownerid !=null )
               {
                 if (cuenta.size()>0)
                   {system.debug ('itemold.owner.isactive==false && item.owner.isactive==true '+itemold.ownerid +' '+item.ownerid);
                    cuenta[0].OwnerId =item.OwnerId;
                    cuenta[0].CI_Proyecto__c=item.CI_Proyecto__c;
                    update cuenta;
                   }
               }
          if(itemold.ownerid != item.ownerid && itemold.ownerid!=null && item.ownerid !=null )
               {system.debug ('itemold.ownerid !=item.ownerid '+itemold.ownerid +' '+item.ownerid);
                 if (cuenta.size()>0)
                   {system.debug (' 2 itemold.ownerid !=item.ownerid '+itemold.ownerid +' '+item.ownerid);
                    cuenta[0].OwnerId =item.OwnerId;
                    system.debug (' 2 cuenta[0].OwnerId  '+' '+cuenta[0].OwnerId );
                    cuenta[0].CI_Proyecto__c=item.CI_Proyecto__c;
                    update cuenta;
                   }
               }
             }
        }  */
   
}