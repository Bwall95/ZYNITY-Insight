# Use the official Grafana image
FROM grafana/grafana:latest

# Set environment variables
ENV GF_INSTALL_PLUGINS=marcusolsson-csv-datasource
ENV GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS=marcusolsson-csv-datasource

# Create a directory for the CSV file
RUN mkdir -p /var/lib/grafana/plugins/data

# Copy the example CSV file
COPY example.csv /var/lib/grafana/plugins/data/example.csv

# Expose Grafana's default port
EXPOSE 3050
