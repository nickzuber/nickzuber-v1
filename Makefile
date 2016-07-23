update:
	make build && make restart
build:
	jekyll build --destination /usr/share/nginx/html
restart:
	nginx -t && service nginx restart
