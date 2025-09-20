Splunk tutorial

**At a glance**

-	The forwarder package is installed in an end-machine e.g Linux server. The forwarder (one of the components in splunk architecture) will forward the logs to splunk instance for data parsing and data indexing.
-	A **Universal forwarder** – forwards raw data without prior treatment.
-	The forwarder monitors the logs of your choice and forwards them to the Indexer.
-	**Indexers** all they do is data parsing and data indexing. So indexers will break-down data logs into events and provide all key-value pairs.
-	The user can search for values using queries in the **search head (dashboard)**.
-----

**Splunk components**

- Splunk forwarder
  - What is it? is an agent you deploy on an IT system. It collects logs and sends then to another splunk instance.
  - It has no UI, so it's lightweight and regarded as the best data collection method.
  - It does not require a license.
    
- Splunk indexer
  - What is it? Is a package that transforms data into events (unless data was received pre-processed from a heavy forwarder).
  - Indexers store events in the disk and adds them to an index to enable searchability.
  - The indexer creats the following files:
    - Compressed raw data
    - Indexes pointing to raw data (TSDIX files)
    - Metadata files (host, source and source type)
  - The indexer performs generic event processing on log data
 
- Splunk Search Head
  -  What is it? The search head provides the UI for user to submit searches via SPL
  -  It allows users to search and query Splunk data
  -  Splunk provides a distributed seacrh architecture, which allows you to scale up to handle large data volumes.
   
- Splunk deployment server
  - What is it? A centralized configuration manager
 
- Monitoring Console
  - What is it? Is a toll for viewing detailed topology and performance information for your Splunk Enterprise deployment.
  - You can access the Monitoring console only with admin privileges in the Settings section.

- Splunk Deployer
  - What is it? Is Splunk Enterprise instance that you use to distribute apps and certain other configurations updates to seach head cluster members.

- Splunk Cluster Master
  - Mananges and regulates the functioning of indexers so that replicate external data.
  - If an indexer goes down, the Splunk Cluster Master will make the data available in the other indexers. (ir provides high availability and disaster recovery)
     
    
