class jira::install{
	
	Exec{
        path => ['/usr/bin', 'bin', '/usr/sbin'], provider => 'shell'
    }
	
    exec{'download jira':
	    cwd => '/opt',
		command => 'sudo wget http://10.50.20.28:8080/aaron/downloads/atlassian-jira-6.4.9-x64.bin',
		timeout => 0
    }
	
	exec{'chmod jira':
	    require => Exec['download jira'],
	    cwd => '/opt',
		command => 'sudo chmod +x atlassian-jira-6.4.9-x64.bin'
    }
	
	exec{'install jira':
	    require => Exec['chmod jira'],
	    cwd => '/opt',
		command => 'sudo ./atlassian-jira-6.4.9-x64.bin -q'
    }
	
#	exec{'update port':
#	    require => Exec['install jira'],
#		cwd => '/opt',
#		command => "sudo sed -i 's/8080/8082/g' /opt/JIRA/conf/server.xml"
#	}
#	
#	exec{'start jira':
#	    require => Exec['update port'],
#	    cwd => '/opt',
#		command => 'sudo service jira start'
#	}	
}