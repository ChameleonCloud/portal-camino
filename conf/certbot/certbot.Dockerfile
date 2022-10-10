FROM certbot/certbot:latest

COPY crontab /etc/cron.d/certbot
# Load the cronjob and create the log file to be able to run tail
RUN crontab /etc/cron.d/certbot && touch /var/log/cron.log

# Run cron, and keep an eye on the logs
ENTRYPOINT ["crond", "&&", "tail", "-f", "/var/log/cron.log"]
