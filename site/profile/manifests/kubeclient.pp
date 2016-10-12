class profile::kubeclient {
  include epel
  include ntp
  package { 'kubernetes':
    ensure => installed,
  }
  package { 'gcc-c++':
    ensure => installed,
  }
  package { 'activesupport':
    ensure   => '4.1.14',
    provider => 'puppet_gem',
    require  => Package['gcc-c++'],
  }
  package { 'kubeclient':
    ensure   => 'latest',
    provider => 'puppet_gem',
    require  => Package['gcc-c++'],
  }

}
