user nginx;
worker_processes auto;
worker_rlimit_nofile 1024;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
  accept_mutex on;
  accept_mutex_delay 500ms;
  worker_connections 1024;
}

http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;

  access_log off;
  error_log /var/log/nginx/error.log error;

  sendfile on;
  server_tokens on;

  types_hash_max_size 1024;
  types_hash_bucket_size 512;

  server_names_hash_bucket_size 64;
  server_names_hash_max_size 512;

  keepalive_timeout   65s;
  keepalive_requests  100;
  client_body_timeout 60s;
  send_timeout        60s;
  lingering_timeout   5s;
  tcp_nodelay         on;

  gzip              on;
  gzip_comp_level   1;
  gzip_disable      msie6;
  gzip_min_length   1000;
  gzip_http_version 1.1;
  gzip_proxied      expired no-cache no-store private auth;
  gzip_types        text/plain application/x-javascript text/xml text/css application/xml;
  gzip_vary         off;

  #client_body_temp_path   /var/nginx/client_body_temp;
  client_max_body_size    10m;
  client_body_buffer_size 128k;
  #proxy_temp_path         /var/nginx/proxy_temp;
  proxy_connect_timeout   90s;
  proxy_send_timeout      90s;
  proxy_read_timeout      90s;
  proxy_buffers           32 4k;
  proxy_buffer_size       8k;
  proxy_set_header        Host $host;
  proxy_set_header        X-Real-IP $remote_addr;
  proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header        Proxy "";
  proxy_headers_hash_bucket_size 64;


  include /etc/nginx/conf.d/*.conf;
  #include /etc/nginx/sites-enabled/*;

  server {
    # Redirect any http requests to https
    listen         80;
    server_name    gocd.ballenger.dev;
    return 301     https://gocd.ballenger.dev$request_uri;
  }

  map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
  }

  server {
    listen                    443 ssl;
    server_name               gocd.ballenger.dev;

    ssl_certificate           /etc/ssl/ssl_cert.pem;
    ssl_certificate_key       /etc/ssl/ssl_key.pem;
    ssl_dhparam               /etc/ssl/dhparam.pem;
    ssl_ecdh_curve            secp384r1;
    ssl_session_cache         shared:le_nginx_SSL:1m;
    ssl_session_timeout       5m;
    ssl_session_tickets       off;
    ssl_protocols             TLSv1.1 TLSv1.2;
    ssl_ciphers "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS";
    ssl_prefer_server_ciphers on;


    # Proxy everything over to the GoCD server
    location / {
      proxy_set_header        Host            $host;
      proxy_set_header        X-Real-IP       $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;
      proxy_http_version      1.1;
      proxy_set_header 	      Upgrade $http_upgrade;
      proxy_set_header 	      Connection $connection_upgrade;
      proxy_pass              http://localhost:8153/;
    }
  }
}
