
class profile::docker_ghost (
  $interface = undef,
)
  {
  include docker
  docker::image { 'ghost':
    require => Class['docker'],
  }
  if $interface {
    docker::run { 'ghostblog':
      image   => 'ghost',
      command => 'npm start',
      require => Docker::Image['ghost'],
      ports   => ['80:2368','2368:2368'],
      notify  => Exec['ifup'],
    }
  }
    else
    {
      docker::run { 'ghostblog':
        image   => 'ghost',
        command => 'npm start',
        require => Docker::Image['ghost'],
        ports   => ['80:2368','2368:2368'],
      }
    }
    firewall { '100 allow http and https access':
    port   => [80, 2368],
    proto  => tcp,
    action => accept,
  }
  exec { 'ifup':
    command     => "/sbin/ifup $tse_dockerhost::interface",
    refreshonly => true,
  }
}
