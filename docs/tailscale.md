# Tailscale

![Tailscale Logo](./assets/tailscale_logo.png)

Tailscale serves as the VPN mesh for all the nodes in the cluster.

- Remote SSH access to all the nodes in the server

# Setting up tailscale

Install the tailscale daemon on Linux with the following command.

```
curl -fsSL https://tailscale.com/install.sh | sh
```

Then, launch the daemon with ssh enabled as follows:

```
tailscale up --ssh
```
