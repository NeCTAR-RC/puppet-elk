==============================================
Puppet ELK - elasticsearch + logstash + kibana
==============================================

http://www.elasticsearch.org/webinars/elk-stack-devops-environment/

class elk
-------------------
Sets up elasticsearch + logstash + kibana web interface to view logs

Depends on the following modules and classes
 * elasticsearch-elasticsearch v0.3.1
 * elasticsearch-logstash >= 0.5.0
 * puppetlabs-apt >= 1.4.2
 * puppetlabs-stdlib >= 4.1.0
 * NeCTAR-RC/puppet-rsyslog
