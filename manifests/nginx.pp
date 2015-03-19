# Setting up reverse proxy as mentioned under 
class artifactory::nginx {
  
  include ::nginx

  nginx::resource::vhost { "${::hostname}-http":
    ensure               => present,
    client_max_body_size => '2048M',
    access_log           => "/var/log/nginx/${::hostname}.access.log",
    listen_port          => '80'
  }

  nginx::resource::location { '/':
    ensure             => present,
    proxy              => 'http://localhost:8081',
    vhost              => "${::hostname}-http",
    proxy_set_header   => [
      'Host $host:$server_port',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Real-IP $remote_addr'
    ],
    proxy_read_timeout => '90'

  }

}
