## Azure DevOps Agent in Docker Container

Build image and tag it

```bash
docker build . -t devops-agent:v1
```

Create another tag for the Azure CR (Container Registry) if needed

```bash
docker tag dsaas-agent:3.7 yourregistry.azurecr.io/devops-agents/devops-agent:v1
```

### Optionally push to Container Registry
 
Log in to the registry via the Azure CLI or using Docker directly

```bash
az acr login --name yourregistry # Dev container registry
```
*Or using Docker. You'll need the username and password which can be found in Keys sections of the CR Service in the Azure Portal*
```bash
docker login yourregistry.azurecr.io
```

```bash
docker push crwedsaasopsdev01.azurecr.io/agents/dsaas-agent:3.7
```
