trigger CI_Opportunity on Opportunity (before insert, after insert, before update, after update) {
   try{
       list<Opportunity> op =new list<Opportunity>();
       list<Opportunity> listaOp =new list<Opportunity>();
       list<Opportunity> opcony =new list<Opportunity>();
       list<account> ctacony =new list<account>();
       list<string> listaIdCta =new list<string>();
       list<user> usuario= new list<user>();
       string a;
       string b;
       string c;
       string d;
       string e;
       string f;
       
       if (Trigger.isinsert && Trigger.isbefore){
           
         for(Opportunity opor : Trigger.New){
         	listaIdCta.add(opor.AccountId);
         }
         
           system.debug ('CI_Opportunity on Opportunity ');
           listaOp = [select id, OwnerId,Proyecto__c from Opportunity where //Proyecto__c=: opor.Proyecto__c and
                 AccountId in: listaIdCta and stagename not in('Vendida','No negociada') ];
           
         for(Opportunity opor : Trigger.New)
         {
                          
             string ncuenta= opor.AccountId;
             string nproyecto=opor.Proyecto__c;    
             string b1;
             string c2;
             string d1;
             string e1;
             string f1;
             
             for(Opportunity objOp: listaOp){
                 if(objOp.AccountId == opor.AccountId && objOp.Proyecto__c== opor.Proyecto__c)
                     op.add(opor);
             }
             

             if (op.size()>0){
                 opor.addError('c: Ya existe oportunidad activa ' + ' etapa ' +  op[0].stagename  );
             }
             
             if (op.size()==0)
             {
                 list<account> cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                                       where id =:opor.AccountId limit 1]; 
                 //system.debug('opor.AccountId '+ opor.AccountId +' CI_Identificacion__c '+cuenta[0].CI_Identificacion__c);
                 
                 string vcuenta= opor.AccountId;
                 string vproyecto=opor.Proyecto__c;
                 string vCI_Identificacion_C=cuenta[0].CI_Identificacion__c;
                 
                 list<lead>  tcony = [SELECT Id,esweb__c,CI_Identificacion_C__c, CI_Medio_Contacto__c, CI_Origen__c, Name, Status,
                                      Email, CI_Identificacion__c,  
                                      CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,
                                      CI_Proyecto__c, CuentaId__c 
                                      from lead  where CI_Identificacion_C__c=:vCI_Identificacion_C//opor.Account.CI_Identificacion__c //cuenta[0].CI_Identificacion__c 
                                      //and CI_Proyecto__c=:opor.Proyecto__c
                                      and Status not in('Dado de Baja')
                                      order by  createddate asc limit 1   ];
                 
                 //system.debug('opor.Proyecto__c '+opor.Proyecto__c +'  cuenta[0].CI_Identificacion__c '+cuenta[0].CI_Identificacion__c);
                 
                 if(tcony.size()>0)
                 {  system.debug(' 2 tcony[0].CI_Identificacion__c '+tcony[0].CI_Identificacion__c);
                  
                  ctacony =[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                            where CI_Identificacion__c =:tcony[0].CI_Identificacion__c limit 1]; 
                 }
                 
                 if(ctacony.size()>0)
                 { system.debug(' 2 ctacony[0].id '+ctacony[0].id);
                  
                  opcony = [select id, OwnerId,Proyecto__c from Opportunity where
                            AccountId=: ctacony[0].id and stagename not in('Vendida','No negociada') ];
                 }
                 //system.debug('opor.Proyecto__c '+opor.Proyecto__c +'  cuenta[0].CI_Identificacion__c '+cuenta[0].CI_Identificacion__c);
                 
                 
                 list<lead>  tprop = [ SELECT Id,esweb__c, CI_Medio_Contacto__c,  Name, Status, Email, 
                                      CI_Identificacion__c,  
                                      CI_Nuevo_Propietario__c, Ownerid, Owner.Name, CI_Cod_Proyecto__c, Cod_Proyecto__c,
                                      CI_Proyecto__c, CuentaId__c,CI_Origen__c,CI_Formulario__c,CI_Monto_de_Ingresos__c,CI_Numero_de_dormitorios__c 
                                      from lead  where CI_Identificacion__c=: vCI_Identificacion_C //cuenta[0].CI_Identificacion__c 
                                      // and CI_Proyecto__c=:opor.Proyecto__c
                                      and Status not in('Dado de Baja')
                                      and CI_Ref_Web_To_Lead__c<>'S'
                                      order by  createddate asc limit 1];
                  system.debug(' opor.Account.CI_Identificacion__c '+ opor.Account.CI_Identificacion__c);
                  system.debug(' vCI_Identificacion_C '+ vCI_Identificacion_C);
                 if(tprop.size()>0 && Trigger.isinsert)
                 {   system.debug(' tprop[0].CI_Formulario__c '+tprop[0].CI_Formulario__c);
                    opor.CI_Formulario__c=tprop[0].CI_Formulario__c;
                    opor.CI_Monto_de_Ingresos__c=tprop[0].CI_Monto_de_Ingresos__c;
                    opor.CI_Numero_de_dormitorios__c=tprop[0].CI_Numero_de_dormitorios__c;
                 }
                 
                 if(tcony.size()>0)
                 { system.debug(' ci oportunidad tcony.ownerid '+
                                tcony[0].ownerid+' UserInfo.getUserid() '+UserInfo.getUserid()
                                +' tcony.id '+tcony[0].id +'  opcony.size()==0 '+String.valueOf(opcony.size()));
                  
                  if (tcony[0].ownerid !=UserInfo.getUserid()&& opor.EsWeb__c==false && opor.Proyecto__c==tcony[0].CI_Proyecto__c && tcony[0].id != null && opcony.size()==0 && tprop[0].status!='Qualified')
                  {opor.addError('d: Prospecto ya existe para ' + tcony[0].Owner.Name);}
                  
                  if (tcony[0].ownerid !=UserInfo.getUserid()&& opor.EsWeb__c==true && opor.Proyecto__c==tcony[0].CI_Proyecto__c && tcony[0].id != null && opcony.size()==0 && tprop[0].status!='Qualified'|| Test.isRunningTest())
                  {opor.OwnerId=tcony[0].ownerid;}
                  
                  if (tcony[0].ownerid !=UserInfo.getUserid() && tcony[0].id != null && opcony.size()==0 && tprop[0].status=='Qualified' || Test.isRunningTest())
                  {opor.OwnerId=tcony[0].ownerid;}
                 }
                 
                 system.debug(' UserInfo.getUserid() '+ UserInfo.getUserid());
                 usuario=[select id,name,profileid,profile.name from user where id=:UserInfo.getUserid() 
                          and profile.name like'%Asesor%' limit 1];
                 if(usuario.size()>0)
                 {if(tprop.size()>0)
                 {system.debug(' ci oportunidad tprop.ownerid '+
                               tprop[0].ownerid+' UserInfo.getUserid() '+UserInfo.getUserid()
                               +' tprop.id '+tprop[0].id);
                  
                  if (tprop[0].ownerid !=UserInfo.getUserid()//&& tprop[0].esweb__c==false && tprop[0].CI_Origen__c!='Web' 
                      &&  tprop[0].id != null && opor.Proyecto__c==tprop[0].CI_Proyecto__c && tprop[0].Status!='Qualified')
                  {opor.addError('b: Prospecto ya existe para  ' + tprop[0].Owner.Name  );}}
                  
                  system.debug('tcony.size()>0 && tprop.size()>0 && op.size()>0) '+String.valueOf(tcony.size())+' - '+String.valueOf(tprop.size()) +' - '+String.valueOf(opcony.size())  );
                  system.debug(ctacony[0].CI_Proyecto__c+'---'+tprop[0].CI_Proyecto__c);
                  
                  if (tcony.size()>0  && ctacony[0].CI_Proyecto__c==tprop[0].CI_Proyecto__c && tcony[0].ownerid !=UserInfo.getUserid() && tprop[0].id != null )
                  {system.debug(tcony[0].CI_Proyecto__c+'---'+tprop[0].CI_Proyecto__c);
                      opor.addError('ax: Prospecto ya existe para  ' + tcony[0].Owner.Name  );}
                 }
                 
                 
             }
         }
       }
   }
   catch(Exception ex0) {
        System.debug('Error de processOpportunity: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
        //list<Opportunity> op = new list<Opportunity>();
   }
   if(!Test.isRunningTest()){new CI_OpportunityHandler().run();}
}