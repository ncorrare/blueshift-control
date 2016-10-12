class profile::kubemaster {
  include epel
  include ntp
  package { ['etcd','kubernetes']:
    ensure => installed,
  }
  file { '/etc/etcd/etcd.conf':
    ensure  => file,
    source  => 'puppet:///modules/profile/etcd.conf',
    require => Package['etcd'],
    notify  => Service['etcd'], 
  }
  file { '/etc/kubernetes/apiserver':
    ensure  => file,
    source  => 'puppet:///modules/profile/apiserver',
    require => Package['kubernetes'],
    notify  => Service['kube-apiserver'],
  }
  service { ['etcd','kube-apiserver','kube-controller-manager','kube-scheduler']:
    ensure  => 'running',
    enable  => 'true',
    require => File['/etc/kubernetes/apiserver','/etc/etcd/etcd.conf'],
  }
  exec { 'etcdctl mk /atomic.io/network/config \'{"Network":"172.17.0.0/16"}\'':
    unless  => 'etcdctl get /atomic.io/network/config',
    path    => '/bin',
    require => Service['etcd'],
  }

}
