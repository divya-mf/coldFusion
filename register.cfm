<cfset requestBody = toString( getHttpRequestData().content ) />
<!--- to make sure it's a JSON value. --->
<cfset userData=deserializeJSON( #requestBody# ) />
<cfif isJSON( requestBody )>
    <cfquery name="checkEmail" datasource="trial">
     SELECT id FROM user WHERE email = <cfqueryparam value="#userData['email']#" cfsqltype="cf_sql_varchar" />    
    </cfquery>
	 <cfset jsondata =  SerializeJSON(0)/>
    <cfif #checkEmail.recordCount# eq 0>
		
		<cfset authenticationService = createobject('component','CFAssignments.components.authenticationService') />
		<cfset isInserted = authenticationService.insertUser(userData.fname,userData.lname,userData.email,userData.db,userData.blood_group,userData.password,userData.gender  )/>
        <cfset jsondata =  SerializeJSON(1)/>
    </cfif> 
	  <cfoutput>#jsondata#</cfoutput>
</cfif>

