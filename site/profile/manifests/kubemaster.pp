class profile::kubemaster {
  class { 'kubernetes::master::apiserver':
    allow_privileged         => true,
    service_cluster_ip_range => '10.20.1.0/24',
  }
  class { 'kubernetes::master::scheduler':
    master => 'http://127.0.0.1:8080',
  }
  class { 'etcd':
    ensure                     => 'latest',
    listen_client_urls    => 'http://0.0.0.0:2379',
  }
  etcd_key { '/atomic.io/network/config':
    value => '{ "Network": "172.17.0.0/16" }',
  }
} 
