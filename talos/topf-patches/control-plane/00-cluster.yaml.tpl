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
# Allow scheduling on control-plane nodes
apiVersion: v1alpha1
kind: KubeNodeConfig
taints:
  node-role.kubernetes.io/control-plane:
    $patch: delete

---
apiVersion: v1alpha1
kind: KubeAPIServerConfig
certExtraSANs:
  - talos.cluster.alexsaphir.com
  - 127.0.0.1 # KubePrism
extraArgs:
  # https://kubernetes.io/docs/tasks/extend-kubernetes/configure-aggregation-layer/
  enable-aggregator-routing: true
resources:
  requests:
    memory: 3Gi
    cpu: 500m

---
apiVersion: v1alpha1
kind: KubeControllerManagerConfig
extraArgs:
  bind-address: 0.0.0.0

---
apiVersion: v1alpha1
kind: KubeCoreDNSConfig
enabled: false

---
# Disable built-in CNI and kube-proxy to use Cilium
apiVersion: v1alpha1
kind: KubeFlannelCNIConfig
$patch: delete

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
