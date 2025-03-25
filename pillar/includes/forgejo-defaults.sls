forgejo:
  config:
    server:
      STATIC_ROOT_PATH: "/usr/share/forgejo"
      PPROF_DATA_PATH: "/var/lib/forgejo/data/tmp/pprof"
      APP_DATA_PATH: "/var/lib/forgejo/data"
      OFFLINE_MODE: true
      SSH_PORT: 22
    log:
      ROOT_PATH: "/var/log/forgejo"
      MODE: console, file
      LEVEL: Info
    service:
      ROOT: "/var/lib/forgejo/repositories"
      TEMP_PATH: "/var/lib/forgejo/data/tmp/uploads"
      ISSUE_INDEXER_PATH: "/var/lib/forgejo/indexers/issues.bleve"
      REPO_INDEXER_PATH: "/var/lib/forgejo/indexers.bleve"
      DATADIR: "/var/lib/forgejo/queues"
      PROVIDER_CONFIG: "/var/lib/forgejo/data/sessions"
      PATH: "/var/lib/forgejo/data/attachments"
    lfs:
      PATH: "/var/lib/forgejo/data/lfs"
    repository:
      ROOT: "/var/lib/forgejo/data/forgejo-repositories"
    cron.update_checker:
      ENABLED: false