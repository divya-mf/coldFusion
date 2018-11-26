<cfcomponent>
	<cfset this.name= 'userAuthentication'/>
	<cfset this.sessionManagement=true/>
	<cfset this.datasource= 'trial'/>
	
	<cffunction name="OnApplicationStart"> 
		<cfset application.authenticationService = createobject('component','CFAssignments.components.authenticationService') />
		<cfset application.activitiesService = createobject('component','CFAssignments.components.activitiesService') />
	</cffunction>
	
	<cffunction name="OnRequestStart"> 
		<cfif structkeyExists(URL,'logout')>
	        <cfset structdelete(session,'loggedInUser')/>
	   </cfif>
	</cffunction>
	
	<cffunction name="onMissingTemplate"> 
		<cflocation url="404.cfm" addToken="false" /> 
	</cffunction>
	
	<cffunction name="onError" returnType="void" output="true">
		<cflocation url="error.cfm">
	</cffunction>
</cfcomponent>	