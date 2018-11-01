<body>
  
    <cfquery name="myQuery" datasource="trial"> 
    SELECT * FROM trial WHERE id=<cfqueryparam value=1 cfsqltype="cf_sql_char" />
</cfquery>
    <cfdump var="#myQuery#" />
    
  
    
    <cfoutput query="myQuery">
    #myquery.CurrentRow# - #myquery.name# - #myquery.age#<br />
</cfoutput>
    
    
    
   <!---  <cfquery result="qryResult" datasource="trial">
   INSERT INTO trial
    (
        name, age
    )
    VALUES
    (
        <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="New Item" />,
        <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="31" />
        
       
    ) 
        DELETE FROM trial WHERE name=<cfqueryparam value="New Item" cfsqltype="cf_sql_varchar" />
</cfquery>

<cfdump var="#qryResult#" /> --->
    
     <cfquery name="myQueryAll" datasource="trial"> 
    SELECT * FROM trial
</cfquery>
     <cfoutput query="myQueryAll">
    #myqueryAll.CurrentRow# - #myqueryAll.name# - #myqueryAll.age#<br />
</cfoutput>
    
    
    
   <!---  <cfloop list="#form.fieldNames#" index="i">
    <li><cfoutput>#i# = #form[i]#</cfoutput></li>
</cfloop>
    <cfoutput>"#form.email#" </cfoutput>--->
</body>