FROM library/ubuntu:14.04

# ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
# RUN chmod +x /usr/bin/dumb-init

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y ca-certificates wget apt-transport-https vim nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list && \
    wget -q -O - https://packages.gitlab.com/gpg.key | apt-key add - && \
    apt-get update -y && \
    apt-get install -y gitlab-ci-multi-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    apt-get clean && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install nodejs -y --force-yes

ENV CI_SERVER_URL=https://gitlab.globoi.com/
ENV RUNNER_NAME=gitlab-tsuru-runner-prod
ENV REGISTRATION_TOKEN="DzqVzirCHG2uYnWs9pf8"
ENV REGISTER_NON_INTERACTIVE=true

VOLUME [ "/etc/gitlab-runner", "/home/gitlab-runner" ]
# ENTRYPOINT [ "/usr/bin/dumb-init", "/entrypoint" ]

CMD curl -sv https://gitlab.globoi.com/api/v4/runners gitlab-runner register && gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner

