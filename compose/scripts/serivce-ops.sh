sudo cp systemd/gneiss.service /etc/systemd/system/ && \
sudo systemctl daemon-reload && \
sudo systemctl restart gneiss.service


sudo systemctl stop gneiss.service
sudo systemctl start gneiss.service