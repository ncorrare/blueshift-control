class profile::kubeminion {
  class { 'kubernetes::node::kubelet':
    ensure         => 'latest',
    address        => '0.0.0.0',
    api_servers    => "http://kubemaster.pdx.puppet.vm:8080",
    configure_cbr0 => true,
    register_node  => true,
    pod_cidr       => '10.100.5.0/24',
  }
  include kubernetes::node::kube_proxy
  class { 'flannel':
    etcd_endpoints => "http://kubemaster.pdx.puppet.vm:2379",
    etcd_prefix    => '/coreos.com/network',
  }
}

