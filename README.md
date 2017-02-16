# Autoscaling
## Container as a Service using Azure VM Scale Sets and Docker Swarm (mode)
* Realized using Azure [VM Scale Sets](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview)
* [Linux Diagnostics extension](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-classic-diagnostic-extension) used for getting the guest VM metrics used for triggering scaling in/out
* CPU bound tested with stress tool encapsulated as a docker [image](https://hub.docker.com/r/petarmaric/docker.cpu-stress-test/)
* Azure deployment jsons created with [acs-engine](https://github.com/Azure/acs-engine) chosing DockerCE (Swarm Mode) orchestrator. 
* The scripts dir contains utility scripts to set up the monitoring stack consisting of:
  * [cAdvisor](https://github.com/google/cadvisor) for container metrics, 
  * [node-exporter](https://github.com/prometheus/node_exporter) voor VM metrics, 
  * [Prometheus](https://prometheus.io) for making the time series data stream,
  * [Grafana](http://grafana.org/) dashboard for displaying the metrics.

Sample dashboard looks like following when cputest is running, demonstrating scaling out of the smarm mode cluster automatically and scaling in when cputest is stopped:

<img width="880" src="https://github.com/kbhattmsft/autoscaling/raw/master/images/autoscale_CPU.PNG">  

cputest is iteslf deployed as a swarm mode service in the global mode.

#### Deploy and Visualize
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkbhattmsft%2Fautoscaling%2Fmaster%2Fazuredeploy.json" target="_blank"><img alt="Deploy to Azure" src="http://azuredeploy.net/deploybutton.png" /></a>

<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fkbhattmsft%2Fautoscaling%2Fmaster%2Fazuredeploy.json" target="_blank">  <img src="http://armviz.io/visualizebutton.png" /> </a> 

#### MSFT OSCC
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
