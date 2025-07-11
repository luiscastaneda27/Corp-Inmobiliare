trigger leadconvendedor on Lead (before insert) {
       Set<string> stIds = new Set<string>();
  Set<string> stProys = new Set<string>();
    boolean existe=false;
       string caso1;
           string caso2;
           string caso3;
           string caso4;
  for(Lead item:trigger.new){
   
    system.debug('item.CI_Origen__c '+item.CI_Origen__c);
    if(item.CI_Origen__c =='Web' || item.EsWeb__c) 
    {    // item.ownerid='0053i000002NLQjAAO';
        system.debug('grabo sin problrema');
       if(!Test.isRunningTest())
         {if (item.CI_Tipo_Iden__c=='' || item.CI_Tipo_Iden__c==null)
             {system.debug('antes item.CI_Tipo_Iden__c ' + item.CI_Tipo_Iden__c);
              item.CI_Tipo_Iden__c='2';
              system.debug('despues item.CI_Tipo_Iden__c ' + item.CI_Tipo_Iden__c);
             }
         }
        list<Lead> tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c=:item.CI_Identificacion__c limit 1];
        
        
        system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
        system.debug('paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
        system.debug('paso item.CI_Origen__c' +item.CI_Origen__c);
        
        system.debug('tprop.size() - - ' +tprop.size());
        system.debug('Prospecto__c ' +item.id);
        system.debug('Name ' +item.CI_Identificacion__c);
        system.debug('Identificacion__c ' +item.CI_Identificacion__c);
        system.debug('Proyecto__c ' +item.CI_Proyecto__c);
        
        
        if (tprop.size()>0 )//&& tprop.size()==1 
        {  //tprop[0].pi__pardot_hard_bounced__c=true;
            item.CI_Ref_Web_To_Lead__c ='S';
            Prospecto_Web__c nuevo =new Prospecto_Web__c (Prospecto__c = tprop[0].id, 
                                                          Name = '-inserta '+item.CI_Identificacion__c, 
                                                          Procesado__c=false,
                                                         Identificacion__c=item.CI_Identificacion__c,
                                                         Proyecto__c=item.CI_Proyecto__c);
            insert nuevo;
         
         
          //  newConList.add(nuevo);
    	}
        if (tprop.size()>=2 )
        {  
            system.debug('se repirte mas de a');
                item.adderror('se repirte mas de una vez');
          //  newConList.add(nuevo);
    	}
    }
    
    }
    system.debug('paso la grabacion ');

}