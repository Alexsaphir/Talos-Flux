---
apiVersion: v1alpha1
kind: UnattendedInstallConfig
provisioning:
  diskSelector:
    match: disk.serial == "{{ .Node.Data.installDiskSerial }}"
---
apiVersion: v1alpha1
kind: KubeNodeConfig
annotations:
  installerImage: factory.talos.dev/metal-installer/{{ .SchematicID }}:{{ .TalosVersion }}
