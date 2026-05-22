gitlab_rails['time_zone'] = 'Europe/Paris'

# Reverse Proxy
external_url 'https://gitlab.${DOMAIN_NAME}'
nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['client_max_body_size'] = '2g'
nginx['error_log_level'] = 'error'

gitlab_rails['gitlab_shell_ssh_port'] = 2222

# Auto Migration
praefect['auto_migrate'] = true

# Backup
gitlab_rails['backup_keep_time'] = 604800

gitlab_rails['usage_ping_enabled'] = false


gitlab_rails['initial_root_password'] = '{{ .GITLAB_INITIAL_ROOT_PASSWORD }}'

gitlab_rails['allowed_hosts'] = ['gitlab.${DOMAIN_NAME}', '127.0.0.1', 'localhost']
gitlab_rails['content_security_policy'] = {
    enabled: true,
    report_only: false,
    directives: {
      default_src: "'self'",
      script_src: "'self' 'unsafe-inline' 'unsafe-eval' https://www.recaptcha.net https://apis.google.com",
      frame_ancestors: "'self'",
      frame_src: "'self' https://www.recaptcha.net/ https://content.googleapis.com https://content-compute.googleapis.com https://content-cloudbilling.googleapis.com https://content-cloudresourcemanager.googleapis.com",
      img_src: "* data: blob:",
      style_src: "'self' 'unsafe-inline'"
    }
}


gitlab_rails['lfs_enabled'] = true

# Database
postgresql['enable'] = true
postgresql['shared_buffers'] = "256MB"
postgresql['listen_address'] = '0.0.0.0'
postgresql['port'] = 5432
postgresql['md5_auth_cidr_addresses'] = %w()
postgresql['trust_auth_cidr_addresses'] = %w(127.0.0.1/24)
postgresql['sql_user_password'] = "{{ .GITLAB_SQL_PASSWORD }}"

gitlab_rails['auto_migrate'] = true

# Redis
redis['enable'] = true # false

# SMTP
gitlab_rails['gitlab_email_enabled'] = false
gitlab_rails['smtp_enable'] = false

### Impersonation settings
gitlab_rails['impersonation_enabled'] = true

# Reduce ressource
# https://docs.gitlab.com/omnibus/settings/rpi.html
# https://docs.gitlab.com/omnibus/settings/memory_constrained_envs.html
puma['worker_processes'] = 6
sidekiq['concurrency'] = 20

# Set to false to reduce ressource usage
prometheus_monitoring['enable'] = false



gitlab_exporter['enable'] = false
postgres_exporter['enable'] = false
pgbouncer_exporter['enable'] = false
node_exporter['enable'] = false
redis_exporter['enable'] = false

gitlab_rails['env'] = {
  "GITLAB_LOG_LEVEL" => "WARN",
  'GITLAB_RAILS_RACK_TIMEOUT' => 6000
}


### GitLab user privileges
# gitlab_rails['gitlab_default_can_create_group'] = true
gitlab_rails['gitlab_username_changing_enabled'] = false
### Default project feature settings
gitlab_rails['gitlab_default_projects_features_issues'] = true
gitlab_rails['gitlab_default_projects_features_merge_requests'] = true
gitlab_rails['gitlab_default_projects_features_wiki'] = true
gitlab_rails['gitlab_default_projects_features_snippets'] = true
gitlab_rails['gitlab_default_projects_features_builds'] = true
gitlab_rails['gitlab_default_projects_features_container_registry'] = true
gitlab_rails['gitlab_issue_closing_pattern'] = "\b((?:[Cc]los(?:e[sd]?|ing)|\b[Ff]ix(?:e[sd]|ing)?|\b[Rr]esolv(?:e[sd]?|ing)|\b[Ii]mplement(?:s|ed|ing)?)(:?) +(?:(?:issues? +)?%{issue_ref}(?:(?:, *| +and +)?)|([A-Z][A-Z0-9_]+-\d+))+)"
gitlab_rails['gitlab_repository_downloads_path'] = '/gitlab-tmp'
### Reply by email
gitlab_rails['incoming_email_enabled'] = false


### Consolidated (simplified) object storage configuration
gitlab_rails['object_store']['enabled'] = true
gitlab_rails['object_store']['proxy_download'] = false
gitlab_rails['object_store']['connection'] = {
  'provider' => 'AWS',
  'host' => 's3.${DOMAIN_NAME}',
  'endpoint' => 'https://s3.${DOMAIN_NAME}',
  'path_style' => true,
  'region' => 'us-east-1',
  'aws_access_key_id' => '{{ .GITLAB_S3_ID }}',
  'aws_secret_access_key' => '{{ .GITLAB_S3_SECRET }}',
  'enable_signature_v4_streaming' => true,
  'aws_signature_version' => 4,
}
gitlab_rails['object_store']['storage_options'] = {}


