#FROM kali-base:latest
FROM matrixregistry.azurecr.io/base_images/kali_base:latest

# The base image is puilled from our container registry, important notes, the base image exposes ports 6080, and 5901, creates the vncuser and installs some base packages

# ---- CONTROL SETTINGS NEEDED -----

#This tells debian that we are not in an interactive TTY and supresses garbage related to that.
ENV DEBIAN_FRONTEND=noninteractive
# Environment variables
ENV SPLUNK_HOME=/opt/splunk
ENV OPTIMISTIC_ABOUT_FILE_LOCKING=1

# Putting this in the parent image will cause a black screen, I tried. Without it the screen will lock after 5 minutes of inactive use, users will be unable to log back in to the machine
RUN mkdir -p /home/vncuser/.config/xfce4/xfconf/xfce-perchannel-xml


# Ensure the required packages are installed
RUN apt-get update && apt-get install -y wget tar vim sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch to the /opt directory
WORKDIR /opt

# Copy the Splunk installation package's wget link here
# Replace '<wget_link>' with the actual wget link from Splunk's website
RUN wget -O splunk.tgz <wget_link> && \
    tar -xzvf splunk.tgz && \
    rm splunk.tgz

# Modify splunk-launch.conf to include optimistic file locking
RUN echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunk/etc/splunk-launch.conf

# Set permissions for Splunk files and directories
RUN chown -R vncuser:vncuser /opt/splunk

# Expose the default Splunk web and management ports
EXPOSE 8000 8089

# Start Splunk on container startup
ENTRYPOINT ["/opt/splunk/bin/splunk", "start", "--accept-license", "--answer-yes", "--no-prompt"]
----

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
