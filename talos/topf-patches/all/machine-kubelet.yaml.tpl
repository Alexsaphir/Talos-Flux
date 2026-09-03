---
machine:
  kubelet:
    extraConfig:
      maxPods: 150
      serializeImagePulls: false
      maxParallelImagePulls: 4

      imageMaximumGCAge: 168h
      imageGCHighThresholdPercent: 50
      imageGCLowThresholdPercent: 20

    nodeIP:
      validSubnets:
        - {{ .Data.nodeSubnetV4 }}
        - {{ .Data.nodeSubnetV6 }}
