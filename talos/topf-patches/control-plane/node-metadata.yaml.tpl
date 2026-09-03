---
machine:
  nodeLabels:
    topology.kubernetes.io/zone: controlPlane

    # talhelper dropped this label whenever allowSchedulingOnControlPlanes was
    # set; topf keeps the Talos default, so remove it explicitly.
    node.kubernetes.io/exclude-from-external-load-balancers:
      $patch: delete

  nodeAnnotations:
    installerImage: factory.talos.dev/metal-installer/{{ .SchematicID }}:{{ .TalosVersion }}
