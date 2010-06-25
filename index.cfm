<cfscript>
	cfping = createObject('component','cfping');
	status = cfping.checkServer('trogdorsrv01');
	//writeOutput(status);
</cfscript>

<cfdump var="#status#" />
