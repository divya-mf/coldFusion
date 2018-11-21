<cfif structkeyExists(URL,'action')>
	<cfset method= #URL.action#/>
</cfif>
<cfset activitiesService = createobject('component','CFAssignments.components.activitiesService') />
<cfif method eq "getAllUsers">
	<cfset userDetails = activitiesService.getAllUsers()/>
	<cfset jsondata =  SerializeJSON(userDetails)/>
</cfif>
<cfif method eq "getAllActivities">
	<cfset activityDetails = activitiesService.getAllActivities()/>
	<cfset jsondata =  SerializeJSON(activityDetails)/>
</cfif>
<cfif method eq "getActivitiesBySearch">
	
	
	<cfset searchDetails = activitiesService.getActivitiesBySearch(#URL.status#,#URL.value#)/> 
	<cfset jsondata =  SerializeJSON(searchDetails)/> 

</cfif>
<cfif method eq "addActivity">
	<cfset activityAdded = activitiesService.addActivity(#form.title#,#form.userId#,#form.priority#,#form.dueDate#)/>
	<cfset jsondata =  SerializeJSON(activityAdded)/>
</cfif>
  <cfoutput>#jsondata#</cfoutput>