gitlab_rails['object_store']['objects']['artifacts']['bucket'] = 'gitlab-artifacts-storage'
gitlab_rails['object_store']['objects']['external_diffs']['bucket'] = 'gitlab-external-diffs-storage'
gitlab_rails['object_store']['objects']['lfs']['bucket'] = 'gitlab-lfs-storage'
gitlab_rails['object_store']['objects']['uploads']['bucket'] = 'gitlab-uploads-storage'
gitlab_rails['object_store']['objects']['packages']['bucket'] = 'gitlab-packages-storage'
gitlab_rails['object_store']['objects']['dependency_proxy']['bucket'] = 'gitlab-dependency-proxy-storage'
gitlab_rails['object_store']['objects']['terraform_state']['bucket'] = 'gitlab-terraform-state-storage'
gitlab_rails['object_store']['objects']['pages']['bucket'] = 'gitlab-pages-storage'
gitlab_rails['object_store']['objects']['ci_secure_files']['bucket'] = 'gitlab-ci-secure-files'

gitlab_rails['object_store']['objects']['artifacts']['enabled'] = true
gitlab_rails['object_store']['objects']['external_diffs']['enabled'] = true
gitlab_rails['object_store']['objects']['lfs']['enabled'] = true
gitlab_rails['object_store']['objects']['uploads']['enabled'] = true
gitlab_rails['object_store']['objects']['packages']['enabled'] = true
gitlab_rails['object_store']['objects']['dependency_proxy']['enabled'] = true
gitlab_rails['object_store']['objects']['terraform_state']['enabled'] = true
gitlab_rails['object_store']['objects']['pages']['enabled'] = true
gitlab_rails['object_store']['objects']['ci_secure_files']['enabled'] = true


# Container Registry settings
gitlab_rails['registry_enabled'] = true
registry_nginx['enable'] = true

registry_external_url 'https://registry.${DOMAIN_NAME}'

registry_nginx['listen_port'] = 5050
registry_nginx['listen_https'] = false

registry['env'] = {
  "REGISTRY_HTTP_RELATIVEURLS" => true
}

registry_nginx['proxy_set_headers'] = {
  "Host" => "$http_host",
  "X-Real-IP" => "$remote_addr",
  "X-Forwarded-For" => "$proxy_add_x_forwarded_for",
  "X-Forwarded-Proto" => "https",
  "X-Forwarded-Ssl" => "on"
}

### Registry backend storage
###! Docs: https://docs.gitlab.com/ee/administration/packages/container_registry.html#configure-storage-for-the-container-registry
registry['storage'] = {
  's3' => {
    'v4auth' => true,
    'regionendpoint'  => 'https://s3.${DOMAIN_NAME}',
    'path_style' => true,
    'region' => 'us-east-1',
    'bucket' => 'gitlab-registry',
    'accesskey' => '{{ .GITLAB_S3_ID }}',
    'secretkey' => '{{ .GITLAB_S3_SECRET }}',
  },
  'redirect' => {
    'disable' => false
  }
}
registry['health_storagedriver_enabled'] = false



# GitLab Pages
gitlab_pages['enable'] = true
gitlab_pages['external_http'] = ['0.0.0.0:7070']
pages_nginx['enable'] = true

pages_external_url "https://gitlab-pages.${DOMAIN_NAME}"
gitlab_pages['redirect_http'] = false
gitlab_pages['inplace_chroot'] = true
pages_nginx['listen_port'] = 8091
pages_nginx['listen_https'] = false

gitlab_rails['pages_local_store_enabled'] = false

##! Configure to enable health check endpoint on GitLab Pages
gitlab_pages['status_uri'] = "/@status"
gitlab_pages['max_connections'] = 10

gitlab_pages['access_control'] = true

gitlab_pages['log_format'] = "json"
gitlab_pages['log_verbose'] = false
gitlab_pages['enable_disk'] = false


################################################################################
## GitLab CI
##! Docs: https://docs.gitlab.com/ee/ci/quick_start/README.html
################################################################################

# gitlab_ci['gitlab_ci_all_broken_builds'] = true
# gitlab_ci['gitlab_ci_add_pusher'] = true
# gitlab_ci['builds_directory'] = '/var/opt/gitlab/gitlab-ci/builds'


## GitLab Logging
logging['svlogd_size'] = 2 * 1024 * 1024 # rotate after 2 MB of log data
logging['svlogd_num'] = 5 # keep 30 rotated log files
logging['svlogd_timeout'] = 1 * 60 * 60 # rotate after 1 hours
logging['svlogd_filter'] = "gzip" # compress logs with gzip

