
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
  service {'firewalld':
    ensure => stopped,
    enable => false,
  }
  exec { 'ifup':
    command     => "/sbin/ifup $tse_dockerhost::interface",
    refreshonly => true,
  }
}
