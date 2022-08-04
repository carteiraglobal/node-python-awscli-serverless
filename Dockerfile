FROM node:lts-alpine

RUN apk add --no-cache bash git openssh curl gcompat

# Install python/pip
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

# Install AWS CLI v2.1.39
ENV AWS_CLI_VERSION=2.1.39
RUN curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip -o awscliv2.zip
RUN apk add unzip
RUN unzip awscliv2.zip
RUN rm awscliv2.zip
RUN ./aws/install -b /usr/bin

ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_DEFAULT_OUTPUT=json

RUN aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
RUN aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
RUN aws configure set default.region $AWS_DEFAULT_REGION
RUN aws configure set default.output json

RUN npm install --location=global serverless