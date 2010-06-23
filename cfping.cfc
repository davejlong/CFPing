<cfcomponent output="false">
	<cffunction name="init" output="false">

	</cffunction>
	
	<cffunction name="checkServer" access="public" output="false">
		<cfargument name="server" type="string" required="true" />
		
		<cfset ping = ping(ARGUMENTS.server) />
		<cfset httpReq = httpReq(ARGUMENTS.server) />
		
		<cfif (ping EQ 'online') AND (httpReq EQ 'online')>
			<cfset status = 'online' />
		<cfelseif (ping EQ 'online' AND httpReq EQ 'offline') OR (httpReq EQ 'online' AND ping EQ 'offline')>
			<cfset status = 'unsure' />
		<cfelseif (ping EQ 'offline') AND (httpReq EQ 'offline')>
			<cfset status = 'offline' />
		<cfelse>
			<cfset status = 'unsure' />
		</cfif>
		
		<cfreturn status />
	</cffunction>
	
	<cffunction name="ping" access="private" output="false" returntype="string">
		<cfargument name="server" type="string" required="true" />
		<cfset var status = "offline" />
		<cfset var pingReturn = "" />
		<cfset var pingAttr = ARGUMENTS.server />
		
		<cfset pingAttr = pingAttr & " -n 1" />
		<cftry>
			<cfexecute name="ping.exe" timeout="60" arguments="#pingAttr#" variable="pingReturn" />
		<cfcatch>
			<cfthrow message="ping process timed out" />
		</cfcatch>
		</cftry>
		
		<cfscript>
			if(find('Request timed out',pingReturn)){
				status = "offline";
			}else{
				status = "online";
			}
		</cfscript>

		
		<cfreturn status />
	</cffunction>
	
	<cffunction name="httpReq" access="private" output="false" returntype="string">
		<cfargument name="server" type="string" required="true" />
		<cfset var status="online" />
		
		<cfreturn status />
	</cffunction>
</cfcomponent>