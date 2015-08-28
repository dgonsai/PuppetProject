class zabbix_client::install{
    
	Exec{
	    path => ['/usr/bin', 'bin', 'usr/sbin'], provider => 'shell'
	}

	exec{'Update':
	    command => "sudo apt-get -y update",
	}

	exec{'Install Agent Server':
		command => "sudo apt-get install zabbix-agent",
		require => Exec['Update']
	}
	
	exec{'Change Server':
	    command => 'sudo sed -i "s/127.0.0.1/10.50.15.184/g" /etc/zabbix/zabbix_agentd.conf',
		require => Exec['Install Agent Server']
	}
	
	exec{'Server Password':
	    command => "sudo service zabbix-agent restart",
	    require => Exec["Change Server"]
	}
	
}
