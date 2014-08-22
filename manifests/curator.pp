class elk::curator {

  $curator_pkgs = ['python-elasticsearch-curator', 'python-elasticsearch-1.0']

  package { $curator_pkgs:
    ensure => installed,
  }

  cron { "curator":
    command => "/usr/bin/curator -l /var/log/curator.log -d 90 -c 30 -b 2",
    hour    => 22,
    minute  => 10,
  }
}
