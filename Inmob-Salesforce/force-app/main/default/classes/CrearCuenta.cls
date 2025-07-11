public class CrearCuenta {
     @InvocableMethod 
public static void NuevaTarea(list<lead> leadRecords )/*es insert y asigna el vendedor*/
   {account cuenta =new account();
    string asesor='';
    boolean flag=true;
    List<lead> cony = new List<lead>();
      map<Id,Proyecto__c> listProyects = new  map<Id,Proyecto__c>([   SELECT  Id, Name  FROM    Proyecto__c]);
      try{
            for(Lead lead : leadRecords) 
          {  system.debug ('crear lead.CI_Cod_Proyecto__c '+lead.CI_Cod_Proyecto__c);
             system.debug ('lead.CI_Proyecto__c '+lead.CI_Proyecto__c);

           system.debug ('lead.CI_Proyecto__c despues '+lead.CI_Proyecto__c);
            List<Lead> pw = [SELECT Id, CI_Movil__c,  CI_Origen__c,  Email,Ownerid,
                                   CI_Identificacion__c,CI_Asignado__c,CI_Identificacion_C__c,
                                   CI_Proyecto__c,Status,EsWeb__c
                                 from lead 
                                 where CI_Identificacion_C__c =:lead.CI_Identificacion__c
                                       and CI_Proyecto__c =: lead.CI_Proyecto__c 
                                       and Status in('New','Working')] ;
           
          List<account> cta = [SELECT  Id, Name
                                                    FROM    account 
                                                    WHERE   CI_Identificacion__c =: lead.CI_Identificacion__c] ; 
                  //lead.OwnerId=UserInfo.getUserId();
                  if(!Test.isRunningTest())
                     {flag=lead.EsWeb__c;}
                if(lead.CI_Origen__c =='Web' || flag) 
                  { if(pw.size()==0) {asesor=ValidaAsesor(lead.CI_Proyecto__c); }
                    if(pw.size()>0)  {asesor=pw[0].ownerid;}//es cony ingresando como proso
                     lead.OwnerId=asesor;//if (asesor==null || asesor==''){lead.OwnerId=ValidaAsesor(lead.CI_Proyecto__c);
                     //lead.EsWeb__c=false;
                     if(pw.size()>=0)//si es conyugue
                       { 
                        task tsk = new task();
                        tsk.WhoId = lead.id; 
                        tsk.Subject = 'Cotizacion Web'; 
                        tsk.Priority = 'Normal'; 
                        tsk.Status = 'Open'; 
                        tsk.OwnerId=asesor;
                        tsk.ActivityDate = System.Today(); 
                        insert tsk;
}
                  }
                 if (cta.size()==0)
                    {
                    cuenta.CI_Apellidos_C__c	=	lead.CI_Apellidos_C__c;
                    cuenta.CI_Ciudad__c	=	lead.CI_Ciudad__c;
                    cuenta.CI_Email__c	=	lead.email;
                    cuenta.CI_Fecha_Nacimiento_C__c	=	lead.CI_Fecha_Nacimiento_C__c;
                    cuenta.CI_Fecha_ultima_gestion__c	=	lead.CI_Fecha_ultima_gestion__c;
                    cuenta.CI_Horario__c	=	lead.CI_Horario__c;
                    cuenta.CI_Identificacion_C__c	=	lead.CI_Identificacion_C__c;
                    cuenta.CI_Identificacion__c	=	lead.CI_Identificacion__c;
                    cuenta.CI_Medio_Contacto__c	=	lead.CI_Medio_Contacto__c;
                    cuenta.FirstName=   lead.FirstName;             
                    cuenta.LastName=lead.LastName;
                    cuenta.MiddleName=lead.MiddleName;
                    cuenta.Suffix=lead.Suffix;
                    cuenta.CI_Nombre_C__c	=	lead.CI_Nombre_C__c;
                    cuenta.CI_Origen__c	=	lead.CI_Origen__c;
                    cuenta.CI_Pais__c	=	lead.CI_Pais__c;
                    cuenta.CI_Proyecto__c	=	lead.CI_Proyecto__c;
                    cuenta.CI_Tipo_Ident_C__c	=	lead.CI_Tipo_Ident_C__c;
                    cuenta.CI_Tipo_Identi__c	=	lead.CI_Tipo_Iden__c;
                    cuenta.CI_Tipo_Persona__c	=	lead.CI_Personeria__c;
                    cuenta.CI_Tipo_de_Cliente__c	=	lead.CI_Tipo_de_Cliente__c;
                   // cuenta.Name	=	lead.Name;
                   if(lead.CI_Origen__c =='Web' || lead.EsWeb__c) 
                     {cuenta.OwnerId	=asesor;}
                   else
                     {cuenta.OwnerId=UserInfo.getUserId();} 
                    cuenta.CI_Movil__c	=	lead.CI_Movil__c;
                    cuenta.Phone	=	lead.Phone;
                    //cuenta.RecordTypeId	=	lead.RecordTypeId;
                    insert cuenta;
                    //CrearTarea.Nuevatarea(lead.id,cuenta.id,'I');      
                    } 
              } 
           update leadRecords;
         }                                                                
     catch(Exception ex0) {
        System.debug('Error de Prospecto: '+ex0.getLineNumber()+'---'+ex0.getMessage());  
        //list<Opportunity> op = new list<Opportunity>();
   }   
          
    }
 public static string ValidaAsesor(string proyecto )
    {   list<Asignacion_Web_to_Lead__c> VEND = [SELECT Id, CI_Usuario__c,CI_Usuario__R.email, CI_Usuario__R.Name, CI_Usuario_Activo_Web__c, CI_Proyecto__c, 
                                 CI_Cantidad_LA__c, CI_Fecha_Ultima_Asignacion__c FROM Asignacion_Web_to_Lead__c 
                                 WHERE  Proyecto_vendedor__c =: proyecto and CI_Usuario_Activo_Web__c=:true ORDER BY CI_Fecha_Ultima_Asignacion__c ASC limit 1];
                                 //CI_Usuario__c=:'0053i000002NMEfAAO'CI_Proyecto__c =: updlead[0].CI_Cod_Proyecto__c ];
        VEND[0].CI_Fecha_Ultima_Asignacion__c=DateTime.now();
        UPDATE VEND;
        return VEND[0].CI_Usuario__c;
    }
}