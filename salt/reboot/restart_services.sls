include:
  - reboot.install_restart

restart-start_cloudera_manager:
  cmd.run:
    - name: 'service cloudera-scm-manager start; sleep 60'

restart-start_service:
  cmd.run:
    - name: 'service pnda-restart stop || echo already stopped; service pnda-restart start'
