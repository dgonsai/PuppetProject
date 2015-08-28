node 'Master.netbuilder.private'{
	include zabbix_server

}
node 'Agent.netbuilder.private'{
    #include java
	#include mvn
	#include jenkins
	#include git
	#include jira
	#include mcollective
	include zabbix_client
	
	#class {'::mcollective':
		#client => true,
		#middleware_hosts => ['Master.netbuilder.private']
	#}
}