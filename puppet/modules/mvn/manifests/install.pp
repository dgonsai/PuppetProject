class mvn::install(
  $mvn_archive = 'apache-maven-3.3.3-bin.tar.gz',
  $mvn_home = '/opt/mvn',
  $mvn_folder = 'apache-maven-3.3.3' )
{

  Exec{
    path => ["/usr/bin", "/bin", "/usr/sbin"]
  }

  exec { 'download mvn' :
   cwd     => '/opt',   
   command => "wget http://10.50.20.28:8080/aaron/downloads/apache-maven-3.3.3-bin.tar.gz",
   timeout => 0,
  }

  exec { 'extract mvn' :
    cwd     => '/opt',
	require => Exec['download mvn'],
	command => "tar zxvf apache-maven-3.3.3-bin.tar.gz",
  }

}