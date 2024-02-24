#!/bin/sh
sudo echo "server.port=${APPLICATION_PORT}" >> /tmp/userdata.properties
sudo echo "spring.datasource.url=jdbc:mysql://${IP_ADDRESS}/${DB_NAME}" >> /tmp/userdata.properties
sudo echo "spring.datasource.username=${USERNAME}" >> /tmp/userdata.properties
sudo echo "spring.datasource.password=${PASSWORD}" >> /tmp/userdata.properties
sudo echo "spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver" >> /tmp/userdata.properties
sudo systemctl daemon-reload
sudo systemctl start webapp.service
sudo systemctl enable webapp.service