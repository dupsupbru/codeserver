# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

#current dir /home/coder
USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

RUN docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

#install c req gdb
RUN sudo apt-get install -y gdb

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
#py version 2021.2.582707922 vsix
RUN code-server --install-extension extensions/ms-python-release.vsix
#Install linter for py
RUN pip3 install pylint

#Extension for c (version 1.5.1)
RUN code-server --install-extension extensions/cpptools-linux.vsix

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
