FROM nginx:1.13

COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

