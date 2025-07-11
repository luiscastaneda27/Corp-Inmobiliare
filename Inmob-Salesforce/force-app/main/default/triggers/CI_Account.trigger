trigger CI_Account on Account (before insert, after insert, before update, after update) { 
  
      if (Trigger.isinsert ) { new CI_AccountHandler().run();}
    
     // if (Trigger.isupdate && Trigger.isafter){new CI_AccountHandler().run();}
    
      if (Trigger.isupdate && Trigger.isbefore)
        {
          for(Account item:trigger.new)
          {
            for(Account itemold:trigger.old)
              {
                if(itemold.CI_Identificacion__c != item.CI_Identificacion__c && itemold.CI_Identificacion__c!=null && item.CI_Identificacion__c !=null )
                {system.debug('itemold.ownerid '+itemold.ownerid );
                 system.debug('item.ownerid '+item.ownerid );
                    //new CI_AccountHandler().run();
                    }
               }
          }
      }
   
    
}