---
cluster:
  allowSchedulingOnControlPlanes: true

  apiServer:
    admissionControl:
      $patch: delete

    extraArgs:
      # https://kubernetes.io/docs/tasks/extend-kubernetes/configure-aggregation-layer/
      enable-aggregator-routing: true
      feature-gates: HPAScaleToZero=true

    resources:
      requests:
        memory: 3Gi
        cpu: 500m

  controllerManager:
    extraArgs:
      bind-address: 0.0.0.0
      node-cidr-mask-size-ipv6: '112'
      feature-gates: HPAScaleToZero=true

  coreDNS:
    disabled: true

  etcd:
    extraArgs:
      listen-metrics-urls: http://0.0.0.0:2381
      # tune etcd for slower disk latency & higher network RTT (JJGadgets)
      heartbeat-interval: '500'
      election-timeout: '5000'
      # Prevent database bloat with auto-compaction
      auto-compaction-mode: periodic
      auto-compaction-retention: '1h'
    advertisedSubnets:
      - {{ .Data.nodeSubnetV4 }}
      - {{ .Data.nodeSubnetV6 }}

  proxy:
    disabled: true

  scheduler:
    extraArgs:
      bind-address: 0.0.0.0
    config:
      apiVersion: kubescheduler.config.k8s.io/v1
      kind: KubeSchedulerConfiguration
      profiles:
        - schedulerName: default-scheduler
          plugins:
            # Disable imagelocality
            score:
              disabled:
                - name: ImageLocality
          pluginConfig:
            - name: PodTopologySpread
              args:
                defaultingType: List
                defaultConstraints:
                  - maxSkew: 1
                    topologyKey: kubernetes.io/hostname
                    whenUnsatisfiable: ScheduleAnyway
