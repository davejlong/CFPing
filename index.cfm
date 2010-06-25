<cfscript>
	cfping = createObject('component','cfping').init();
	status = cfping.checkServer('www.cagedata.com');
	writeOutput(status);
</cfscript>

<cfdump var="#SERVER#" />
