
# update:
# 	make build && make restart
# build:
# 	jekyll build --destination /usr/share/nginx/html
# restart:
# 	nginx -t && service nginx restart

npm:
	@echo "*** This script is to be broken -- it doesn't correctly count the downloads. ***"
	exit 1
	sh ./rehydrate_npm_stats.sh

