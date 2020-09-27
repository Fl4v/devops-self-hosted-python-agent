## Azure DevOps Agent in Docker Container

Before you proceed, I recommend reading Azure's Documentation on running a [self-hosted agent in Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).

This repo is similar to Azure's Documentation with the exception that Python 3.7.9 & 3.8.5 binaries are installed on the agent so that the following task can be used within your pipeline:

```yaml
- task: UsePythonVersion@0
  inputs:
    #versionSpec: '3.x' 
    #addToPath: true 
    #architecture: 'x64' # Options: x86, x64 (this argument applies only on Windows agents)
```

The use of a self-hosted agent is especially useful when your resources sit behing a private Virtual Netwrok.

More on this task [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/tool/use-python-version?view=azure-devops).

Many thanks to [@rohancragg](https://github.com/rohancragg)'s blog post on how to install Python's capabilities on the agent. The original post can be found [here](https://rohancragg.co.uk/devops/azdo-self-hosted-build-agents/).

Build image and tag it

```bash
docker build . -t devops-agent:v1
```

*Create another tag for the Azure CR (Container Registry) if needed*

```bash
docker tag devops-agent:v1 yourregistry.azurecr.io/devops-agents/devops-agent:v1
```

### Optionally push to Container Registry
 
Log in to the registry via the Azure CLI or using Docker directly

```bash
az acr login --name yourregistry
```
*Or using Docker. You'll need the username and password which can be found in Keys sections of the CR Service in the Azure Portal*
```bash
docker login yourregistry.azurecr.io
```

```bash
docker push yourregistry.azurecr.io/agents/devops-agent:v1
```

### PAT Token

Before you can proceed with the registation of your agent, you'll need a one time Personal Access Token - PAT Token that will be used by the agent upon first setup. More info [here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops) and [here](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page). Head over to DevOps and create one as you'll need it for the next step.

### Run Container

```bash
docker run -d --name devops-agent-01 --restart unless-stopped -e AZP_TOKEN={PAT_TOKEN} -e AZP_URL=https://dev.azure.com/{YourOrganisation} -e AZP_AGENT_NAME=agent-01 -e POOL={SelfHostedPool} devops-agent:v1 # Running in detached mode
```
