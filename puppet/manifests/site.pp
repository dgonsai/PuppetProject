node 'Master.netbuilder.private'{
    include java
	include mvn
	install git
	install jira
	include jenkins
    include nexus

}
node 'Agent.netbuilder.private'{
    include java
	include mvn
	install git
	install jira
	include jenkins
    include nexus

}