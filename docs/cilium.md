# Cilium

![Cilium Logo](./assets/cilium_logo.png)

Cilium is the **container network interface** of choice for the cluster. It provides a lot of advantages,
that extend its functionality from basic CNI duties and make it an excellent choice when compared to other CNIs.

## Notable features

- **Faster native pod-to-pod networking with eBPF (no iptables overhead)**
- **Real-time L3/L4 observability with Hubble**
- **Built-in security with WireGuard encryption**
- **Advanced network policy enforcement at multiple layers**
- **MetalLB replacement with LB IPAM and L2 announcements**

## Installation

### Cilium CLI

Download the Cilium CLI with the following

```bash
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
```

Then, configure IP and PORT variables based on where the Kubernetes Service is running.

```bash
IP=<YOUR-IP>
PORT=<YOUR-PORT>
cilium install --set k8sServiceHost=${IP} \
--set k8sServicePort=${PORT} \
--set kubeProxyReplacement=true \
--set hubble.relay.enabled=true \
--set hubble.ui.enabled=true \
--set ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"
```

!!! NOTE

    By default, Cilium uses cluster-pool-ipv4-cidr: 10.0.0.0/8 for its IPAM. That default can conflict with k3s’s PodCIDR (10.42.0.0/16), which will break cross-node pod communication if pods get IPs outside the intended range. To avoid this, explicitly set:

    ```yaml
    ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"
    ```

    You can also set the IPAM mode to kubernetes, if you would like cilium to pick up the PodCIDR from the kubernetes v1.Node object.

    ```yaml
    ipam.mode=kubernetes
    ```
