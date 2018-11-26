<cfcomponent displayname="authenticationService" output="false">
	<!--- method to add user --->
	<cffunction name="insertUser" access="remote" returntype="any">
		<cfargument name="form" type="any" required="true"/>
		<cfset var isInserted = 0 />
		<cfquery name="checkEmail" datasource="trial">
			SELECT id FROM user WHERE email = <cfqueryparam value="#arguments.form.EMAIL#" cfsqltype="cf_sql_varchar" />    
		</cfquery>
		<cfif #checkEmail.recordCount# eq 0>
			<!--- insert data into db --->
			<cfquery result="qryResult">
				INSERT INTO user
				(
					fname, lname, email, dob, bloodGroup, password, gender
				)
				VALUES
				(
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.FNAME#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.LNAME#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.EMAIL#" />,
					<cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.form.DB#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.BGROUP#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.PW#" />,
					<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.GENDER#" />

				) 
			</cfquery>
			<cfif #qryResult.recordCount# gt 0>
				<cfset var isInserted = 1 />
			</cfif>
		</cfif>
		<cfreturn isInserted />
	</cffunction>

	<!--- method to check whether the login credentials are correct--->
	<cffunction name="loginUser" access="remote" returntype="any">
		<cfargument name="form" type="any" required="true"/>
		<cfset var isExists = 0 />
			<!--- authentication check --->
			<cfquery name="checkLogin">
				SELECT id,fname,lname,role,gender,dob,bloodGroup FROM user WHERE email = <cfqueryparam value="#arguments.form.EMAIL#" cfsqltype="cf_sql_varchar" />
				 AND password = <cfqueryparam value="#arguments.form.PW#" cfsqltype="cf_sql_varchar" />    
			   </cfquery>				
			   <cfif #checkLogin.recordCount# neq 0>
				<!--- storing the logged in user data in a session variable --->
				   <cfset session.loggedInUser = {'fname'=  checkLogin.fname, 'lname'=  checkLogin.lname,'userId'=  checkLogin.id, 'role'= checkLogin.role,'gender'= checkLogin.gender,'dob'= checkLogin.dob,'bGroup'= checkLogin.bloodGroup}/>	
				   <cfset var isExists = 1 />
				</cfif> 
		<cfreturn isExists />
	</cffunction>
	
</cfcomponent>