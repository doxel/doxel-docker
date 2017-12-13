#!/bin/bash
set -e

# mov demo segment images to upload directory
sed -i -r -e 's#/mnt/upload#/home/doxel/doxel-loopback/server/upload_dev#' /home/doxel/doxel-loopback/server/config.json

# set demo segment status to "published"
mongo localhost:27017/doxel_dev --eval 'db.Segment.update({"_id": ObjectId("59a6d02dd36a29013790749f")},{$set: {"status": "published"}});'
sync
