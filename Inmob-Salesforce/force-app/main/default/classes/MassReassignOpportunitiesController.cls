public with sharing class MassReassignOpportunitiesController {
	public ApexPages.StandardSetController optySetController;
	public String filterId {get;set;}
	public String ErrorMsg {get;set;}
	public String optyQueryString;
	public List<cOpty> optyList {get;set;}
	public list<Opportunity> optyToUpdateList {get;set;}
	public Opportunity searchRecord {get;set;}
	public Reassign_Helper__c helperRecord{get;set;}
	public boolean isSuccess{get;set;}
	public boolean searchPerformed{get;set;}
	public boolean tooManyResults{get;set;}
	
	public Integer optyListSize {get{return optylist.size();}}
	public list<SelectOption> listviewoptions {
		get{
			List<SelectOption> tempList = new List<SelectOption>();
			tempList.add(new selectOption('None',System.Label.NoViewSelection));
			if (optySetController<>null)tempList.addAll(optySetController.getListViewOptions());
			return tempList;
			}
	}

	public MassReassignOpportunitiesController(){
		
		//Variable Init
		if (Schema.sObjectType.Opportunity.isAccessible()) {
			optyQueryString = 'SELECT name,StageName,Ownerid,CloseDate from Opportunity where isDeleted=false';
		} else {
			optyQueryString = '';
		}
		
		optyList = new List<cOpty>();
		optySetController = new ApexPages.Standardsetcontroller(Database.getQueryLocator(optyQueryString+' limit 1000'));
		filterId = listviewoptions[0].getValue();
		searchRecord = new Opportunity();
		helperRecord = new Reassign_Helper__c();
		isSuccess=false;
		searchPerformed = false;
		tooManyResults= false;
		
		//Apply the default filter
		//refreshOptyList();
	}
	
	/*========================================
	Applies the View filter to the Opty List
	==========================================*/ 
	public void refreshOptyList(){
		list<Opportunity> testList = new list<Opportunity>();
		
		optyList.clear();
		isSuccess = false;
		tooManyResults = false;
		if (filterId <> null && filterId<> 'None'){
			 optySetController.setFilterId(filterId);
			 testList = (list<Opportunity>)optySetController.getRecords();
			 searchPerformed = true;
		} else searchPerformed = false;
		System.debug('Filter used=>'+filterId);
		System.debug('Result #=>'+optySetController.getResultSize());
		Integer counter=0;
		for (Opportunity opty:testList){
			optyList.add(new cOpty(Opty));
			counter++;
			if (counter==999){
				tooManyResults=true;
				 break;
			}
		}
		

		
	}
	
	public void refreshOptyListBySearch(){
		optyList.clear();
		isSuccess = false;
		
		//resultList = new List<cResult>();
		String userFilterQuery='';
		if (searchRecord.Name<>null) 	userFilterQuery = ' and Name like \'%'+searchRecord.Name+'%\'';
		if (searchRecord.Type<>null) 	userFilterQuery += ' and Type = \''+searchRecord.type+'\'';
		if (searchRecord.StageName<>null) 	userFilterQuery += ' and StageName = \''+searchRecord.StageName+'\'';
		if (helperRecord.From__c<>null){
				DateTime startDate = DateTime.newInstance(helperRecord.From__c, Time.newInstance(0, 0, 0, 0));
			 	userFilterQuery += ' and CreatedDate >= '+startDate.format('yyyy-MM-dd')+'T00:00:00Z';
			 	
		}
		if (helperRecord.To__c<>null){
				DateTime endDate = DateTime.newInstance(helperRecord.to__c, Time.newInstance(0, 0, 0, 0));
			 	userFilterQuery += ' and CreatedDate <= '+endDate.format('yyyy-MM-dd')+'T00:00:00Z';
		
		}
		if (helperRecord.closedDate_From__c<>null){
				DateTime startDate = DateTime.newInstance(helperRecord.closedDate_From__c, Time.newInstance(0, 0, 0, 0));
			 	userFilterQuery += ' and CloseDate >= '+startDate.format('yyyy-MM-dd');
			 	
		}
		if (helperRecord.closedDate_To__c<>null){
				DateTime endDate = DateTime.newInstance(helperRecord.closedDate_to__c, Time.newInstance(0, 0, 0, 0));
			 	userFilterQuery += ' and CloseDate <= '+endDate.format('yyyy-MM-dd');
		
		}
		
		String optyQueryString =optyQueryString +  userFilterQuery ;
		optyQueryString += ' order by Name limit 1000';
		
		List<Sobject> sortedResults= new List<SObject>();
		try{
			sortedResults = Database.query(optyQueryString);
			searchPerformed = true;
		} catch (Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
		}
		System.debug('Requete => '+optyQueryString);

		for (SObject foundObject:sortedResults){
			Opportunity opty = (Opportunity)foundObject;
			optyList.add(new cOpty(opty));		
		}
	}
	
	
	/*===============================================
	Assign the selected opportunities to a new owner
	=================================================*/
	public void Assign(){     
        list<Opportunity> optyToUpdateList=new list<Opportunity>();
        list<Task> taskToUpdateList=new list<Task>();
        list<Event> eventToUpdateList = new List<Event>();
        for (cOpty opty:optyList)
            if (opty.selected)
                optyToUpdateList.add(new Opportunity(id=opty.oOpty.id, OwnerId=helperRecord.Assign_to__c));

        
        //We also need to reassign the open activities to the new owner
        //To do so, we first loop on all the opportunities to retrieve their Open Activities
        //Then we loop through the Task or Events and reassign them
        for(Opportunity tempOpty:[select id,(select id,isTask from OpenActivities order by ActivityDate DESC, LastModifiedDate DESC limit 500) from Opportunity where id in :optyToUpdateList]){
        	for (OpenActivity tempActivity:tempOpty.OpenActivities){
        		if (tempActivity.IsTask) taskToUpdateList.add(new Task(id=tempActivity.id,ownerId=helperRecord.Assign_to__c));
        		else EventToUpdateList.add(new Event(id=tempActivity.id,ownerId=helperRecord.Assign_to__c));
        	}
        }
        
        if (optyToUpdateList.size()+taskToUpdateList.size()+eventToUpdateList.size()>=10000) {
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.TooManyRowsError));
        } else{
        
	        if (Schema.sObjectType.Opportunity.isUpdateable()) {
				try
				{
					update optyToUpdateList;
				}
				catch (Exception e)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
				}
			}
	        
	       	try
	        {
				if (Schema.sObjectType.Task.isUpdateable()) {
	            	if (taskToUpdateList.size()>0) update taskToUpdateList;
				}

				if (Schema.sObjectType.Event.isUpdateable()) {
	            	if (eventToUpdateList.size()>0) update eventToUpdateList;
				}
	        }
	        catch (Exception e)
	        {
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
	        }
        
	        // Update the search results
	        integer n=optyList.size();
	        for (integer i=n-1;i>=0;i--){
	            if (optyList[i].selected) optyList.remove(i);
			}
			
			if (optyToUpdateList.size()>0) isSuccess = true;
        }		
	}
	
	/*==================================================
	Inner class helping identify selected opportunities
	====================================================*/
	public class cOpty{
		public Opportunity oOpty {get;set;}
		public Boolean selected {get;set;}
		
		public cOpty(Opportunity oOpty){
			this.oOpty = oOpty;
			selected=false;
		}
		
	}
	
}