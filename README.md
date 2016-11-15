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
   
     Once the cluster has deployed and AQA scripts run, you should copy the parquet files to the blob storage account used by the cluster, under the data folder.
     
     The files can be downloaded from here:
     
     https://aqa.blob.core.windows.net/assets/aqa/data/customer.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
     https://aqa.blob.core.windows.net/assets/aqa/data/orders.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
     https://aqa.blob.core.windows.net/assets/aqa/data/lineitem.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
     https://aqa.blob.core.windows.net/assets/aqa/data/supplier.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
     https://aqa.blob.core.windows.net/assets/aqa/data/nation.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
     https://aqa.blob.core.windows.net/assets/aqa/data/region.parquet?sv=2015-04-05&ss=bf&srt=sco&sp=rwdlac&se=2017-11-12T04:21:09Z&st=2016-11-11T20:21:09Z&spr=https&sig=ydRyrnt9DDc9XaRpF2J8Bv%2BO3rCqpZsWLjZxdBSlqrE%3D
