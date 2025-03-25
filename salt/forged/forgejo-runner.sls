{%- if "forgejo_runner" in pillar and "config" in pillar.forgejo_runner %}

forgejo_runner_packages:
  pkg.installed:
    - pkgs:
      - forgejo-runner


forgejo_runner_config:
  file.managed:
    - name: /etc/forgejo-runner/config.yaml
    - user: root
    - group: root
    - mode: "0640"
    - template: jinja
    - require:
      - forgejo_runner_packages
    - source: salt://{{ slspath }}/files/etc/forgejo-runner/config.yaml.j2

forgejo_runner_service:
    service.running:
    - name: forgejo-runner.service
    - enable: True
    - require:
       - forgejo_runner_config
{%- for require in pillar.forgejo_runner.get("require", []) %}
       - {{ require }}
{%- endfor %}
    - watch:
       - forgejo_runner_config


{%- if "external_server" in pillar.forgejo_runner and "runner_token" in pillar.forgejo_runner %}
{%- set registration_name = pillar.forgejo_runner.get("registration_name", grains.fqdn) %}
forgejo_runner_register:
  cmd.run:
    - name: /usr/bin/forgejo-runner --config /etc/forgejo-runner/config.yaml register --no-interactive --name '{{ registration_name }}' --instance {{ pillar.forgejo_runner.external_server }} --token {{ pillar.forgejo_runner.runner_token }} {%- if "labels" in pillar.forgejo_runner %} --labels='{{ pillar.forgejo_runner.labels | join(",") }}'{%- endif %}
    - unless: grep -q "{{ registration_name }}" "/etc/forgejo-runner/runners"
    - watch_in:
      - forgejo_runner_service
    - onchanges_in:
      - forgejo_runner_service
{%- endif %}
{%- endif %}