#!/bin/bash
set -e
mv /home/doxel/doxel-loopback/server/upload_dev/2* /home/doxel/doxel-loopback/server/upload/.

echo 'db.segments.update({"id": "59a6d02dd36a29013790749f"},{$set: {"status": "published"}});' > /tmp/updatedb.js

mongo localhost:27017/doxel /tmp/updatedb.js


