# aqa-deploy

### Deploy to existing cluster:
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

### Deploy to a new cluster:
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy-with-cluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


### Post-deployment steps to run the benchmark demo:
   
1. Establish a new SSH session to your new cluster.
2. Change directory to /usr/hdp/current/aqa (`cd /usr/hdp/current/aqa`)
3. `source .bash_profile` 
4. `source .bashrc`
5. Run the benchmark demo with `spark-submit demo.py`
