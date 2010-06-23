<cfscript>
	cfping = createObject('component','cfping');
	status = cfping.checkServer('www.cagedata.com');
	writeOutput(status);
</cfscript>