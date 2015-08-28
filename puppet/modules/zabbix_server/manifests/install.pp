class zabbix_server::install{
	$Name = '"zabbix"'
	$Host = '"localhost"'
	$Password = '"netbuilder"'
    $Create = "mysql -u root -e 'create user $Name@$Host identified by $Password'"
	$Privileges = "mysql -u root -e 'grant all privileges on zabbix.* to $Name@$Host'"
	
	
	
	Exec{
	    path => ['/usr/bin', 'bin', 'usr/sbin'], provider => 'shell'
	}

#	exec{'Update':
#	    command => "sudo apt-get -y update",
#		require => Exec['Update Hosts']
#	}

	exec{'Install Server':
		command => "sudo DEBIAN_FRONTEND=noninteractive aptitude install -y zabbix-server-mysql",
		require => Exec['Update Hosts']
	}
	
	exec{'Install':
	    command => "sudo apt-get install -y php5-mysql zabbix-frontend-php",
		require => Exec['Install Server']
	}
	
	exec{'Server Password':
	    command => "sudo sed -i -e '116iDBPassword=netbuilder' /etc/zabbix/zabbix_server.conf",
	    require => Exec["Install"]
	}
	
	exec{'Gunzip':
	    cwd     => '/usr/share/zabbix-server-mysql',
	    command => "sudo gunzip data.sql.gz images.sql.gz schema.sql.gz",
	    require => Exec["Server Password"]
	}
	
	exec{'SQL Create User':
        command => "$Create",
		require => Exec["Gunzip"]
	}
	
	exec{'SQL Create Database':
        command => "mysql -u root -e 'create database zabbix'",
		require => Exec["SQL Create User"]
	}
	
	exec{'SQL Privileges':
        command => "$Privileges",
		require => Exec["SQL Create Database"]
	}
	
	exec{'SQL Flush':
        command => "mysql -u root -e 'flush privileges'",
		require => Exec["SQL Privileges"]
	}
		
	
	exec{'Import Schema':
	    cwd     => '/usr/share/zabbix-server-mysql',
	    command => "mysql -u zabbix --password=netbuilder zabbix < schema.sql",
	    require => Exec["SQL Flush"]
	}
	
	exec{'Import Images':
	    cwd     => '/usr/share/zabbix-server-mysql',
	    command => "mysql -u zabbix --password=netbuilder zabbix < images.sql",
	    require => Exec["Import Schema"]
	}
	
	exec{'Import Data':
	    cwd     => '/usr/share/zabbix-server-mysql',
	    command => "mysql -u zabbix --password=netbuilder zabbix < data.sql",
	    require => Exec["Import Images"]
	}
	
	exec{'Copy Conf':
	    command => "sudo cp /usr/share/doc/zabbix-frontend-php/examples/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php",
	    require => Exec["Import Data"]
	}
	
	exec{'Change Password':
	    command => "sudo sed -i 's/zabbix_password/netbuilder/g' /etc/zabbix/zabbix.conf.php",
	    require => Exec["Copy Conf"]
	}
	
	exec{'Copy apache':
	    command => "sudo cp /usr/share/doc/zabbix-frontend-php/examples/apache.conf /etc/apache2/conf-available/zabbix.conf",
	    require => Exec["Change Password"]
	}
	
	exec{'Integrate Apache':
	    command => "sudo a2enconf zabbix.conf",
	    require => Exec["Copy apache"]
	}
	
	exec{'Alias Apache':
	    command => "sudo a2enmod alias",
	    require => Exec["Integrate Apache"]
	}
	
	exec{'Stop Apache':
	    command => "sudo /etc/init.d/apache2 stop",
	    require => Exec["Alias Apache"]
	}
	
	#exec{'Kill Apache':
	#    command => "sudo killall apache2",
	#    require => Exec["Stop Apache"]
	#}
	
	exec{'Restart Apache':
	    command => "sudo /etc/init.d/apache2 restart",
	    require => Exec["Stop Apache"]
	}
	
	exec{'Autostart Setup':
	    command => "sudo sed -i 's/no/yes/g' /etc/default/zabbix-server",
	    require => Exec["Restart Apache"]
	}
	
	exec{'Start Zabbix':
	    command => "sudo service zabbix-server start",
	    require => Exec["Autostart Setup"]
	}
	
	#exec{'Change Root':
	 #   command => "sudo sed -i 's//var/www/html//usr/share/zabbix/g' /etc/apache2/sites-available/000-default.conf",
	 #   require => Exec["Start Zabbix"]
	#}
	
	#exec{'Stop Apache1':
	#    command => "sudo /etc/init.d/apache2 stop",
	#    require => Exec["Change Root"]
	#}
	
	#exec{'Restart Apache1':
	#    command => "sudo /etc/init.d/apache2 restart",
	#    require => Exec["Kill Apache1"]
	#}
}
