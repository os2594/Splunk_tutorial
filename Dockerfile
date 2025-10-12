#FROM kali-base:latest
FROM matrixregistry.azurecr.io/base_images/kali_base:latest

# The base image is puilled from our container registry, important notes, the base image exposes ports 6080, and 5901, creates the vncuser and installs some base packages

# ---- CONTROL SETTINGS NEEDED -----

#This tells debian that we are not in an interactive TTY and supresses garbage related to that.
ENV DEBIAN_FRONTEND=noninteractive
# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV SPLUNK_HOME=/opt/splunk
ENV OPTIMISTIC_ABOUT_FILE_LOCKING=1



# Putting this in the parent image will cause a black screen, I tried. Without it the screen will lock after 5 minutes of inactive use, users will be unable to log back in to the machine
RUN mkdir -p /home/vncuser/.config/xfce4/xfconf/xfce-perchannel-xml
# Create a splunk user
RUN useradd -m -d $SPLUNK_HOME -s /bin/bash $SPLUNK_USER

# Switch to splunk user
USER $SPLUNK_USER
WORKDIR $SPLUNK_HOME

# Download and install Splunk
RUN wget -O splunk.tgz 'wget -O splunkforwarder-10.0.1-c486717c322b-linux-amd64.tgz "https://download.splunk.com/products/universalforwarder/releases/10.0.1/linux/splunkforwarder-10.0.1-c486717c322b-linux-amd64.tgz' && \
    tar -xzf splunk.tgz --strip-components=1 && \
    rm splunk.tgz

# Set permissions
RUN chown -R $SPLUNK_USER:$SPLUNK_USER $SPLUNK_HOME

COPY xfce4-screensaver.xml /home/vncuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml

# ----- END CONTROL SETTINGS -----

#----- BEGIN LAB SETUP -----

# Add files for steghide    
#RUN mkdir -p /home/vncuser/Downloads
#RUN sudo chown -R vncuser:vncuser /home/vncuser/Downloads
#-- Commented out the prior two lines - don't believe they're needed. - Test.


# ----- END LAB SETUP -----

# finally execute the entrypoint/command, this will start vnc services and keep the lab running by backgrounding the listening socket for websockify
CMD ["/bin/zsh", "/home/vncuser/command_watch/start_services.sh"]
