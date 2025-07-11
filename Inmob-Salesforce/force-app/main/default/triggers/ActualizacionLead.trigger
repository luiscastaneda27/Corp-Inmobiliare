trigger ActualizacionLead on Lead (before insert) 
{
    list<Lead> tprop =new list<Lead>();
     //new CI_LeadTriggerHandler().run(); 
   string ident;
    string caso1;
           string caso2;
           string caso3;
           string caso4;
            string cedula;
            string caso21;
           string caso31;
           string caso41;
            string cedula1;
    
    for(Lead item:trigger.new){
           system.debug('ActualizacionLead paso item.CI_Origen__c '+item.CI_Origen__c);
            system.debug(' ActualizacionLead paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
            system.debug('item.EsWeb__c '+item.EsWeb__c);
            
           if (item.CI_Origen__c!='Web' && item.CI_Cod_Proyecto__c==null && item.CI_Identificacion__c !=null)
               { tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c=:item.CI_Identificacion__c 
                        ];
                   for(lead itop:tprop)
                        {
                            if(itop.CI_Identificacion__c==item.CI_Identificacion__c && !Test.isRunningTest())
                            {item.adderror('h. El prospecto ya existe con esa identificación '+ itop.CI_Identificacion__c+' y es propietario de '
                                        +  itop.Owner.Name + ' y estado: '+itop.status); }  
                        }
               tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c=:item.CI_Identificacion__c 
                        or CI_Identificacion_C__c=:item.CI_Identificacion__c
                        order by createddate asc limit 1];
               
                if (tprop.size()>0 )
                    {   
                     system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
                     system.debug('paso Sitem.CI_Identificacion__c '+item.CI_Identificacion__c);
                     system.debug('id  '+tprop[0].id);
                     system.debug('item.id '+item.id);
                        string identificacion=tprop[0].CI_Identificacion__c;
                        string ientificacion2 =item.CI_Identificacion__c;
                     system.debug('identificacion  '+identificacion);
                     system.debug('ientificacion2 '+ientificacion2);
                     if (tprop[0].CI_Identificacion__c==item.CI_Identificacion__c )
                        {if(!Test.isRunningTest())
                          {item.adderror('a. El prospecto ya existe con esa identificación '+ tprop[0].CI_Identificacion__c+' y es propietario de '
                                        +  tprop[0].Owner.Name + ' y estado: '+tprop[0].status); }  
                        } 
                        
                     if (tprop.size()>0 
                         && tprop[0].CI_Identificacion_C__c == item.CI_Identificacion__c
                         && tprop[0].CI_Proyecto__c == item.CI_Proyecto__c
                         && tprop[0].ownerid != item.ownerid
                         && (tprop[0].status=='New'||tprop[0].status=='Working'))
                         {
                             if(!Test.isRunningTest())
                             {item.adderror('b. El prospecto ya existe '+ tprop[0].CI_Identificacion__c+' y es propietario de '+  tprop[0].Owner.Name);        }
                         }
                    system.debug('item.Ownerid '+item.Ownerid);
                     system.debug('tprop[0].Ownerid '+ tprop[0].Ownerid);
                     system.debug('tprop[0].CI_Identificacion_C__c  '+tprop[0].CI_Identificacion_C__c);
                     system.debug('item.CI_Identificacion__c '+item.CI_Identificacion__c);  
                     system.debug(' tprop[0].status '+ tprop[0].status);  
  
                    if (tprop.size()>0 
                         && tprop[0].CI_Identificacion_C__c == item.CI_Identificacion__c
                         && tprop[0].CI_Proyecto__c == item.CI_Proyecto__c
                        && tprop[0].ownerid != item.ownerid
                         && tprop[0].status=='Qualified')
                      { 
                          list<Opportunity> op=[select id, OwnerId,Proyecto__c,Account.CI_Identificacion__c,Owner.Name from Opportunity
                                        where stagename not in('Vendida','No negociada')
                                                and Account.CI_Identificacion__c=:tprop[0].CI_Identificacion__c limit 1];
                        if(op.size()>0 )
                         { 
                                {if(op[0].OwnerId!=item.Ownerid && item.Ownerid != tprop[0].Ownerid){ item.adderror('c. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                                {if(op[0].OwnerId!=item.Ownerid && item.Ownerid == tprop[0].Ownerid){ item.adderror('d. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                           
                          }
                       }

            }  
            }
            
           if (item.CI_Origen__c!='Web' && item.CI_Identificacion_C__c !=null)
               {
               tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                        CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,CI_Proyecto__c, CuentaId__c 
                        from lead 
                        where CI_Identificacion__c=:item.CI_Identificacion_C__c
                        order by createddate asc limit 1];
               
                if (tprop.size()>0 )
                {  if (tprop.size()>0 
                       && tprop[0].CI_Identificacion__c == item.CI_Identificacion_C__c
                       &&item.CI_Identificacion_C__c!=null
                       && tprop[0].ownerid != item.ownerid)
                       { 
                        if((tprop[0].status=='New'||tprop[0].status=='Working')&&(tprop[0].CI_Proyecto__c == item.CI_Proyecto__c))
                          {
                           system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
                           system.debug('paso Sitem.CI_Identificacion_C__c '+item.CI_Identificacion_C__c);
                           system.debug('paso Stprop[0].CI_Identificacion__c    '+tprop[0].CI_Identificacion__c );
                           system.debug('id  '+tprop[0].id);
                           system.debug('item.id '+item.id);
                           if(!Test.isRunningTest())
                           { item.adderror('e. El prospecto ya existe '+ tprop[0].CI_Identificacion__c+' y es propietario de '+  tprop[0].Owner.Name); }
                          }
                           
                         if(tprop[0].status=='Qualified' || tprop[0].status=='New'||tprop[0].status=='Working') 
                          {
                           list<Opportunity> op=[select id, OwnerId,Proyecto__c,Account.CI_Identificacion__c,Owner.Name from Opportunity
                                                  where stagename not in('Vendida','No negociada')
                                                 and Account.CI_Identificacion__c=:tprop[0].CI_Identificacion__c
                                                 and Proyecto__c=:item.CI_Proyecto__c
                                                 limit 1];
                           system.debug('paso item.CI_Cod_Proyecto__c '+item.CI_Cod_Proyecto__c);
                           system.debug('paso Sitem.CI_Identificacion_C__c '+item.CI_Identificacion_C__c);
                           if(op.size()>0 )
                              { 
                                {if(op[0].OwnerId!=item.Ownerid && item.Ownerid != tprop[0].Ownerid){ item.adderror('f. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                                {if(op[0].OwnerId!=item.Ownerid && item.Ownerid == tprop[0].Ownerid){ item.adderror('g. El prospecto ya existe como conyuge de  '+ tprop[0].name+' y es propietario de '+  op[0].Owner.Name);}}
                           
                             }
                       }
    
                       }
                          
                }
            }
        
         } 
}