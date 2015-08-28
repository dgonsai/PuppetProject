node 'Master.netbuilder.private'{
    include java
	include mvn
	include git
	include jira
	include jenkins
    include nexus
    include zabbix_server
}
node 'Agent.netbuilder.private'{
    include zabbix_client
}