# installing artifactory
class artifactory::install {
  $version = '3.5.2'
  $sourceforge = 'http://garr.dl.sourceforge.net/project'
  package{'unzip':
    ensure  => present
  }

  archive { "artifacory-${version}":
    url              => "${sourceforge}/artifactory/artifactory/${version}/artifactory-${version}.zip",
    digest_string    => 'c4056ba50a90c882880c838028d151b6',
    src_target       => '/opt',
    target           => '/usr/share',
    follow_redirects => true,
    extension        => 'zip',
    require          => Package['unzip'],
  }

  package{'openjdk-7-jre':
    ensure  => present
  }

  exec{'install artifactory':
    command => "/usr/share/artifactory-${version}/bin/installService.sh",
    user    => 'root',
    require => [Archive["artifacory-${version}"],
                Package['openjdk-7-jre']]
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
