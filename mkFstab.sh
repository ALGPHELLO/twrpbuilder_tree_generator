#!/bin/bash

cd out
gzip -d recovery.img-ramdisk.gz
cpio -idm < recovery.img-ramdisk
cd ..

copyRight()
{
cat << EOF
#
# Copyright (C) 2018 The TwrpBuilder Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

EOF
}

getMounts()
{
for i in $(cat out/etc/recovery.fstab | grep -w $1 )
do
partition=$(echo $i | grep "/dev")
if [ ! -z "$partition" ]; then
echo $partition >> file
fi
done

if [[ $1 == "/boot" || $1 == "/recovery" ]]
then
echo $1 emmc $(cat file)
fi
if [[ $1 == "/system" || $1 == "/data" || $1 == "/cache" ]]
then
echo $1 ext4 $(cat file)
fi
rm file
}
copyRight >> $codename/recovery.fstab
getMounts /boot >> $codename/recovery.fstab
getMounts /recovery >> $codename/recovery.fstab
getMounts /system >> $codename/recovery.fstab
getMounts /data >> $codename/recovery.fstab
getMounts /cache >> $codename/recovery.fstab

#Clean 
rm -rf recovery.img mounts build.prop out/
