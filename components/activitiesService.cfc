
<cfcomponent displayname="activitiesService" output="false">

	<!--- method to fetch all users --->	
		<cffunction name="getAllUsers" access="public" returntype="any" output="yes">
			<cfset var userDetails = [] />

			<!--- fetch users from db --->
			<cfquery name="fetchUsers">
			    SELECT id,fname,lname,email,dob,bloodGroup,gender FROM user

				<cfif #session.loggedInUser.role# eq "employee">
				WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
				</cfif>

			</cfquery>	

			<cfreturn fetchUsers />
		</cffunction>
	

	<!--- method to fetch all activities --->
	<cffunction name="getAllActivities" access="public" returntype="any">	
		<cfset var activityDetails = [] />

		<!--- fetch activities from db --->
		<cfquery name="fetchActivities">
           SELECT ac.*, u.fname,u.lname FROM activities ac JOIN user u ON ac.userID = u.id
		   
		   <cfif #session.loggedInUser.role# eq "employee">
			 WHERE ac.userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
		   </cfif>
			
			ORDER BY ac.id
		 </cfquery>
		 
		<cfset var i=1 />

		<cfloop query="fetchActivities">
			<cfset activityDetails[i]['id'] = #fetchActivities.id# />
			<cfset activityDetails[i]['title'] = #fetchActivities.title# />
			<cfset activityDetails[i]['priority'] = #fetchActivities.priority# />
			<cfset activityDetails[i]['createdOn'] = #DateTimeFormat(fetchActivities.createdOn,"mmm,dd yyyy")# />
			<cfset activityDetails[i]['userId'] = #fetchActivities.userId# />
			<cfset activityDetails[i]['status'] = #fetchActivities.status# />
			<cfset activityDetails[i]['dueDate'] = #DateTimeFormat(fetchActivities.dueDate,"mmm,dd yyyy")#/>
			<cfset activityDetails[i]['fname'] = #fetchActivities.fname# />
			<cfset activityDetails[i]['lname'] = #fetchActivities.lname# />
			<cfset i++ />
		</cfloop>
		
		<cfreturn activityDetails/>
	</cffunction>


	<!--- method to fetch activity by id --->
	<cffunction name="getActivityById" access="public" returntype="any">
		<cfargument name="id" type="numeric" required="true"/>	

		<cfset var activityDetails = [] />

	    <!--- fetch activities from db --->
	    <cfquery name="fetchActivityDetails">
		  SELECT id,title,priority,userId,status, CAST(dueDate as char) as dueDate FROM activities
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>
		
	    <cfreturn fetchActivityDetails/>
   </cffunction>


   <!--- method to update status of activity by id --->
	<cffunction name="updateStatus" access="public" returntype="any">
		<cfargument name="id" type="numeric" required="true"/>	
		<cfargument name="status" type="string" required="true"/>

		<cfset var activityDetails = [] />
		<cfset var isUpdated = 0 />

	   <!--- fetch activities from db --->
	   <cfquery result="updateActStatus">
			UPDATE activities SET
			status =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" />
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#" />
		</cfquery>

	   <cfif #updateActStatus.recordCount# gt 0>
		 <cfset isUpdated = 1 />
	   </cfif>

	   <cfreturn isUpdated/>
   </cffunction>
	

	<!--- method to fetch all activities by search --->
	<cffunction name="getActivitiesBySearch" access="remote" returntype="any">
		<cfargument name="status" type="string" required="false"/>
		<cfargument name="value" type="string" required="true"/>

		<cfset var searchedActivities = [] />

		<!--- fetch users from db as per the search criteria and logged in user's role--->
		
		<cfquery name="fetchSearchResults">
            SELECT ac.*, u.fname,u.lname FROM activities ac JOIN user u ON ac.userID = u.id 
			 WHERE (ac.title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" />
			 OR u.fname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" /> 
			 OR u.lname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" />) 
         
			<cfif len(arguments.status)>
				AND  ac.status =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" />
			</cfif>
			
			<cfif #session.loggedInUser.role# eq "employee">
				AND ac.userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
			</cfif>	
		</cfquery>

		<cfset var i=1 />

		<cfloop query="fetchSearchResults">
			<cfset searchedActivities[i]['id'] = #fetchSearchResults.id# />
			<cfset searchedActivities[i]['title'] = #fetchSearchResults.title# />
			<cfset searchedActivities[i]['priority'] = #fetchSearchResults.priority# />
			<cfset searchedActivities[i]['createdOn'] = #DateTimeFormat(fetchSearchResults.createdOn,"mmm,dd yyyy")# />
			<cfset searchedActivities[i]['userId'] = #fetchSearchResults.userId# />
			<cfset searchedActivities[i]['status'] = #fetchSearchResults.status# />
			<cfset searchedActivities[i]['dueDate'] = #DateTimeFormat(fetchSearchResults.dueDate,"mmm,dd yyyy")#/>
			<cfset searchedActivities[i]['fname'] = #fetchSearchResults.fname# />
			<cfset searchedActivities[i]['lname'] = #fetchSearchResults.lname# />
			<cfset i++ />
		</cfloop>
			
		<cfreturn searchedActivities/>
	</cffunction>
	
	<!--- method to add a new activity in db --->
	<cffunction name="addActivity" access="remote" returntype="boolean">	
		<cfargument name="form" type="any" required="true"/>
		
		<cfset var userId = session.loggedInUser.userId />
		<cfset var isInserted = 0 />

		<cfif isDefined("arguments.form.USERID")>
			<cfset userId = arguments.form.USERID />
		</cfif>
		
		<!--- insert data into db --->
		<cfquery result="insertActivity">
           INSERT INTO activities
            (
                title, priority, userId, dueDate
            )
            VALUES
            (
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.TITLE#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.PRIORITY#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#userId#" />,
                <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.form.DATE#" />
            ) 
		</cfquery>
		 
		<cfif #insertActivity.recordCount# gt 0>
			<cfset isInserted = 1 />
		</cfif>

		<cfreturn isInserted/>
	</cffunction>

	<!--- method to update an activity in db --->
	<cffunction name="updateActivity" access="remote" returntype="boolean">	
		<cfargument name="form" type="any" required="true"/>
		
		<cfset var userId = session.loggedInUser.userId />
		<cfset var isActUpdated = 0 />

		<cfif isDefined("arguments.form.USERID")>
			<cfset userId = arguments.form.USERID />
		</cfif>
		
		<!--- insert data into db --->
		<cfquery result="updateActivity">
           UPDATE activities SET 
            title = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.TITLE#" />,
            priority =    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.form.PRIORITY#" />,
            userId =    <cfqueryparam cfsqltype="cf_sql_integer" value="#userId#" />,
            dueDate =    <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.form.DATE#" />
            WHERE
			id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form.ACTID#" />
		</cfquery>
		
		<cfif #updateActivity.recordCount# gt 0>
			<cfset isActUpdated = 1 />
		</cfif>

		<cfreturn isActUpdated/>
	</cffunction>
	
</cfcomponent>