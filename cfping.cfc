<cfcomponent output="false">
	<cfscript>
		function init(){
			var variables = structNew();
			variables.os = getOS();
			
			return variables;
		}
		
		public function checkServer(server){
			var ping = ping(ARGUMENTS.server);
			var httpReq = httpReq(ARGUMENTS.server);
			var status = 'online';
			
			if((ping EQ 'online') AND (httpReq EQ 'online'))status = 'online';
			else if((ping EQ 'online' AND httpReq EQ 'offline') OR (httpReq EQ 'online' AND ping EQ 'offline'))status = 'offline';
			else if((ping EQ 'offline') AND (httpReq EQ 'offline'))status = 'offline';
			
			return status;
		}
	</cfscript>

	<cffunction name="ping" access="private" output="false" returntype="string">
		<cfargument name="server" type="string" required="true" />
		<cfset var status = 'offline' />
		<cfset var pingReturn = '' />
		<cfset var pingAttr = structNew() />
				
		<cfset pingAttr.arguments = ARGUMENTS.server />
		<cfscript>
			switch(variables.os){
				case 'windows':
					pingAttr.name = 'ping.exe';
					pingAttr.arguments = pingAttr.arguments & ' -n 1';
				break;
				case 'mac,linux':
					pingAttr.name = 'ping';
					pingAttr.arguments = '-c 1 ' & pingAttr.arguments;
				break;
			}
		</cfscript>
		
		<cfexecute attributeCollection="#pingAttr#" timeout="60" variable="pingReturn" />
		
		<cfset status = pingHandler(pingReturn) />
				
		<cfreturn status />
	</cffunction>
	
	<cffunction name="httpReq" access="private" output="false" returntype="string">
		<cfargument name="server" type="string" required="true" />
		<cfset var status='online' />
		
		<cfreturn status />
	</cffunction>
	
	<cfscript>
		private function pingHandler(pingObj){
			var status = 'online';
			var lossAmt = '0';
			
			var lossAmt = REfindNoCase('[0-9]{1,3}% packet loss',pingObj);
			lossAmt = REfindNoCase('[0-9]{1,3}',lossAmt);
			
			if(lossAmt LT 100)status = 'offline ' & lossAmt & '% loss';
			return status;
		}
		
		public function getOS(){
			var os = '';
			
			if(find('Windows',SERVER.OS.name))os = 'windows';
			else if(find('Mac',SERVER.OS.name))os ='mac';
			else if(find('Linux',SERVER.OS.name))os = 'linux';
			
			return os;
		}
	</cfscript>
</cfcomponent>