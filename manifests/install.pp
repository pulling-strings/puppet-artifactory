# installing artifactory
class artifactory::install {

  $version = '3.5.3'
  $sourceforge = 'http://garr.dl.sourceforge.net/project'

  package{'unzip':
    ensure  => present
  }

  if($::artifactory::pro == false){
    $install_path = "artifactory-${version}"
    archive { "artifacory-${version}":
      url              => "${sourceforge}/artifactory/artifactory/${version}/artifactory-${version}.zip",
      digest_string    => '64bf5a16392512dd4c55c0bdf6702821',
      src_target       => '/opt',
      target           => '/usr/share',
      follow_redirects => true,
      extension        => 'zip',
      require          => Package['unzip'],
    } -> Exec['install artifactory']
  } else {
    $install_path = "artifactory-powerpack-${version}"
    archive::extract{"artifactory-powerpack-standalone-${version}":
      ensure     => present,
      src_target => '/vagrant',
      target     => '/usr/share',
      extension  => 'zip',
      require          => Package['unzip'],
    } -> Exec['install artifactory']
  }

  package{'openjdk-7-jre':
    ensure  => present
  }

  exec{'install artifactory':
    command => "/usr/share/${install_path}/bin/installService.sh",
    user    => 'root',
    require => Package['openjdk-7-jre']
  }

  file{'/etc/artifactory/':
    ensure  => directory
  }

  file {'/etc/artifactory/default':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/artifactory/default',
    owner   => root,
    group   => root,
    require => File['/etc/artifactory']
  }

  service{'artifactory':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    require   => [File['/etc/artifactory/default'],Exec['install artifactory']]
  }

}
