class profile::guestbook {
  kubernetes_replication_controller { 'redis-master':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'redis', 'role' => 'master', 'tier' => 'backend'},
      'namespace' => 'default',
    },
    spec     => {
      'replicas' => 1,
      'template' => {
        'metadata' => {
          'labels' => {'app' => 'redis', 'role' => 'master', 'tier' => 'backend'},
        },
        'spec' => {
          'containers' => [
            {
              'image' => 'redis',
              'name' => 'master',
              'ports' => [
                {'containerPort' => 6379, 'protocol' => 'TCP'}
              ],
              'resources' => {
                'requests' => {
                  'cpu' => '100m',
                  'memory' => '100Mi',
                }
              }
            }
          ]
        }
      }
    }
  }
  kubernetes_service { 'redis-master':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'redis', 'role' => 'master', 'tier' => 'backend'},
      'namespace' => 'default',
    },
    spec     => {
      'ports' => [
        {'port' => 6379, 'protocol' => 'TCP', 'targetPort' => 6379}
      ],
      'selector' => {
        'app' => 'redis',
        'role' => 'master',
        'tier' => 'backend'
      },
    },
  }
  kubernetes_replication_controller { 'redis-slave':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'redis', 'role' => 'slave', 'tier' => 'backend'},
      'namespace' => 'default',
    },
    spec     => {
      'replicas' => '2',
      'template' => {
        'metadata' => {
          'labels' => {'app' => 'redis', 'role' => 'slave', 'tier' => 'backend'}
        },
        'spec' => {
          'containers' => [
            {
              'env' => [{'name' => 'GET_HOSTS_FROM', 'value' => 'dns'}],
              'image' => 'gcr.io/google_samples/gb-redisslave:v1',
              'name' => 'slave',
              'ports' => [
                {'containerPort' => '6379', 'protocol' => 'TCP'}
              ],
              'resources' => {'requests' => {'cpu' => '100m', 'memory' => '100Mi'}},
            }
          ]
        }
      }
    }
  }
  kubernetes_service { 'redis-slave':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'redis', 'role' => 'slave', 'tier' => 'backend'},
      'namespace' => 'default',
    },
    spec     => {
      'ports' => [
        {'port' => 6379, 'protocol' => 'TCP'}
      ],
      'selector' => {
        'app' => 'redis',
        'role' => 'slave',
        'tier' => 'backend',
      }
    }
  }
  kubernetes_replication_controller { 'frontend':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'guestbook', 'tier' => 'frontend'},
      'namespace' => 'default',
    },
    spec     => {
      'replicas' => '3',
      'template' => {
        'metadata' => {
          'labels' => {'app' => 'guestbook', 'tier' => 'frontend'}
        },
        'spec' => {
          'containers' => [
            {
              'env' => [{'name' => 'GET_HOSTS_FROM', 'value' => 'dns'}],
              'image' => 'gcr.io/google_samples/gb-frontend:v3',
              'name' => 'php-redis',
              'ports' => [
                {'containerPort' => '80', 'protocol' => 'TCP'}
              ],
              'resources' => {'requests' => {'cpu' => '100m', 'memory' => '100Mi'}},
            }
          ]
        }
      }
    }
  }
  kubernetes_service { 'frontend':
    ensure   => 'present',
    metadata => {
      'labels' => {'app' => 'guestbook', 'tier' => 'frontend'},
      'namespace' => 'default',
    },
    spec     => {
      'type' => 'LoadBalancer',
      'ports' => [
        {'port' => 80, 'protocol' => 'TCP'}
      ],
      'selector' => {
        'app' => 'guestbook',
        'tier' => 'frontend'
      },
    },
  }
}

