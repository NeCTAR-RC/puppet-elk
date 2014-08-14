class elk {

  class { 'elasticsearch': }
  class { 'curator':
    ensure => 'installed',
  }
  class { 'logstash': }
  class { 'apache::http::proxy': }
  class { 'rsyslog::server': }

  curator::job { 'elasticsearch_cleanup':
    delete_older   => 90,
    close_older    => 30,
    optimize_older => 2,
    bloom_older    => 2,
  }

  file { '/etc/rsyslog.d/30-logstash.conf':
    source  => 'puppet:///modules/elk/30-logstash.conf',
    notify  => Service['rsyslog'],
    require => File['/etc/rsyslog.d'],
  }

  apt::pin { 'elasticsearch':
    priority   => 1001,
    originator => 'Elasticsearch',
  }

  logstash::configfile { 'central':
    source => 'puppet:///modules/elk/logstash.conf'
  }

  logstash::patternfile { 'extra_patterns':
    source => 'puppet:///modules/elk/extra_patterns'
  }

  file { '/opt/logstash/vendor/':
    ensure  => directory,
    require => Package['logstash'],
  }

  file { '/opt/logstash/vendor/kibana/app/dashboards':
    ensure => directory,
  }

  file { '/opt/logstash/vendor/kibana/app/dashboards/default.json':
    ensure  => link,
    target  => '/opt/logstash/vendor/kibana/app/dashboards/logstash.json',
    owner   => 'logstash',
    group   => 'logstash',
    require => File['/opt/logstash/vendor/kibana/app/dashboards'],
  }

  file { '/opt/logstash/vendor/kibana/config.js':
    content => template('elk/kibana-config.js.erb'),
  }

  file { '/etc/apache2/conf.d/kibana.conf':
    content => template('elk/apache.conf.erb'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  file { '/usr/local/sbin/reset-elasticsearch.sh':
    content => template('elk/reset-elasticsearch.sh.erb'),
    mode    => '0750',
  }

  nagios::nrpe::service { 'elasticsearch_tcp':
    check_command => '/usr/lib/nagios/plugins/check_http -H localhost -u /_cluster/health -p 9200 -w 2 -c 3 -s green'
  }
}
