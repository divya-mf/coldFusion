<link rel="stylesheet" href="style.css">

<cfif structkeyExists(session,'loggedInUser')>
	<cfinclude template="header.cfm"> 
	<cfoutput>
	<cfquery name="userDetails">
	SELECT * FROM user WHERE id = <cfqueryparam value="#session.loggedInUser.userId#" cfsqltype="cf_sql_varchar" /> 
	</cfquery>
	
		<div id= "details">
			<h1>Your Details:</h1>
			<ul>
				<li> First Name  : #userDetails.fname# </li>
				<li> Last Name  : #userDetails.lname# </li>
				<li> Email Id : #userDetails.email# </li>
				<li> Birth date  : #dateFormat(userDetails.dob,'mmm dd yyyy')# </li>
				<li> Gender  : #userDetails.gender# </li>
				<li> Blood Group  : #userDetails.bloodGroup# </li>
			</ul>
		</div>


	</cfoutput>
	
<cfelse>
	 <cflocation url="login.cfm" />	
</cfif>
