class profile::kubemaster {
  include epel
  include ntp
  package { ['etcd','kubernetes']:
    ensure => installed,
  }
  file { '/etc/etcd/etcd.conf':
    ensure  => present,
    source  => 'puppet:///modules/kube_platform/etcd.conf',
    require => Package['etcd'],
    before  => Service['etcd'], 
  }
  file { '/etc/kubernetes/apiserver':
    ensure  => present,
    source  => 'puppet:///modules/kube_platform/apiserver',
    require => Package['kubernetes'],
    before  => Service['kube-apiserver'],
  }
  service { ['etcd','kube-apiserver','kube-controller-manager','kube-scheduler']:
    ensure => 'running',
    enable => 'true',
  }
  exec { 'etcdctl mk /atomic.io/network/config \'{"Network":"172.17.0.0/16"}\'':
    unless  => 'etcdctl get /atomic.io/network/config',
    path    => '/bin',
    require => Service['etcd'],
  }

}
