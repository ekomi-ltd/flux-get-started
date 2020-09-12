# App
This represents a bare bone application that can be expanded upon by the dependent charts. This chart 
is meant to totally dissolve and melt away leaving only the marks of the parent chart hence the following 
fields are only meaningful for the helm but don't show up in the final templates rendered by the dependent charts.

Hence following fields don't show up from the Chart.yaml:

- `name`
- `version` (though meaningful for Helm to manage depedencies)
- `appVersion`

Follwoing are the keys this chart expects in a chart that adds it as dependency:

```
app:
  parentChart:
    Name: sff                                   # Required
    Version: 0.1.0                              # Required
    AppVersion: "v1.4.6"                        # Required

  secretsFrom: sff                              # Required
  image:                                        # Required - image.repository
    repository: 429316335035.dkr.ecr.eu-central-1.amazonaws.com/ekomi/sff
    tag: "v3.45.3"                              # Optional, will pick up AppVersion from above
  workers:                                      # Optional, describes the workers if any           
    - name: general                             # Required
      command: ["/sbin/workers/general.sh"]     # Required
      args: ["/sbin/workers/general.sh"]        # Required
      containerName: main                       # Optional
      secretsFrom: sff                          # Defauls to the upper level "secretsFrom"
      imagePullSecret: azure-registry           # Optional - defaults to upper level imagePullSecret or aws-registry
      resources:                                # Optional
        requests:                               # Optional - both values underneath default to 50m 128Mi
            cpu: 150m                           
            memory: 256Mi                       
        limits:                                 # Optional - both values underneath default to 100m and 256Mi
            cpu: 500m
            memory: 1024Mi
```