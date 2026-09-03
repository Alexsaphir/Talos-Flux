---
apiVersion: v1alpha1
kind: KubeletConfig
config:
  crashLoopBackOff:
    maxContainerRestartPeriod: 60s

  maxPods: 150
  serializeImagePulls: false
  maxParallelImagePulls: 4

  imageMaximumGCAge: 168h
  imageGCHighThresholdPercent: 50
  imageGCLowThresholdPercent: 20

---
apiVersion: v1alpha1
kind: KubeNodeConfig
nodeIP:
  validSubnets:
    - {{ .Data.nodeSubnetV4 }}
    - {{ .Data.nodeSubnetV6 }}
