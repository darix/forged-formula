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

{%- if 'forgejo' in pillar and 'config' in pillar.forgejo %}
forgejo_packages:
  pkg.installed:
    - pkgs:
      - forgejo
      {%- if "use_apparmor" in pillar.forgejo and pillar.forgejo.use_apparmor %}
      - forgejo-apparmor
      {%- endif %}
      {%- if "use_selinux" in pillar.forgejo and pillar.forgejo.use_selinux %}
      - forgejo-selinux
      {%- endif %}

forgejo_config:
  file.managed:
    - name: /etc/forgejo/conf/app.ini
    - user: root
    - group: forgejo
    - mode: "0640"
    - template: jinja
    - require:
      - forgejo_packages
    - source: salt://{{ slspath }}/files/etc/forgejo/conf/app.ini.j2

{%- if pillar.forgejo.get("use_apparmor", False) %}
forgejo_load_apparmor:
  cmd.run:
    - name: /sbin/apparmor_parser -r /etc/apparmor.d/forgejo
    - require:
      - forgejo_packages
    - require_in:
      - forgejo_service
{%- endif %}

forgejo_service:
  service.running:
    - name: forgejo.service
    - enable: True
    - watch:
      - forgejo_config
    - require:
      - forgejo_config
{%- endif %}