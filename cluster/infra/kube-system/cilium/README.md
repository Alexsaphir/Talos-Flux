# Cilium

## Network choices

The cluster uses non routable ip internally.
Only the nodes have a public ipv6 and are in vlan 42.

|                  | ipv4              | ipv6                     |
| ---------------- | ----------------- | ------------------------ |
| _clusterPodNets_ | `10.42.0.0/16`    | `fdd5:aa8:9535:42::/112` |
| _clusterSvcNets_ | `10.43.0.0/16`    | `fdd5:aa8:9535:43::/112` |
|                  |                   |                          |
|                  |                   |                          |
| Nodes            | `192.168.42.0/24` | `2a01:e0a:2a:5552::/64`  |
| Annoucement      | `192.168.43.0/24` | `2a01:e0a:2a:5557::/64`  |

Cilium uses another subnet for ipv4 and a public one for ipv6.

They are announced on l2 and use BGP.

|       | ipv4             | ipv6                       |
| ----- | ---------------- | -------------------------- |
|       |                  |                            |
|       |                  |                            |
| Envoy | `192.168.43.100` | `2a01:e0a:2a:5557::43:100` |

## Firewall

`2a01:e0a:2a:5557::/64` can be exposed to the internet.
