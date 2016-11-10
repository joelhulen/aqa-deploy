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

# This is then the location on S3 where the release files are published.
aqa_container=https://aqa.blob.core.windows.net/?sv=2015-04-05&ss=b&srt=co&sp=rwdlac&se=2017-11-05T23:37:15Z&st=2016-11-05T15:37:15Z&spr=https&sig=MBUdJ1va7Vl736jikaQhHFtHP47Yy292MEgtZplCbPo%3D/assets/aqa
aqa_wheel_dir=$aqa_container

# This is the list of wheel filenames. Each filename is composed of a package name and version
# number in wheel_prefixes and the common suffix in wheel_ext.
declare -a wheel_prefixes=("algebraixlib-1.4b1" "aqashared-0.1.1" "aqaspark-0.1.1" "aqacfs-0.1.1" "aqaopt-0.1.1" "internal-1.1.1" "experimental-1.1.1")
wheel_ext="-py3-none-any.whl"

# The location for AQA working data.
aqa_root=/mnt/aqa_root
sudo mkdir -p $aqa_root


#import helper module.
wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh


# --------------------------------------------------------------------------------------------------
echo "*** Setting up the environment for user hadoop (for command line work) ***"

# NOTE: PYSPARK_PYTHON is only needed for EMR < 4.6

sudo mkdir -p /home/hadoop

bash_profile=/home/hadoop/.bash_profile
bashrc=/home/hadoop/.bashrc
environ="
export PYSPARK_PYTHON=/usr/bin/python3.4
export PYTHONPATH=/usr/lib/spark/python
export PYTHONHASHSEED=0
export ADC_CUSTOMER_RUNNING_ON_EMR_CLUSTER=1
"
echo "${environ}" >> ${bash_profile}
echo "${environ}" >> ${bashrc}

# --------------------------------------------------------------------------------------------------
echo "*** Installing Python3.4 and a development environment ***"

seconds=0

sudo apt-get -y update
echo "   ...apt-get update: $seconds elapsed"
#python3 is already installed on ubuntu

#sudo apt-get -y install python34*
#echo "   ...apt-get python34: $seconds elapsed"
sudo apt-get -y install mlocate
echo "   ...apt-get mlocate: $seconds elapsed"
sudo apt-get -y install dos2unix
echo "   ...apt-get dos2unix: $seconds elapsed"
sudo apt-get -y install libblas-dev liblapack-dev
echo "   ...apt-get libblas-dev,liblapack-dev : $seconds elapsed"
sudo apt-get -y install libssl-dev
echo "   ...apt-get openssl-devel: $seconds elapsed"
# TODO Maybe install only the necessary subset of Development Tools (to speed up the process).
sudo apt-get -y install build-essential
echo "   ...apt-get Development Tools: $seconds elapsed"

sudo apt-get -y install python3-pip
echo "   ...apt-get python3-pip: $seconds elapsed"

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

sudo mkdir -p $aqa_root/working/wheels


local_wheel_dir=$aqa_root/working/wheels
sudo mkdir -p $local_wheel_dir
seconds=0
for wheel_prefix in "${wheel_prefixes[@]}"
do
    wheel_filename=$wheel_prefix$wheel_ext
    aqa_wheel_filename=$aqa_wheel_dir/$wheel_filename
    local_wheel_filename=$local_wheel_dir/$wheel_filename
    if [[ -n "$aqa_wheel_filename" ]]; then
        echo "Copying wheel $aqa_wheel_filename to $local_wheel_filename"
        wget $aqa_wheel_filename -P $local_wheel_filename
        echo "   ...wheel aws cp: $seconds elapsed"
        echo "Installing wheel $local_wheel_filename"
        sudo python3 -m pip3 install $local_wheel_filename
        echo "   ...wheel install: $seconds elapsed"
    fi
done
echo "...TOTAL for wheel: $seconds elapsed"

# --------------------------------------------------------------------------------------------------
echo "*** Copying configuration file ***"

config_file_src=https://aqa.blob.core.windows.net/?sv=2015-04-05&ss=b&srt=co&sp=rwdlac&se=2017-11-05T23:37:15Z&st=2016-11-05T15:37:15Z&spr=https&sig=MBUdJ1va7Vl736jikaQhHFtHP47Yy292MEgtZplCbPo%3D/assets/aqa/aqa_cfg.ini
config_file_dst=$aqa_root/data/aqa_cfg.ini

sudo mkdir -p $config_file_dst

wget $config_file_src $config_file_dst


# --------------------------------------------------------------------------------------------------
echo "*** AQA Bootstrap Complete ***"
