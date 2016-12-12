## Install Jupyter Spark extension ##
# lxml improves perforance on server side communication to Spark
jupyter-extension_install_jupyter_spark:
  pip.installed:
    - pkgs:
      - https://github.com/mozilla/jupyter-spark/archive/0.3.0.tar.gz
      - lxml
    - bin_env: /usr/local/bin/pip3
    - upgrade: True
    - reload_modules: True

jupyter-extension_jupyter_spark:
  cmd.run:
    - name: |
        jupyter serverextension enable --py jupyter_spark --system &&
        jupyter nbextension install --py jupyter_spark --system &&
        jupyter nbextension enable --py jupyter_spark --system
    - unless: |
        jupyter serverextension list --system|grep 'jupyter_spark.*enabled' &&
        jupyter nbextension list --system|grep 'jupyter-spark/extension.*enabled'
    - require:
      - pip: jupyter-extension_install_jupyter_spark
