FROM debian:bullseye-slim

ENV HOME=/home/node
ENV PLAYBOOK_DIR=/dso
ENV CLONE_DIR=/dso
WORKDIR /dso
RUN apt-get update -y && \
	apt-get install python3 python3-pip libsasl2-dev python-dev libldap2-dev libssl-dev git vim nano wget curl host iputils-ping -y && \
	apt clean && \
	ln -s /usr/bin/python3 /bin/python3
RUN python3 -m pip install ansible-core==2.13.3 python-ldap python-gitlab requests hvac kubernetes jmespath
RUN ansible-galaxy collection install kubernetes.core community.hashi\_vault community.general

COPY clone.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
RUN mkdir -p /home/node/.ansible/tmp/ && \
   chmod 777 /home/node/.ansible/tmp/

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash"]