class profile::kubeminion (
  $kubemaster,
) {
  include epel
  include ntp
  package { ['flannel','kubernetes']:
    ensure => installed,
  }

  file { '/etc/sysconfig/flanneld':
    ensure  => file,
    content => template('profile/flanneld.erb'),
    require => Package['flannel'],
    notify  => Service['flanneld'],
  }

  file { '/etc/kubernetes/config':
    ensure  => file,
    content => template('profile/config.erb'),
    require => Package['kubernetes'],
    notify  => Service['kubelet','kube-proxy'],
  }

  file { '/etc/kubernetes/kubelet':
    ensure  => file,
    content => template('profile/kubelet.erb'),
    require => Package['kubernetes'],
    notify  => Service['kubelet'],
  }

  service { ['kube-proxy', 'kubelet', 'docker', 'flanneld']:
    ensure => running,
    enable => true,
  }
  service {'firewalld':
    ensure => stopped,
    enable => false,
  }
}

