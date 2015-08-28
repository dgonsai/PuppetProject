class zabbix_server::key{
	
	Exec{
        path => ['/usr/bin', 'bin', '/usr/sbin'], provider => 'shell'
    }
	
    exec{'Update Source':
		command => 'sudo sed -i -e "59ideb http://ppa.launchpad.net/tbfr/zabbix/ubuntu precise main" /etc/apt/sources.list'
	}
	
	exec{'Update Source-Deb':
		command => 'sudo sed -i -e "60ideb-src http://ppa.launchpad.net/tbfr/zabbix/ubuntu precise main" /etc/apt/sources.list',
		require => Exec['Update Source']
	}

	exec{'Add Key':
		command => "sudo apt-key add /opt/puppet/modules/zabbix_server/files/Key1",
		require => Exec['Update Source-Deb']
	}
	
	exec{'Update Hosts':
	    command => "sudo sed -i -e '2i10.50.15.184 Master zabbix' /etc/hosts",
		require => Exec['Add Key']
	}
}
