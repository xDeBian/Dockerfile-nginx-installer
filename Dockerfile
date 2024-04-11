# Use Ubuntu as the base image
FROM ubuntu:latest

# Update system and install necessary dependencies
RUN apt-get update \
    && apt-get install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev openssl libssl-dev wget

# Download Nginx source code
RUN wget http://nginx.org/download/nginx-1.24.0.tar.gz \
    && tar -zxvf nginx-1.24.0.tar.gz

# Build and install Nginx
RUN cd nginx-1.24.0 \
    && ./configure \
    && make \
    && make install

# Remove the source code (optional)
# RUN rm -rf nginx-1.24.0

# Create index.html with "DATO DZNELADZE"
RUN echo "DATO DZNELADZE" > /usr/local/nginx/html/index.html

# Modify nginx.conf to include server block for port 8080
RUN sed -i '/http {/a \
    server { \
        listen 8080; \
        server_name localhost; \
        location / { \
            root /usr/local/nginx/html; \
            index index.html; \
        } \
    }' /usr/local/nginx/conf/nginx.conf

# Expose port 8080
EXPOSE 8080

# Set the startup command
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
