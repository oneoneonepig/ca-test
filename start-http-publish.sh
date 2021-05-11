#!/bin/bash

docker run --name nginx -v $(pwd)/publish:/usr/share/nginx/html:ro -p 80:80 -d nginx
