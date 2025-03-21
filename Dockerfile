FROM alpine:latest

WORKDIR /app

COPY main.sh /app/

RUN apk update && \
	apk add --no-cache bash mongodb-tools zip gnupg aws-cli

RUN chmod +x /app/main.sh

CMD ["/bin/bash", "/app/main.sh"]
