curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.3-linux-x86_64.tar.gz
tar xzvf filebeat-8.2.3-linux-x86_64.tar.gz

sed -i "s/[\"localhost:9200\"]/[\"http:\/\/10.0.69.142:9200\"]/g" /home/ubuntu/filebeat-8.2.3-linux-x86_64/filebeat.yml
chown root /home/ubuntu/filebeat-8.2.3-linux-x86_64/filebeat.yml

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.2.3-linux-x86_64.tar.gz
tar xzvf metricbeat-8.2.3-linux-x86_64.tar.gz

sed -i "s/[\"localhost:9200\"]/[\"http:\/\/10.0.69.142:9200\"]/g" /home/ubuntu/metricbeat-8.2.3-linux-x86_64/metricbeat.yml
chown root /home/ubuntu/metricbeat-8.2.3-linux-x86_64/metricbeat.yml
