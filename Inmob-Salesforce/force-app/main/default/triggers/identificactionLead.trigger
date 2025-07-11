trigger identificactionLead on Lead ( before update,after update) {
            list<Lead> tprop =new list<Lead>();
          string prospecto;
          string Cuenta;
          string op;
          string lead;
          string accpunt;
          string op1;
        for(Lead item:trigger.new){
            system.debug(' identificactionLead paso item.CI_Origen__c '+item.CI_Origen__c);
              system.debug(' identificactionLead paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
               //item.CI_Nuevo_Propietario__c=item.OwnerId;
                if(item.CI_Origen__c!='Web' && item.EsWeb__c!=true && item.Status!='Dado de Baja')
    			{
                   tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                            CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                           from lead 
                           where( CI_Identificacion__c=:item.CI_Identificacion__c
                            or CI_Identificacion_C__c=:item.CI_Identificacion__c
                            or CI_Identificacion__c=:item.CI_Identificacion_C__c) 
                               and id !=: item.id order by createddate asc limit 1];
                    if (tprop.size()>0)
                       {   
                          system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
                         system.debug('paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
                         system.debug('id  '+tprop[0].id);
                         system.debug('item.id '+item.id);
                           
                          if (tprop[0].CI_Identificacion__c==item.CI_Identificacion__c  )
                           {if(!Test.isRunningTest())
                              {item.adderror('*El prospecto ya existe con esa identificación '+ tprop[0].CI_Identificacion__c+' y es propietario de '+  tprop[0].Owner.Name );}  
                           } 
                           
                           system.debug('1 paso item.CI_Proyecto__c '+item.CI_Proyecto__c);
                           system.debug('tprop[0].CI_Proyecto__c '+tprop[0].CI_Proyecto__c);
                           system.debug('1 paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
                           system.debug('1 tprop[0].CI_Identificacion_C__c '+tprop[0].CI_Identificacion_C__c);
                           system.debug('1 id  '+tprop[0].id);
                           system.debug('1 item.id '+item.id);
                          system.debug('1 tprop[0].Ownerid '+tprop[0].Ownerid);
                           system.debug('1 item.OwnerId ' +item.OwnerId);
                           
                          if (tprop.size()>0 
                                && tprop[0].CI_Identificacion_C__c == item.CI_Identificacion__c
                                && tprop[0].CI_Proyecto__c == item.CI_Proyecto__c
                                && (tprop[0].status=='New'||tprop[0].status=='Working' || tprop[0].status=='Qualified')
                                && item.Status!='Dado de Baja'
                                && tprop[0].Ownerid != item.OwnerId
                                )
                              //&& tprop[0].Ownerid != item.OwnerId
                          {system.debug('paso item.CI_Proyecto__c '+item.CI_Proyecto__c);
                           system.debug('paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
                           system.debug('id  '+tprop[0].id);
                           system.debug('item.id '+item.id);
                            system.debug('tprop[0].CI_Proyecto__c '+tprop[0].CI_Proyecto__c);
                           system.debug('tprop[0].Ownerid '+tprop[0].Ownerid);
                           system.debug('item.OwnerId ' +item.OwnerId);
                              if(!Test.isRunningTest())
                              {item.adderror('* El prospecto ya existe como conyuge del prospecto '+ tprop[0].CI_Identificacion__c+' y es propietario de '+  tprop[0].Owner.Name);}
                           } 
                           
                           if (tprop.size()>0 
                                && tprop[0].CI_Identificacion__c == item.CI_Identificacion_C__c
                                && item.CI_Identificacion_C__c != null
                                && tprop[0].ownerid != item.ownerid
                                && item.Status!='Dado de Baja')
                               // && (tprop[0].status=='New'||tprop[0].status=='Working' || tprop[0].status=='Qualified'))
                          {system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
                           system.debug('paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
                           system.debug('id  '+tprop[0].id);
                           system.debug('item.id '+item.id);
                           
                           if ((tprop[0].status=='New'||tprop[0].status=='Working')&&(tprop[0].CI_Proyecto__c == item.CI_Proyecto__c))
                             {item.adderror('* Prospecto ya existe '+ tprop[0].CI_Identificacion__c+' y es propietario de '+  tprop[0].Owner.Name);}
                           
                           if (tprop[0].status=='Qualified' || tprop[0].status=='New'||tprop[0].status=='Working')
                             { list<Opportunity> op=[select id, OwnerId,Proyecto__c,Account.CI_Identificacion__c,Owner.Name from Opportunity
                                        where stagename not in('Vendida','No negociada')
                                        and Account.CI_Identificacion__c=:item.CI_Identificacion__c 
                                        and Proyecto__c=:item.CI_Proyecto__c  limit 1];
                                if(op.size()>0 )
                                 { 
                                   {if(op[0].OwnerId!=item.Ownerid && item.Ownerid != tprop[0].Ownerid){ item.adderror('c. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                                   {if(op[0].OwnerId!=item.Ownerid && item.Ownerid == tprop[0].Ownerid){ item.adderror('d. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                           		 }
                             }
          
                           } 
                       }
    			}
               
        }
}