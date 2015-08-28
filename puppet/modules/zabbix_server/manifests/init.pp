class zabbix_server{
    include zabbix_server::key
    include zabbix_server::install
	include zabbix_server::config
}