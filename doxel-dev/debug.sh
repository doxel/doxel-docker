#!/bin/bash
service mongodb start
su - doxel /bin/bash -l -c "cd doxel-loopback ; PORT=3001 node --inspect -i -e \"require('./server/server.js'); loopback=require('loopback'); app=loopback.getModel('user').app; app.start(app.get('enableSSL'));\""
