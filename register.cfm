<cfset requestBody = toString( getHttpRequestData().content ) />
<!--- to make sure it's a JSON value. --->
<cfset userData=deserializeJSON( #requestBody# ) />
<cfif isJSON( requestBody )>
    <cfquery name="checkEmail" datasource="trial">
     SELECT id FROM user WHERE email = <cfqueryparam value="#userData['email']#" cfsqltype="cf_sql_varchar" />    
    </cfquery>
    <cfif #checkEmail.recordCount# eq 0>
        <cfquery result="qryResult">
           INSERT INTO user
            (
                fname, lname, email, dob, bloodGroup, password, gender
            )
            VALUES
            (
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['fname']#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['lname']#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['email']#" />,
                <cfqueryparam cfsqltype="CF_SQL_DATE" value="#userData['db']#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['blood_group']#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['password']#" />,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#userData['gender']#" />

            ) 
         </cfquery>
        <cfset jsondata =  SerializeJSON(1)>
        <cfoutput>#jsondata#</cfoutput>
    <cfelse>
         <cfset jsondata =  SerializeJSON(0)>
        <cfoutput>#jsondata#</cfoutput>
    </cfif> 
</cfif>

