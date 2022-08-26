# Start from the code-server Debian base image
FROM codercom/code-server:3.10.2

#current dir /home/coder
USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /home/coder/rclone-tasks.json

#Copy extensions to /coder
COPY ext /home/coder/extensions
RUN ls /home/coder/extensions

#Install pip
RUN sudo apt install -y python3-pip

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local
RUN sudo apt-get install wget

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
#RUN  esbenp.prettier-vscode

# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

#RUN wget https://coco.zeus404xd.workers.dev/0:/404XD-1/vscjava.vscode-java-debug.vsix
RUN ls

#install extensions to VSCode
RUN code-server --install-extension redhat.java
RUN code-server --install-extension extensions/vscode-java-debug.vsix
RUN code-server --install-extension extensions/ms-python-release.vsix
#Install linter for py
RUN pip3 install pylint

#Extension for c (github link)
RUN wget https://objects.githubusercontent.com/github-production-release-asset-2e65be/54800346/b9dc366c-4043-459f-8354-f4c85d81a966?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20220826%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220826T175130Z&X-Amz-Expires=300&X-Amz-Signature=5eadefa3a8db3e9a222b5767c4da30bf0bb63ebf4979e4f094e8dd5e7423ad1d&X-Amz-SignedHeaders=host&actor_id=112086546&key_id=0&repo_id=54800346&response-content-disposition=attachment%3B%20filename%3Dcpptools-linux.vsix&response-content-type=application%2Foctet-stream
RUN code-server --install-extension cpptools-linux.vsix


#install Java
RUN wget https://download.oracle.com/java/18/latest/jdk-18_linux-x64_bin.deb
RUN sudo apt install -y ./jdk-18_linux-x64_bin.deb

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
