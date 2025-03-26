#
# forged-formula
#
# Copyright (C) 2025   darix
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

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