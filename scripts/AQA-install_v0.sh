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
#set -e

# Set the directory path to the release location in S3. $release must be set to what follows
# 's3://aqapop/beta/' in the full directory path (for example 'mvp1.1').
release=mvp1.1 # Change this for each MVP release.

# This is then the location on S3 where the release files are published.
aqa_container=https://aqa.blob.core.windows.net/?sv=2015-04-05&ss=bfqt&srt=sco&sp=rwdlacup&se=2017-11-10T12:30:58Z&st=2016-11-10T04:30:58Z&spr=https&sig=KcXzYyJeY0Q5ri3hTcvN4W%2FKQDnffGdyZxuHxpWRYr0%3D/assets/aqa
aqa_wheel_dir=$aqa_container

# This is the list of wheel filenames. Each filename is composed of a package name and version
# number in wheel_prefixes and the common suffix in wheel_ext.
#declare -a wheel_prefixes=("algebraixlib-1.4b1" "aqashared-0.1.1" "aqaspark-0.1.1" "aqacfs-0.1.1" "aqaopt-0.1.1" "internal-1.1.1" "experimental-1.1.1")
#wheel_ext="-py3-none-any.whl"

# The location for AQA working data.
AQA_ROOT=/mnt/aqa_root
mkdir -p $AQA_ROOT/

 

#import helper module.
#wget -O /tmp/HDInsightUtilities-v01.sh -q https://hdiconfigactions.blob.core.windows.net/linuxconfigactionmodulev01/HDInsightUtilities-v01.sh && source /tmp/HDInsightUtilities-v01.sh && rm -f /tmp/HDInsightUtilities-v01.sh


# --------------------------------------------------------------------------------------------------
echo "*** Setting up the environment for user hadoop (for command line work) ***"

# NOTE: PYSPARK_PYTHON is only needed for EMR < 4.6


