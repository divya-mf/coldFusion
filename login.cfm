<cfset msg = " " />
<cfif isdefined("form.loginForm")>
  
   <cfquery name="checkLogin">
     SELECT id,fname,lname FROM user WHERE email = <cfqueryparam value="#form.email#" cfsqltype="cf_sql_varchar" /> AND password = <cfqueryparam value="#form.pw#" cfsqltype="cf_sql_varchar" />    
    </cfquery>

		<cfset session.fname = checkLogin.fname>
		<cfset session.lname = checkLogin.lname>
    <cfif #checkLogin.recordCount# neq 0>
		 <cfset msg = " " />
        <cflocation url="./dashboard.cfm"/>
        <cfelse>
            <cfset msg = "Incorrect details." />
        
    </cfif> 
   
</cfif>
            

<html>
<head>
<link rel="stylesheet" href="style.css">
</head>
<body>
  <div id="login">
  <h2>Login Here</h2>
  <p id="msg"> <cfif len(msg)>
	  <cfoutput> #msg# </cfoutput>
	  </cfif> </p>
    <form method = "post">
      <label for="fname">Email ID</label>
      <input type="email" id="email" name="email" placeholder="Your email">

      <label for="lname">Password</label>
      <input type="password" id="pw" name="pw">
      <input type="submit" name= "loginForm" class="loginbtn">
    </form>
      <div class="signin">
    <p>Don't have an account? <a href="form.html">Sign Up</a>.</p>
	</div>
  </div>

</body>
</html>
