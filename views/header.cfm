<link rel="stylesheet" href="../css/style.css">
<cfoutput>
	<table><tr><td>
		<H5>Welcome #session.loggedInUser.lname# !</H5></td>
		<td>
		<div class="headerMenu">
			<a href="dashboard.cfm" class="headbtn">Profile</a>
			<a href="activitiesList.cfm" class="headbtn">Activity List</a>
			<a href="login.html?logout" class="headbtn">Logout</a>
		</div>
		</td>
		</tr>
	</table>
	
</cfoutput>