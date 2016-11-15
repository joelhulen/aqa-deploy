# aqa-deploy

### Deploy to existing cluster:
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

### Deploy to a new cluster:
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fjoelhulen%2Faqa-deploy%2Fmaster%2Fazuredeploy-with-cluster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


### Steps after deployment:
   
     Once we have cluster deployed and AQA scripts run, we should copy the parquet files to blob storage account used by the cluster under data folder.