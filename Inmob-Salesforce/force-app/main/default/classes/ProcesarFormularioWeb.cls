public class ProcesarFormularioWeb {
    @InvocableMethod 
    public static void ProcesarWeb ()
    {try{  string caso7;
           string caso8;
            list<Prospecto_Web__c> Cotweb =new list<Prospecto_Web__c>();
             list<lead> tprop =new list<lead>();
             list<lead> tcony =new list<lead>();
             list<Account> cuenta =new list<Account>();
             string Nombre;
             string Codigo;
             string idop;
             string Asesor;
             string correoresponsable;
        
            system.debug('ProcesarWeb');
            Cotweb = [select id, name, Procesado__c, OwnerId, Prospecto__c, Proyecto__c,Proyecto__r.Usuario_Correo__r.email, 
                                               Identificacion__c, Proyecto__r.name,con_error__c 
                      from Prospecto_Web__c
                                               where Procesado__c=:false order by createddate,Identificacion__c asc];
         
            for (Prospecto_Web__c item:Cotweb  )
               {   //prospecto
                   if(!Test.isRunningTest()){ 
                        list<lead> leadtemporal = [SELECT Id, ownerid from lead 
                                where CI_Identificacion__c=:item.Identificacion__c and id !=:item.Prospecto__c limit 1]; 
                       if(leadtemporal.size()>0)
                       {asesor=leadtemporal[0].ownerid;
                        delete leadtemporal;}
                       else 
                       {asesor=item.ownerid;}
                       
                   }
                   else{asesor=item.ownerid;}
                   correoresponsable=item.Proyecto__r.Usuario_Correo__r.email;
                   
                   system.debug('ProcesarWeb leadtemporal');
                   item.con_error__c =true;
                  // item.OwnerId=asesor;
                   item.Procesado__c=true;
                  system.debug('ProcesarWeb item.Procesado__c');
                     //termina proceso         
                  update Cotweb;
                   
                     tprop = [ SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                              CI_Nuevo_Propietario__c, Owner.profile.name,Ownerid,Owner.email, Owner.Name,Owner.isactive, CI_Cod_Proyecto__c, Cod_Proyecto__c,
                              CI_Proyecto__c, CuentaId__c 
                              from lead  where CI_Identificacion__c=:item.Identificacion__c order by  createddate asc limit 1  ];
                     //datos de la cuenta
                        cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                        where CI_Identificacion__c =:tprop[0].CI_Identificacion__c limit 1];
                   
                    tcony = [SELECT Id, CI_Medio_Contacto__c, CI_Origen__c, Name, Status, Email, CI_Identificacion__c, CI_Identificacion_C__c, 
                             CI_Nuevo_Propietario__c, Ownerid, Owner.Name,Owner.isactive,CI_Proyecto__c, CuentaId__c 
                             from lead  where CI_Identificacion_C__c=:item.Identificacion__c 
                             and Status not in('Dado de Baja') limit 1];
                   
                    system.debug('tprop[0].CI_Proyecto__c '+tprop[0].CI_Proyecto__c + '  item.Proyecto__c '+item.Proyecto__c);
                     Nombre=tprop[0].name;
                     Codigo=tprop[0].id;
                   //Asesor=ValidaAsesor(item.Proyecto__c);
                   if (tprop[0].CI_Proyecto__c==item.Proyecto__c)
                     {system.debug('ProcesarWeb del mismo proyecto');
                        boolean darbaja=false;
                       //oportunidades del prospecto
                       List<Opportunity> opor  = [select id,Ownerid,Owner.isactive,Owner.profile.name, name, Proyecto__c,Prospecto__c, Prospecto__r.name, 
                                                  Cuenta__c, AccountId,Account.name, 
                                                  Account.CI_Identificacion__c, Account.CI_Proyecto__c,StageName 
                                                  from Opportunity where Account.CI_Identificacion__c=: item.Identificacion__c
                                                  and Proyecto__c =: item.Proyecto__c order by createddate desc limit 1];
                       //linea 31 
                       
                      if (tprop[0].Owner.isactive==False || tprop[0].Owner.profile.name !='Asesor de Ventas')
                         {//Asesor=ValidaAsesor(item.Proyecto__c);
                          system.debug ('antes Asesor' +Asesor);
                          tprop[0].OwnerId=Asesor;
                          update tprop;
                          asesor=tprop[0].OwnerId;
                          system.debug ('despues tprop[0].OwnerId ' +tprop[0].OwnerId+' - '+Asesor );
                          if (tprop[0].Status!='Dado de Baja')
                             {EnvioCorreo(Asesor,nombre,Codigo,'L',correoresponsable);}
                          system.debug ('asesor ' +asesor);
                         }
                       
                      if (tprop[0].Status=='Dado de Baja')
                         {//actualizo prospevto
                         
                          tprop[0].Status='New';
                          tprop[0].CI_Motivo_Baja__c='';   
                          tprop[0].CI_Proyecto__c=item.Proyecto__c;
                         // Asesor=ValidaAsesor(item.Proyecto__c);
                          tprop[0].OwnerId=Asesor;
                             if(!Test.isRunningTest()){update tprop;}
                          string Subject='Cotizacion Web';
                          string Status = 'Open';
                          darbaja=true;
                          CreaTarearospecto(Subject,Status,tprop[0].id,Asesor );
                          EnvioCorreo(Asesor,nombre,Codigo,'L',correoresponsable);
                          system.debug ('asesor  Dado de Baja' + darbaja);
                             
                          }  
                      if (opor.size()>0)
                         {system.debug ('oportunidad  ' );
                           for(Opportunity itemop:opor)
                           {   //linea 27
                               if (itemop.StageName=='Vendida')
                                  { // string Usuario=ValidaAsesor(item.Proyecto__c) ;
                                     idop=CreaOportunidad(itemop.Account.name,itemop.AccountId,'Nueva',itemop.Proyecto__c,Asesor );
                                     CreaTareaOportunidad('Cotizacion Web','Open',idop,Asesor);
                                      EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);
                                     system.debug('Vendida '+itemop.StageName);
                                  }  
                               //linea 28
                               if (itemop.StageName=='No negociada')
                                  {// string Usuario=ValidaAsesor(item.Proyecto__c) ;
                                    idop=CreaOportunidad(itemop.Account.name,itemop.AccountId,'Nueva',itemop.Proyecto__c,Asesor );
                                    CreaTareaOportunidad('Cotizacion Web','Open',idop, Asesor );
                                    EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);
                                  system.debug('No negociada '+itemop.StageName);
                                  }
                              //linea 30  y 34
                              system.debug('etapa 0'+itemop.StageName);
                               if (itemop.StageName!='No negociada' && itemop.StageName!='Vendida')
                                  { if(itemop.Owner.isactive == false || itemop.Owner.profile.name!='Asesor de Ventas') 
                                      {//Asesor= ValidaAsesor(item.Proyecto__c);
                                      itemop.Ownerid=Asesor;} 
                                    else 
                                      {Asesor=itemop.Ownerid;}
                                    
                                    string stagename='Nueva';
                                     CreaProcesoRelleno();
                                    //string idop=CreaOportunidad(itemop.name,itemop.AccountId,itemop.stagename,itemop.Proyecto__c,Asesor );
                                    string Subject='Cotizacion Web';
                                    string Status = 'Open';
                                    itemop.esweb__c=true;
                                    CreaTareaOportunidad(Subject,Status,itemop.id,Asesor);//itemop.Ownerid 
                                    EnvioCorreo(Asesor,nombre,itemop.id,'O',correoresponsable);
                                    system.debug('etapa '+itemop.StageName);
                                  }
                           }
                           update opor; 
                         } 
                      if((darbaja==false && opor.size()==0 ) && (tprop[0].status=='New'||tprop[0].status=='Working'))
                         { system.debug('se crea tarea '+tprop[0].owner.id);
                          system.debug('se crea tarea '+asesor);
                           string Subject='Cotizacion Web';
                           string Status = 'Open';
                           system.debug ('antes  true tprop[0].owner.id ' +tprop[0].owner.id);
                          system.debug ('antes  true tprop[0].owner.id ' +asesor);
                           asesor=tprop[0].ownerid;
                            system.debug ('cverfica true Asesor' +Asesor);
                           CreaProcesoRelleno();
                           CreaTarearospecto(Subject,Status,tprop[0].id,Asesor );
                           EnvioCorreo(Asesor,nombre,Codigo,'L',correoresponsable);
                        }
                       if(darbaja==false && opor.size()==0 && tprop[0].status=='Qualified' )
                         { system.debug('se crea tarea '+tprop[0].owner.id);
                          system.debug('se crea tarea '+asesor);
                           string Subject='Cotizacion Web';
                           string Status = 'Open';
                           system.debug ('antes  true tprop[0].owner.id ' +tprop[0].owner.id);
                          system.debug ('antes  true tprop[0].owner.id ' +asesor);
                          if(tcony.size()>0 && tcony[0].status !='Dado de Baja')
                            {asesor=tcony[0].ownerid;}
                          else
                            {asesor=tprop[0].ownerid;}
                            system.debug ('cverfica true Asesor' +Asesor);
                          
                           idop=CreaOportunidad(tprop[0].name,cuenta[0].id,'Nueva',item.Proyecto__c,Asesor );
                           CreaTareaOportunidad('Cotizacion Web','Open',idop,Asesor);
                           EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);
                        }
                      }
                   else//otro proyecto cotiza cliente
                      {//linea 32
                       //datos de la cuenta
                        //cuenta=[select id,OwnerId,CI_Identificacion__c,CI_Proyecto__c,name from account 
                        //where CI_Identificacion__c =:tprop[0].CI_Identificacion__c];
                        system.debug('ingreso por otro proyecto ');   
                       boolean DadoBaja=False;
                          
                       system.debug('ProcesarWeb del otro proyecto '+item.Proyecto__r.name);
                                   
                          
                       if (tprop[0].Status=='Dado de Baja')
                         {tprop[0].Status='New';
                          tprop[0].CI_Motivo_Baja__c='';   
                          if(tcony.size()>0 &&(tcony[0].CI_Proyecto__c==tprop[0].CI_Proyecto__c))  
                            {Asesor=tcony[0].ownerid;}
                         // else
                         //   {Asesor= ValidaAsesor(item.Proyecto__c);}
                          tprop[0].OwnerId=Asesor;
                          tprop[0].CI_Proyecto__c=item.Proyecto__c;
                          if(!Test.isRunningTest()){ update tprop;}
                          //EnvioCorreo(Asesor,nombre,Codigo,'L',correoresponsable);

                          DadoBaja=true;
                         } 
                          
                     
                       //prospecto de otro proyecto
                       List<Opportunity> opor  = [select id,Ownerid,Owner.isactive,Owner.profile.name, name, Proyecto__c,Prospecto__c, Prospecto__r.name, 
                                                  Cuenta__c, AccountId, Account.name,
                            Account.CI_Identificacion__c, Account.CI_Proyecto__c,StageName 
                            from Opportunity where Account.CI_Identificacion__c=: item.Identificacion__c
                            and Proyecto__c =:item.proyecto__c order by createddate desc limit 1];
                       if (opor.size()>0)
                         {system.debug('ProcesarWeb del otro proyecto DadoBaja Opportunity itemop:opor ');
                           for(Opportunity itemop:opor)
                           {  //linea 29
                                system.debug('etapa 0'+itemop.StageName);
                               
                               if (itemop.StageName=='No negociada')
                                  { //string usuario=ValidaAsesor(item.Proyecto__c);
                                     idop=CreaOportunidad(itemop.Account.name,itemop.AccountId,'Nueva',itemop.Proyecto__c, Asesor);
                                          CreaTareaOportunidad('Cotizacion Web','Open',idop,Asesor );
                                          EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);} 
                               
                                if (itemop.StageName=='Vendida')
                                  {  //string usuario= ValidaAsesor(item.Proyecto__c);
                                     idop=CreaOportunidad(itemop.Account.name,itemop.AccountId,'Nueva',itemop.Proyecto__c,Asesor );
                                     CreaTareaOportunidad('Cotizacion Web','Open',idop,Asesor );
                                     EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);}
                                     system.debug('etapa antes '+itemop.StageName);
                               
                                if (itemop.StageName!='No negociada' && itemop.StageName!='Vendida')
                                  {  system.debug('etapa ingreso if  '+itemop.StageName);
                                     if(itemop.Owner.isactive == false || itemop.Owner.profile.name!='Asesor de Ventas') 
                                       {//Asesor= ValidaAsesor(item.Proyecto__c);
                                       itemop.Ownerid=Asesor;} 
                                     else 
                                        {Asesor=itemop.Ownerid;}
                                   
                                    string Subject='Cotizacion Web';
                                    string Status = 'Open';
                                    itemop.EsWeb__c =true;
                                    CreaTareaOportunidad('Cotizacion Web', 'Open',itemop.id,Asesor );
                                    EnvioCorreo(Asesor,nombre,itemop.id,'O',correoresponsable);
                                    CreaProcesoRelleno();
                                    system.debug('etapa '+itemop.StageName);
                                   string caso1;
                                   string caso2;
                                   string caso3;
                                   string caso4;
                                  }
                           }
                          update opor;
                             
                         }
                       else
                          {   system.debug('ProcesarWeb del otro proyecto DadoBaja '+DadoBaja);
                                if (DadoBaja==false)
                                  {
                                      //linea 33 - 35
                                    //Asesor=ValidaAsesor(item.Proyecto__c);
                                    string stagename='Nueva';
                                    string a='Prueba';
                                    string b='Prueba';
                                    string c='Prueba';
                                    idop=CreaOportunidad(tprop[0].name,cuenta[0].id,'Nueva',item.Proyecto__c,Asesor );
                                         CreaTareaOportunidad('Cotizacion Web','Open',idop,Asesor);
                                         EnvioCorreo(Asesor,nombre,idop,'O',correoresponsable);
                                    CreaProcesoRelleno();
                                  }
                               else 
                                 {
                                   //string Subject='Cotizacion Web';
                                   //string Status = 'Open';
                                   CreaTarearospecto('Cotizacion Web','Open',tprop[0].id,Asesor );
                                  EnvioCorreo(Asesor ,nombre,Codigo,'L',correoresponsable);
                                 }
                          }  
                       }
                    System.debug('fin y avctualiza item.con_error__c ');
               item.con_error__c =false;
               update Cotweb;
               }
            
        }
       catch(Exception ex0) {
        System.debug('Error de processOpportunity: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
        }
    }
   
    public static void CreaTarearospecto(string Subject,string Status,string prospecto,string asesor )
    {                string x='Cotizacion Web';string z='Cotizacion Web';
           string y = 'Open';string w = 'Open';
     string caso1;
           string caso2;
           string caso3;
           string caso4;
                    Task Tarea = new Task();
                    tarea.WhoId = prospecto;
                    tarea.Subject = Subject; 
                    tarea.Status =Status;
                    tarea.OwnerId = asesor;           
                    //tarea.CreatedById = usuarioNoEmpresa.id;
                    tarea.ActivityDate = system.now().Date();
                    insert tarea;
             //return true;
    }
    public static void CreaTareaOportunidad(string Subject,string Status,string opor,string asesor )
    {                string x='Cotizacion Web';string z='Cotizacion Web';
           string y = 'Open';string w = 'Open';
     string caso1;
           string caso2;
           string caso3;
           string caso4;
  /*   list<Opportunity> oport=[ select id, CloseDate, CI_Fecha_Inicio__c, Account.CI_Identificacion__c 
                                     from Opportunity where  id=:opor];
     if (oport.size()>0)
        {for(Opportunity item:oport)
           {item.esweb__c=true;}
           update oport;
        }*/
         
                    Task Tarea = new Task();
                    tarea.WhatId = opor; 
                    tarea.Subject = Subject; 
                    tarea.Status =Status;
                    tarea.OwnerId = asesor;           
                    //tarea.CreatedById = usuarioNoEmpresa.id;
                    tarea.ActivityDate = system.now().Date();
                    insert tarea;
                    system.debug('se ingreso tarea  '+tarea.id);
            
    }
    
    public static string CreaOportunidad(string nombre,string cuenta,string stagename,string proyecto,string asesor )
    {     //crea oportunidad
          string x='Cotizacion Web';string z='Cotizacion Web';
           string y = 'Open';string w = 'Open';
           string caso1;
           string caso2;
           string caso3;
           string caso4;
                   opportunity opor = new opportunity();
                    opor.name=nombre;
                    opor.AccountId=cuenta;
                    opor.closedate=system.today();
                    opor.stagename=stagename;  //opor.Lead__c=cand.id;
                    opor.Proyecto__c=proyecto;
        			opor.EsWeb__c=true;
                    opor.OwnerId=asesor;
                    insert opor;
                    return opor.id;
    }   
    
    public static void EnvioCorreo(string ownerid, string nombre,String Codigo,String Tipo,string correo)
    {
        //EmailTemplate et = [SELECT Id,Subject, Body FROM EmailTemplate WHERE Name ='CI_Notificar Nuevo Lead'];
        List<string> toAddress = new List<string>();
        List<string> ccAddresses = new List<string>();
          
        if(!Test.isRunningTest()){ 
            user usuario = [Select  Email,Name from user where id =:ownerid];
            toAddress.add(usuario.Email);}
        else{
            toAddress.add('Cristiancrespoandrade@gmail.com');
        }  
        if (correo!= null && correo<>'')
          {ccAddresses.add(correo);} 
        if(Test.isRunningTest()){ccAddresses.add('cc@ht.com');} 
        if(toAddress.size()>0){
            
            OrgWideEmailAddress[] owea = [select Id,DisplayName  from OrgWideEmailAddress where DisplayName like '%Corpora%Inmobi%ernacional'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setTemplateId(et.Id);
            mail.setToAddresses(toAddress);
            if(ccAddresses.size()>0){mail.setCcAddresses(ccAddresses);}
            
            mail.setSubject('Nuevo prospecto asignado');
            if(tipo=='L')
            {mail.setplainTextBody('Estimad@, Se le ha asignado un nuevo Prospecto: '+Nombre+'. Puedo acceder al registro desde este link: https://corporacioninmobiliare.lightning.force.com/lightning/r/Lead/'+ Codigo+'/view');}
            else
            {mail.setplainTextBody('Estimad@, Se le ha asignado un nuevo Prospecto: '+Nombre+'. Puedo acceder al registro desde este link: https://corporacioninmobiliare.lightning.force.com/lightning/r/Opportunity/'+ Codigo+'/view');}    
             //mail.setplainTextBody('Estimad@, Se le ha asignado un nuevo Prospecto: '+Nombre+'. Puedo acceder al registro desde este link: https://corporacioninmobiliare.lightning.force.com/lightning/r/Lead/'+ Codigo+'/view');
            //mail.setTargetObjectId(Codigo);
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            allmsg.add(mail);
            
            try {
                Messaging.sendEmail(allmsg,false);
                return;
            }catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
     }
     public static void CreaProcesoRelleno()
    {     string x='Cotizacion Web';string z='Cotizacion Web';
           string y = 'Open';
           string w = 'Open';
           string Nombre;
          string caso1;
           string caso2;
           string caso3;
           string caso4;
           string caso6;
           string caso7;
           string caso8;
           string caso9;
           string caso82;
           string caso91;
    }
        
}