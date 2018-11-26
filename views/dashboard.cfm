<cfif structkeyExists(session,'loggedInUser')>
	<cfinclude template="header.cfm"> 
	<cfoutput>
		<div id= "details">
			<h1>Your Details:</h1>
			<ul>
				<li> First Name  : #session.loggedInUser.fname# </li>
				<li> Last Name  : #session.loggedInUser.lname# </li>
				<li> Birth date  : #dateFormat(session.loggedInUser.dob,'mmm dd yyyy')# </li>
				<li> Gender  : #session.loggedInUser.gender# </li>
				<li> Blood Group  : #session.loggedInUser.bGroup# </li>
			</ul>
		</div>
	</cfoutput>
	
<cfelse>
	 <cflocation url="login.html" />	
</cfif>
