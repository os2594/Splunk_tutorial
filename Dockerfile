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

# COPY xfce4-screensaver.xml /home/vncuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml

# Ensure the required packages are installed
RUN sudo apt update 
RUN sudo apt install wget -y
RUN sudo apt install tar -y
RUN sudo apt install vim -y

# && apt-get install -y wget tar vim sudo && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch to the /opt directory
WORKDIR /opt

# Splunk installation package's wget link here
RUN sudo wget -O splunk-10.0.1-c486717c322b-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/10.0.1/linux/splunk-10.0.1-c486717c322b-linux-amd64.tgz"
RUN sudo tar -xzvf splunk-10.0.1-c486717c322b-linux-amd64.tgz

# Modify splunk-launch.conf to include optimistic file locking
#RUN sudo echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" >> /opt/splunk/etc/splunk-launch.conf
RUN echo "OPTIMISTIC_ABOUT_FILE_LOCKING = 1" | sudo tee -a /opt/splunk/etc/splunk-launch.conf > /dev/null

# Set permissions for Splunk files and directories
RUN sudo chown -R vncuser:vncuser /opt/splunk

# Expose the default Splunk web and management ports
EXPOSE 8000 8089

# Start Splunk on container startup
#ENTRYPOINT ["/opt/splunk/bin/splunk", "start", "--accept-license", "--answer-yes", "--no-prompt"]


COPY xfce4-screensaver.xml /home/vncuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml


# ----- END CONTROL SETTINGS -----

#----- BEGIN LAB SETUP -----

# Add files for steghide    
#RUN mkdir -p /home/vncuser/Downloads
#RUN sudo chown -R vncuser:vncuser /home/vncuser/Downloads
#-- Commented out the prior two lines - don't believe they're needed. - Test.
ADD Content/disable_thp.txt /home/vncuser/Desktop/

# ----- END LAB SETUP -----

# finally execute the entrypoint/command, this will start vnc services and keep the lab running by backgrounding the listening socket for websockify
CMD ["/bin/zsh", "/home/vncuser/command_watch/start_services.sh"]
