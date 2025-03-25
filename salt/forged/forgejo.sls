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