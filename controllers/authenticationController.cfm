<cfif structkeyExists(URL,'action')>
	<cfset method= #URL.action#/>
</cfif>

<cfswitch expression="#method#"> 
	
    <cfcase value="register">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("form.FNAME") AND isDefined("form.LNAME") AND isDefined("form.EMAIL")AND isDefined("form.DB") >
			<cfset isInserted = application.authenticationService.insertUser(form)/>
			<cfset jsondata =  SerializeJSON(isInserted)/>
		</cfif>
    </cfcase>
    
    <cfcase value="login">
		<cfset jsondata =  SerializeJSON("IMPROPER DATA")/> 
		<cfif isDefined("form.EMAIL") AND isDefined("form.PW")>
			<cfset isInserted = application.authenticationService.loginUser(form)/>
			<cfset jsondata =  SerializeJSON(isInserted)/>
		</cfif>
	</cfcase>

    <cfdefaultcase>
		<cfheader statuscode="404" statustext="Not Found" />
		<cfset jsondata =  SerializeJSON("404 PAGE NOT FOUND")/>
	</cfdefaultcase> 
</cfswitch>

	<cfoutput>#jsondata#</cfoutput>