logging['logrotate_frequency'] = "daily" # rotate logs daily
logging['logrotate_maxsize'] = 2 * 1024 * 1024 # rotate logs when they grow bigger than size bytes even before the specified time interval (daily, weekly, monthly, or yearly)
logging['logrotate_rotate'] = 5 # keep 30 rotated logs
logging['logrotate_compress'] = "compress" # see 'man logrotate'
logging['logrotate_method'] = "copytruncate" # see 'man logrotate'
logrotate['enable'] = true
logrotate['log_directory'] = "/var/log/gitlab/logrotate"

registry['log_level'] = 'error'
gitlab_shell['log_level'] = 'ERROR'

### Gravatar Settings
# gitlab_rails['gravatar_plain_url'] = 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'
# gitlab_rails['gravatar_ssl_url'] = 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'

### Auxiliary jobs
###! Periodically executed jobs, to self-heal Gitlab, do external
###! synchronizations, etc.
###! Docs: https://github.com/ondrejbartas/sidekiq-cron#adding-cron-job
###!       https://docs.gitlab.com/ee/ci/yaml/README.html#artifactsexpire_in
# gitlab_rails['stuck_ci_jobs_worker_cron'] = "0 0 * * *"
# gitlab_rails['expire_build_artifacts_worker_cron'] = "*/7 * * * *"
# gitlab_rails['environments_auto_stop_cron_worker_cron'] = "24 * * * *"
# gitlab_rails['pipeline_schedule_worker_cron'] = "19 * * * *"
# gitlab_rails['ci_archive_traces_cron_worker_cron'] = "17 * * * *"
# gitlab_rails['repository_check_worker_cron'] = "20 * * * *"
# gitlab_rails['admin_email_worker_cron'] = "0 0 * * 0"
# gitlab_rails['personal_access_tokens_expiring_worker_cron'] = "0 1 * * *"
# gitlab_rails['personal_access_tokens_expired_notification_worker_cron'] = "0 2 * * *"
# gitlab_rails['repository_archive_cache_worker_cron'] = "0 * * * *"
# gitlab_rails['pages_domain_verification_cron_worker'] = "*/15 * * * *"
# gitlab_rails['pages_domain_ssl_renewal_cron_worker'] = "*/10 * * * *"
# gitlab_rails['pages_domain_removal_cron_worker'] = "47 0 * * *"
# gitlab_rails['remove_unaccepted_member_invites_cron_worker'] = "10 15 * * *"
# gitlab_rails['schedule_migrate_external_diffs_worker_cron'] = "15 * * * *"
# gitlab_rails['ci_platform_metrics_update_cron_worker'] = '47 9 * * *'
# gitlab_rails['analytics_usage_trends_count_job_trigger_worker_cron'] = "50 23 */1 * *"
# gitlab_rails['member_invitation_reminder_emails_worker_cron'] = "0 0 * * *"
# gitlab_rails['user_status_cleanup_batch_worker_cron'] = "* * * * *"
# gitlab_rails['namespaces_in_product_marketing_emails_worker_cron'] = "0 9 * * *"
# gitlab_rails['ssh_keys_expired_notification_worker_cron'] = "0 2 * * *"
# gitlab_rails['ssh_keys_expiring_soon_notification_worker_cron'] = "0 1 * * *"


gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['openid_connect']
gitlab_rails['omniauth_sync_profile_from_provider'] = ['openid_connect']
gitlab_rails['omniauth_sync_profile_attributes'] = ['name', 'email']
# gitlab_rails['omniauth_auto_sign_in_with_provider'] = 'openid_connect'
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_auto_link_ldap_user'] = true


gitlab_rails['omniauth_providers'] = [
  {
    name: "openid_connect", # do not change this parameter
    label: "Authelia", # optional label for login button, defaults to "Openid Connect"
    icon: "https://www.authelia.com/images/branding/logo-cropped.png",
    args: {
      name: "openid_connect",
      strategy_class: "OmniAuth::Strategies::OpenIDConnect",
      scope: ["openid","profile","email","groups"],
      issuer: "https://auth.${DOMAIN_NAME}",
      discovery: true,
      client_auth_method: "basic",
      response_type: "code",
      response_mode: "query",
      uid_field: "preferred_username",
      send_scope_to_token_endpoint: "false",
      pkce: true,
      client_options: {
        identifier: "{{ .GITLAB_OAUTH_ID }}",
        secret: "{{ .GITLAB_OAUTH_SECRET }}",
        redirect_uri: "https://gitlab.${DOMAIN_NAME}/users/auth/openid_connect/callback",
      }
    }
  }
]

{{ .GITLAB_EMBED}}
