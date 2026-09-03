---
cluster:
  # Not deprecated in v1.14 — stays in the v1alpha1 document.
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

# Replaces cluster.allowSchedulingO nControlPlanes:true
---
apiVersion: v1alpha1
kind: KubeNodeConfig
taints:
  node-role.kubernetes.io/control-plane:
    $patch: delete

---
apiVersion: v1alpha1
kind: KubeAdmissionControlConfig
name: PodSecurity
$patch: delete

---
apiVersion: v1alpha1
kind: KubeAPIServerConfig
extraArgs:
  # https://kubernetes.io/docs/tasks/extend-kubernetes/configure-aggregation-layer/
  enable-aggregator-routing: true
  feature-gates: HPAScaleToZero=true
resources:
  requests:
    memory: 3Gi
    cpu: 500m

---
apiVersion: v1alpha1
kind: KubeControllerManagerConfig
extraArgs:
  bind-address: 0.0.0.0
  feature-gates: HPAScaleToZero=true

---
apiVersion: v1alpha1
kind: KubeCoreDNSConfig
enabled: false

---
apiVersion: v1alpha1
kind: KubeProxyConfig
enabled: false

---
apiVersion: v1alpha1
kind: KubeSchedulerConfig
extraArgs:
  bind-address: 0.0.0.0
config:
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
