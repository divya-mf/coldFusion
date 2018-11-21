
<cfcomponent displayname="activitiesService" output="false">
	<!--- method to fetch all users --->	
		<cffunction name="getAllUsers" access="public" returntype="any" output="yes">
			 <cfset userDetails = [] />
			<!--- fetch users from db --->
			<cfquery name="fetchUsers">
			   SELECT * FROM user
				<cfif #session.loggedInUser.role# eq "employee">
			WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
		</cfif>
			 </cfquery>	
			<cfset i=1 />
			<cfloop query="fetchUsers">
				<cfset userDetails[i]['id'] = #fetchUsers.id# />
				<cfset userDetails[i]['fname'] = #fetchUsers.fname# />
				<cfset userDetails[i]['lname'] = #fetchUsers.lname# />
				<cfset userDetails[i]['email'] = #fetchUsers.email# />
				
				<cfset i++ />
    	</cfloop>
			<cfreturn userDetails />
		</cffunction>
	
	<!--- method to fetch all activities --->
	<cffunction name="getAllActivities" access="public" returntype="any">	
		 <cfset activityDetails = [] />
		<!--- fetch users from db --->
		<cfquery name="fetchActivities">
           SELECT ac.*, u.fname,u.lname FROM activities ac JOIN user u ON ac.userID = u.id
			<cfif #session.loggedInUser.role# eq "employee">
			 WHERE ac.userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
			</cfif>
         </cfquery>
		<cfset i=1 />
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
	
	<!--- method to fetch all activities by search --->
	<cffunction name="getActivitiesBySearch" access="remote" returntype="any">
		<cfargument name="status" type="string" required="false"/>
		<cfargument name="value" type="string" required="true"/>
		 <cfset searchedActivities = [] />
		<!--- fetch users from db --->
		
		
		<cfquery name="fetchSearchResults">
            SELECT ac.*, u.fname,u.lname FROM activities ac JOIN user u ON ac.userID = u.id WHERE (ac.title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" /> OR u.fname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" /> OR u.lname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.value#%" />) 
         
		<cfif len(arguments.status)>
			
				AND  ac.status =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" />
      
		</cfif>
			
		<cfif #session.loggedInUser.role# eq "employee">
			AND ac.userId = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.loggedInUser.userId#" />
		</cfif>	
			   </cfquery>
		<cfset i=1 />
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
		<cfargument name="title" type="string" required="true"/>
		<cfargument name="userId" type="any" required="true"/>
		<cfargument name="priority" type="string" required="true"/>
		<cfargument name="dueDate" type="date" required="true"/>
		
		<cfset var isInserted = 0 />
		
		<!--- insert data into db --->
		<cfquery result="insertActivity">
           INSERT INTO activities
            (
                title, priority, userId, dueDate
            )
            VALUES
            (
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.title#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.priority#" />,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#" />,
                <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.dueDate#" />
                

            ) 
         </cfquery>
		<cfif #insertActivity.recordCount# gt 0>
			<cfset var isInserted = 1 />
		</cfif>
		<cfreturn isInserted/>
	</cffunction>
	
</cfcomponent>