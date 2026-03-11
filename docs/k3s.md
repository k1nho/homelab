# K3s

![K3s logo](./assets/k3s_logo.png)

K3s is the selected **Kubernetes distribution** used in the cluster. It provides a fully compliant Kubernetes
distribution great for edge, embedded, and homelabs.

## Installation

### Control Plane (Server)

#### CNI Replacement with Cilium (Optional)

```yaml {filename="k3sconfig.yaml"}
flannel-backend: "none"
disable-kube-proxy: true
disable-network-policy: true
disable:
  - traefik
  - servicelb
cluster-init: true
```

#### Installing With Script

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --config=$HOME/k3sconfig.yaml
```

### Worker Node (Agent)

Obtain the server token with the following:

```yaml
sudo cat /var/lib/rancher/k3s/server/token
```

#### Worker Node YAML

```yaml {filename="k3sagent.yaml"}
token: <your-k3s-token>
server: https://<your-ip>:<your-port>
```

#### Installing With Script

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -s - --config=$HOME/k3sagent.yaml
```

## Alternatives

Other fantastic distributions:

### Talos Linux

[Talos Linux](https://www.talos.dev/) is an excellent choice for an operating system dedicated to Kubernetes providing a secure, immutable, and minimal design.
