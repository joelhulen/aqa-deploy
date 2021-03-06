# aqa-deploy

### Deploy to existing cluster:
Use this option if you already have an HDInsight Spark cluster provisioned<br />
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

### Deploy to a new cluster:
Use this option to provision a new HDInsight Spark cluster, and deploy the AQA app to it<br />
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy-with-cluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


### Post-deployment steps to run the benchmark demo:
   
1. Establish a new SSH session to your new cluster.
2. Change directory to /usr/hdp/current/aqa (`cd /usr/hdp/current/aqa`)
3. Run the benchmark demo script (./run_demo.sh)
