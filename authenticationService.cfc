<cfcomponent displayname="authenticationService" output="false">
	<cffunction name="insertUser" access="public" returntype="boolean">
		<cfargument name="fname" type="string" required="true"/>
		<cfargument name="lname" type="string" required="true"/>
		<cfargument name="email" type="string" required="true"/>
		<cfargument name="dob" type="date" required="true"/>
		<cfargument name="blood_group" type="string" required="false"/>
		<cfargument name="password" type="string" required="true"/>
		<cfargument name="gender" type="string" required="true"/>
		
		<cfset var isInserted = false />
		
		<!--- insert data into db --->
		<cfquery result="qryResult">
           INSERT INTO user
            (
                fname, lname, email, dob, bloodGroup, password, gender
            )
            VALUES
            (
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.fname#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.lname#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.email#" />,
                <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.dob#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.blood_group#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.password#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.gender#" />

            ) 
         </cfquery>
		<cfif #qryResult.recordCount# gt 0>
			<cfset var isInserted = true />
		</cfif>
		<cfreturn isInserted />
	</cffunction>
</cfcomponent>