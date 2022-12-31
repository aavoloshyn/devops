 FROM alpine
 ENV TZ=Europe/Kiev
 RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
     && echo $TZ > /etc/timezone \
     && apk add --no-cache apache2 php php-apache2 \
     && rm -rf /var/www/localhost/htdocs/index.html && mkdir -p /run/apache2
 COPY src/index.php /var/www/localhost/htdocs/ 
 
 EXPOSE 80

 CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
