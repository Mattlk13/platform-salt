{%- set mysql_root_password = salt['pillar.get']('mysql:root_pw', 'mysqldefault') -%}
{%- set cmdb_host = salt['pnda.get_hosts_for_role']('oozie_database')[0] -%}
{%- set cm_host = salt['pnda.get_hosts_for_role']('hadoop_manager')[0] -%}
{% set cmdb_user = pillar['hadoop_manager']['cmdb']['user'] %}
{% set cmdb_database = pillar['hadoop_manager']['cmdb']['database'] %}
{% set cmdb_password = pillar['hadoop_manager']['cmdb']['password'] %}

include:
  - java
  - mysql.connector
  - mysql.client

cloudera-manager-install_daemons:
  pkg.installed:
    - name: {{ pillar['cloudera-manager-daemons']['package-name'] }}
    - version: {{ pillar['cloudera-manager-daemons']['version'] }}

cloudera-manager-install_server:
  pkg.installed:
    - name: {{ pillar['cloudera-manager-server']['package-name'] }}
    - version: {{ pillar['cloudera-manager-server']['version'] }}

cloudera-manager-ensure_cloudera_manager_enabled:
  cmd.run:
    - name: /bin/systemctl enable cloudera-scm-server

cloudera-manager-create_ext_db:
  cmd.run:
    - name: /usr/share/cmf/schema/scm_prepare_database.sh mysql -h {{ cmdb_host }} -uroot -p{{ mysql_root_password }} --scm-host {{ cm_host }} {{ cmdb_database }} {{ cmdb_user }} {{ cmdb_password }}
    - onlyif: grep 'com.cloudera.cmf.db.setupType=INIT' /etc/cloudera-scm-server/db.properties

cloudera-manager-ensure_cloudera_manager_started:
  service.running:
    - name: cloudera-scm-server
    - enable: True
    - reload: True
