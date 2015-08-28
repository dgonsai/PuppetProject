class jenkins::install{

    Exec{
        path => ['/usr/bin', 'bin', '/usr/sbin'], provider => 'shell'
    }
	
	exec{'install yum':
	    cwd => '/opt',
	    command => 'sudo apt-get -y install yum',
		logoutput => on_failure
	}
		
    exec{'get jenkins':
	    cwd => '/opt',
		command => 'wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -',
		require => Exec['install yum']
	}
	
	exec{'rpm':
	    cwd => '/opt',
		require => Exec['get jenkins'],
		command => 'sudo sh -c "echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list"'
	}
	
	exec{'get updates':
	    cwd => '/opt',
		require => Exec['rpm'],
		command => 'sudo apt-get update'
	}
    
	exec{'install jenkins':
	    cwd => '/opt',
		require => Exec['get updates'],
		command => 'sudo apt-get -y install jenkins',
		logoutput => on_failure
	}	
	
	exec{'get updates':
	    cwd => '/opt',
		require => Exec['install jenkins'],
		command => 'sudo service jenkins stop'
	}
	
	exec{'change port':
	    cwd => '/opt',
		require => Exec['get updates'],
		command => "sudo sed -i 's/8080/8083/g' /etc/default/jenkins"
	}
		exec{'restart jenkins':
	    cwd => '/opt',
		require => Exec['change port'],
		command => 'sudo service jenkins start'
	}
	
}