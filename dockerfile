# Use the official Grafana image
FROM grafana/grafana:latest

# Set environment variables
ENV GF_INSTALL_PLUGINS=marcusolsson-csv-datasource
ENV GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS=marcusolsson-csv-datasource
ENV GF_LOG_MODE=console

# Create directories for data and logs
RUN mkdir -p /var/lib/grafana/plugins/data
RUN mkdir -p /var/log/powershell-logs

# Copy the example CSV file
COPY example.csv /var/lib/grafana/plugins/data/example.csv

# Copy an example log file
COPY example.log /var/log/powershell-logs/example.log

# Expose Grafana's port (default is 3000, customize as needed)
EXPOSE 3000

# Install Promtail for log shipping to Loki
RUN apt-get update && \
    apt-get install -y wget && \
    wget -qO /usr/local/bin/promtail https://github.com/grafana/loki/releases/download/v2.8.0/promtail-linux-amd64 && \
    chmod +x /usr/local/bin/promtail

# Add a Promtail configuration file for log ingestion
COPY promtail-config.yaml /etc/promtail/promtail-config.yaml

# Start Promtail alongside Grafana
CMD ["/bin/bash", "-c", "/usr/local/bin/promtail --config.file=/etc/promtail/promtail-config.yaml & /run.sh"]
