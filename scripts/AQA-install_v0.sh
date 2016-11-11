#!/bin/bash
# --------------------------------------------------------------------------------------------------
# An executable script for bootstrapping EMR clusters:
#
# - Set up the 'hadoop' user environment for command line work.
# - Install requisites:
#   - Python 3.4.
#   - A development environment (required for installing certain Python packages).
#   - Problem packages that want to be installed separately (numpy, scipy).
# - Install AQA wheels.
# - Copy a standard AQA configuration file.
# 
# This script requires no command line argument.

# --------------------------------------------------------------------------------------------------
# Script configuration:

# Exit immediately if a command exits with a non-zero status.
set -e

# Set the directory path to the release location in S3. $release must be set to what follows
# 's3://aqapop/beta/' in the full directory path (for example 'mvp1.1').
release=mvp1.1 # Change this for each MVP release.


#import helper module.
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh


# This is then the location on S3 where the release files are published.
s3_wheel_dir=https://aqa.blob.core.windows.net/?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-11-10T12:30:58Z&st=2016-11-10T04:30:58Z&spr=https&sig=KcXzYyJeY0Q5ri3hTcvN4W%2FKQDnffGdyZxuHxpWRYr0%3D/assets/aqa

# This is the list of wheel filenames. Each filename is composed of a package name and version
# number in wheel_prefixes and the common suffix in wheel_ext.
declare -a wheel_prefixes=("algebraixlib-1.4b1" "aqashared-0.1.1" "aqaspark-0.1.1" "aqacfs-0.1.1" "aqaopt-0.1.1" "internal-1.1.1" "experimental-1.1.1")
wheel_ext="-py3-none-any.whl"

# The location for AQA working data.
aqa_root=/mnt/aqa_root

# --------------------------------------------------------------------------------------------------
echo "*** Setting up the environment for user hadoop (for command line work) ***"

# NOTE: PYSPARK_PYTHON is only needed for EMR < 4.6
bash_profile=/home/ubuntu/.bash_profile
bashrc=/home/ubuntu/.bashrc
environ="
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=python3
export PYTHONPATH=/usr/lib/spark/python
export PYTHONHASHSEED=0
export ADC_CUSTOMER_RUNNING_ON_EMR_CLUSTER=1
export SPARK_HOME=/usr/lib/spark/
export PATH=$SPARK_HOME/bin:$PATH
"

echo "${environ}" >> ${bash_profile}
echo "${environ}" >> ${bashrc}

# --------------------------------------------------------------------------------------------------
echo "*** Installing Python3.4 and a development environment ***"

seconds=0
sudo apt-get -y update
echo "   ...apt-get update: $seconds elapsed"
#sudo apt -y install python34*
sudo apt-get install python3-setuptools
sudo easy_install3 pip
echo "   ...apt-get python34: $seconds elapsed"
sudo apt-get -y install mlocate
echo "   ...apt-get mlocate: $seconds elapsed"
sudo apt-get -y install dos2unix
echo "   ...apt-get dos2unix: $seconds elapsed"
#sudo apt-get -y install blas-devel
sudo apt-get -y install libblas-dev liblapack-dev
sudo apt-get -y install gfortran

sudo apt-get install python3-setuptools

sudo apt-get -y install python3-dev

echo "   ...apt-get blas-devel: $seconds elapsed"
#sudo apt-get -y install lapack-devel
echo "   ...apt-get lapack-devel: $seconds elapsed"
sudo apt-get -y install openssl
echo "   ...apt-get openssl-devel: $seconds elapsed"
# TODO Maybe install only the necessary subset of Development Tools (to speed up the process).
#sudo apt-get -y groupinstall 'Development Tools'
sudo apt-get install build-essential
echo "   ...apt-get Development Tools: $seconds elapsed"
echo "...TOTAL for apt-get: $seconds elapsed"

# --------------------------------------------------------------------------------------------------
echo "*** Installing problematic Python modules ***"

# numpy and scipy are necessary for scikit-learn and it has trouble installing without them.
# TODO The experimental and internal packages rely on this. This section can be removed when those
# packages are removed assuming there will be no dependencies on numpy and scipy otherwise.
seconds=0
declare -a packages=("numpy" "scipy")
for package in "${packages[@]}"
do
    sudo pip3 install $package
    echo "   ...pip $package: $seconds elapsed"
done
echo "...TOTAL for pip: $seconds elapsed"

# --------------------------------------------------------------------------------------------------
echo "*** Installing AQA wheels ***"

local_wheel_dir=$aqa_root/working/wheels
sudo mkdir -p $local_wheel_dir
sudo chmod 777 -R /mnt/aqa_root
seconds=0
for wheel_prefix in "${wheel_prefixes[@]}"
do
    wheel_filename=$wheel_prefix$wheel_ext
    s3_wheel_filename=$s3_wheel_dir/$wheel_filename
    local_wheel_filename=$local_wheel_dir/$wheel_filename
    if [[ -n "$s3_wheel_filename" ]]; then
        echo "Copying wheel $s3_wheel_filename to $local_wheel_filename"
        sudo wget $s3_wheel_filename -P $local_wheel_filename
        echo "   ...wheel azure cp: $seconds elapsed"
        echo "Installing wheel $local_wheel_filename"
        sudo python3 -m pip install $local_wheel_filename
        echo "   ...wheel install: $seconds elapsed"
    fi
done
echo "...TOTAL for wheel: $seconds elapsed"

# --------------------------------------------------------------------------------------------------
echo "*** Copying configuration file ***"

config_file_src=https://aqa.blob.core.windows.net/?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-11-10T12:30:58Z&st=2016-11-10T04:30:58Z&spr=https&sig=KcXzYyJeY0Q5ri3hTcvN4W%2FKQDnffGdyZxuHxpWRYr0%3D/assets/aqa/aqa_cfg.ini


sudo mkdir -p /mnt/aqa_root/data/
sudo  wget $config_file_src -P /mnt/aqa_root/data/

. /home/ubuntu/.bashrc
. /home/ubuntu/.bash_profile
# --------------------------------------------------------------------------------------------------
echo "*** AQA Bootstrap Complete ***"