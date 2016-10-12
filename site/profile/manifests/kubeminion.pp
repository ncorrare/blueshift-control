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
    content => erb('profile/flanneld.erb', { 'kubemaster' => $kubemaster }),
    require => Package['flannel'],
  }

  file { '/etc/kubernetes/config':
    ensure  => file,
    content => erb('profile/config.erb', { 'kubemaster' => $kubemaster }),
    require => Package['kubernetes'],
  }

  file { '/etc/kubernetes/kubelet':
    ensure  => file,
    content => erb('profile/kubelet.erb', { 'kubemaster' => $kubemaster }),
    require => Package['kubernetes'],
  }

  service { ['kube-proxy', 'kubelet', 'docker', 'flanneld']:
    ensure => running,
    enable => true,
  }
}

