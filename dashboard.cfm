<cfif structkeyExists(session,'loggedInUser')>
	<cfoutput>
	<H1>Hello #session.loggedInUser.lname#</H1>
	<cfquery name="userDetails">
	SELECT * FROM user WHERE id = <cfqueryparam value="#session.loggedInUser.userId#" cfsqltype="cf_sql_varchar" /> 
	</cfquery>
	<h1>User Details:</h1>
		<div id= "details">
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
	<a href="login.cfm?logout" class="dropbtn">Logout</a>
<cfelse>
	 <cflocation url="login.cfm" />	
</cfif>