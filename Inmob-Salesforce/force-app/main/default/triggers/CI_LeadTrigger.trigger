/**
**************************************************************************************************************
* @author           Intellect System href=<info@intellectsystem.net>
* @project          Inmobiliare - Implementación CRM
* @name             CI_LeadTrigger
* @description      Trigger of the object "Lead". DO NOT CREATE NEW TRIGGERS FOR THIS OBJECT.
* @changes
* ----------   ---------------------------   -----------------------------------------------------------------
* Date         Author                        Description
* ----------   ---------------------------   -----------------------------------------------------------------
* 2023-07-19   Intellect System              Initial version.
**************************************************************************************************************
*/
 
trigger CI_LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{    new CI_LeadHandler().run();
 
 }