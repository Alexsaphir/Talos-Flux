---
apiVersion: v1alpha1
kind: KubeNodeConfig
labels:
  topology.kubernetes.io/zone: controlPlane

annotations:
  installerImage: factory.talos.dev/metal-installer/{{ .SchematicID }}:{{ .TalosVersion }}
