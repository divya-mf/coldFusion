<cfif structkeyExists(URL,'action')>
	<cfset method= #URL.action#/>
</cfif>


<!--- comparing the url attribute method with values in the cases and calling corresponding methods from the service--->
<cfswitch expression="#method#"> 
	
    <cfcase value="getAllUsers">
		<cfset userDetails = application.activitiesService.getAllUsers()/>
	    <cfset jsondata =  SerializeJSON(userDetails, 'struct' )/>
	</cfcase>
	
    <cfcase value="getAllActivities">
		<cfset activityDetails = application.activitiesService.getAllActivities()/>
		<cfset jsondata =  SerializeJSON(activityDetails)/>
	</cfcase>

	<cfcase value="getActivityById">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("URL.id")>
			<cfset activityData = application.activitiesService.getActivityById(URL.id)/>
			<cfset jsondata =  SerializeJSON(activityData, 'struct')/>
		</cfif>
	</cfcase>

	<cfcase value="updateStatus">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("URL.id") AND isDefined("URL.status")>
			<cfset status = application.activitiesService.updateStatus(URL.id, URL.status)/>
			<cfset jsondata =  SerializeJSON(status)/>
		</cfif>
	</cfcase>

	<cfcase value="updateActivity">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("form.TITLE") AND isDefined("form.PRIORITY") AND isDefined("form.DATE")>
			<cfset activityUpdated = application.activitiesService.updateActivity(form)/>
			<cfset jsondata =  SerializeJSON(activityUpdated)/>
		</cfif>
	</cfcase>
	
    <cfcase value="getActivitiesBySearch">
		<cfset jsondata =  SerializeJSON("IMPROPER SEARCH")/> 
		<cfif isDefined("URL.status") AND isDefined("URL.value") >
			<cfset searchDetails = application.activitiesService.getActivitiesBySearch(URL.status,URL.value)/> 
			<cfset jsondata =  SerializeJSON(searchDetails)/> 
		</cfif>
		
	</cfcase>
	
	<cfcase value="addActivity">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("form.TITLE") AND isDefined("form.PRIORITY") AND isDefined("form.DATE")>
			<cfset activityAdded = application.activitiesService.addActivity(form)/>
			<cfset jsondata =  SerializeJSON(activityAdded)/>
		</cfif>
	</cfcase>
	
    <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase> 
</cfswitch>

<cfoutput>#jsondata#</cfoutput>

  