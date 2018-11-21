<cfif structkeyExists(session,'loggedInUser')>
	<cfinclude template="header.cfm"> 
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="activityStyle.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.11.4/themes/ui-lightness/jquery-ui.css" />
<link rel="stylesheet" href="//cdn.jsdelivr.net/gh/dmhendricks/bootstrap-grid-css@4.1.3/dist/css/bootstrap-grid.min.css" />
</head>
<body>
<div id="activityView">
	<i class="fa fa-plus" title="Add Activity" onclick="activityModule.newActivity()" id="addActivity"></i>
	<span id="msg"></span>
	


	<div id="newActivity">
		<form method="post">
			<i class="fa fa-close" title="cancel" onclick="activityModule.back()" id="cancel"></i>
			<h3>ADD ACTIVITY</h3> 
			<label>Description:</label> <span id="error"> </span>
			<textarea rows="3" cols="10" id="description" name="description"></textarea>
			<label>Assign to:</label>
			<select id="users" name="user_id"> </select>
			<label>Priority:</label>
			<select id="aPrioirty" name="aPriority"> 
			<option> HIGH </option>
			<option> MEDIUM </option>
			<option> LOW </option> </select>
			<label>Due Date:</label> <span id="errorDate"> </span>
			<input type="date" id="date">

			<i class="fa fa-check" title="Add" onclick="activityModule.addActivity()" id="save"></i>
		</form>
	</div>

	<div id="activityList">
		<table style="width: 100%;"><tr><td><h1> ACTIVITY LIST </h1></td><td><div class="search"><i class="fa fa-search" aria-hidden="true"></i><input class="gsearch" id="global"  placeholder="Search" type="text"></div></td></tr></table>
<div class="bootstrap-wrapper">
	<div class="container" style="max-width: 1340px">
				<div class="row">
					<div class="col-md-3 border tabHead" > Todo <div class="search"><i class="fa fa-search" aria-hidden="true"></i><input class="cSearch" placeholder="Search"  id="todoSearch" type="text"></div> </div>
					<div class="col-md-3 border tabHead" > In Progress<div class="search"><i class="fa fa-search" aria-hidden="true"></i><input class="cSearch" placeholder="Search"  id="progSearch" type="text"> </div></div>
					<div class="col-md-3 border tabHead" > Awaiting QA<div class="search"><i class="fa fa-search" aria-hidden="true"></i><input class="cSearch" placeholder="Search"  id="waitSearch" type="text"></div></div>
					<div class="col-md-3 border tabHead" > Done<div class="search"><i class="fa fa-search" aria-hidden="true"></i><input class="cSearch"  placeholder="Search"  id="doneSearch" type="text"></div> </div>
			</div>
				<div class="row" >
				
					<div class="col-md-3 border tabBody" id="todo" ondrop="activityModule.drop(event)" ondragover="activityModule.allowDrop(event)"></div>
					<div class="col-md-3 border tabBody" id="inProgress" ondrop="activityModule.drop(event)" ondragover="activityModule.allowDrop(event)" ></div>
					<div class="col-md-3 border tabBody" id="waiting" ondrop="activityModule.drop(event)" ondragover="activityModule.allowDrop(event)"></div>
					<div class="col-md-3 border tabBody" id="done" ondrop="activityModule.drop(event)" ondragover="activityModule.allowDrop(event)"></div>
				</div>
			</div>
	
	</div>
		</div>
 <a href="dashboard.cfm" id="back"> <i class="fa fa-angle-double-left"></i> Back</a> 
</div>
</body> 
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="activities.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script>
	//method that is called when the document is completely loaded
	$(document).ready(function(){
		activityModule.init();
	});
	</script>

</html>
	<cfelse>
	 <cflocation url="login.cfm" />	
</cfif>