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