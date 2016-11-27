 #!/bin/bash

. .bashrc
. .bash_profile

source .bash_profile 
source .bashrc

$SPARK_HOME/bin/spark-submit demo.py 