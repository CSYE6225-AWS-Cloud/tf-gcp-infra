#!/bin/bash
sudo echo "server.port=${APPLICATION_PORT}" >> /home/csye6225/webapp/userdata.properties
sudo echo "spring.datasource.url=jdbc:mysql://${IP_ADDRESS}/${DB_NAME}" >> /home/csye6225/webapp/userdata.properties
sudo echo "spring.datasource.username=${USERNAME}" >> /home/csye6225/webapp/userdata.properties
sudo echo "spring.datasource.password=${PASSWORD}" >> /home/csye6225/webapp/userdata.properties
sudo echo "spring.datasource.driverClassName=com.mysql.cj.jdbc.Driver" >> /home/csye6225/webapp/userdata.properties
sudo systemctl daemon-reload
sudo systemctl start webapp.service
sudo systemctl enable webapp.service