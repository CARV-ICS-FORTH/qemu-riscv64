# RISC-V QEMU in Kubernetes

This project provides an easy method for deploying RISC-V [QEMU](https://www.qemu.org) instances in [Kubernetes](https://kubernetes.io). Using [Helm](https://helm.sh), you can quickly configure and deploy a RISC-V VM and access its console through a web interface.

## Deploying

When runnning Kubernetes in [Docker Desktop](https://www.docker.com/products/docker-desktop/), you can just run the following and visit [http://localhost:8080](http://localhost:8080):

```bash
helm install myvm ./chart/qemu-riscv64
```

To run a second instance, specify a different port:

```bash
helm install myvm ./chart/qemu-riscv64 \
    --set service.port=8081
```

If running Kubernetes with [minikube](https://minikube.sigs.k8s.io/), the above commands apply, but you also need to enable service forwarding to localhost with `minikube tunnel`.

The table below lists all available options (the current version is set in the `Makefile`):

| Variable          | Default                                            | Notes                                                |
|-------------------|----------------------------------------------------|------------------------------------------------------|
| `images.launcher` | `carvicsforth/qemu-riscv64-launcher:<version>`     |                                                      |
| `images.console`  | `carvicsforth/qemu-riscv64-console:<version>`      |                                                      |
| `images.data`     | `carvicsforth/qemu-riscv64-ubuntu:22.04-1`         | Use for custom files, kernel, and BIOS               |
| `service.type`    | `LoadBalancer`                                     |                                                      |
| `service.port`    | `8080`                                             |                                                      |
| `cpu.features`    |                                                    | Can be overriden by the `data` image                 |
| `cpu.count`       | `2`                                                | Also sets resource request in deployment             |
| `memory`          | `2048`                                             | Also sets resource request in deployment             |
| `append`          |                                                    | Kernel options. Can be overriden by the `data` image |

Available `data` images:

| Image                                           | Notes                                                |
|-------------------------------------------------|------------------------------------------------------|
| `carvicsforth/qemu-riscv64-ubuntu:22.04-1`      | Standard Ubuntu image (login: `ubuntu`/`ubuntu`)     |
| `carvicsforth/qemu-riscv64-buildroot:00709af-1` | Custom built image, uses RVV1.0.0 (login: `root`/``) |

To images set the CPU specifications they need, as well as custom kernel options.
To run the custom [Buildroot](https://buildroot.org) image:

```bash
helm install myvm ./chart/qemu-riscv64 \
    --set images.data="carvicsforth/qemu-riscv64-buildroot:00709af-1"
```

## Architecture

We use two basic containers for each VM:
* The `launcher` contains the QEMU binary. A script starts QEMU automatically when it runs, using environmental variables to define the number of CPUs, the memory, and other parameters. QEMU is configured to serve its console via telnet at local port 10023.
* The `console` is based on [gotty](https://github.com/sorenisanerd/gotty). Gotty runs a local command (in this case `telnet`), captures input and output streams, exposes them via websockets, and then offers a web-based terminal emulator ([xterm.js](https://github.com/xtermjs/xterm.js)) for the user to interact with what has been run.

The root filesystem used by QEMU is also packaged up in a container image (which we call `data`), using a similar method to [KubeVirt](https://github.com/kubevirt/kubevirt). Before each VM starts, the `data` container copies its contents to an ephemeral volume that is shared with the `launcher`. As `data` contains only VM-specific files (it can optionally also hold a custom kernel and BIOS), we copy over a [BusyBox](https://busybox.net) binary before it starts, so it can run `cp` to populate the shared volume.

## Building images

Container images are [available](https://hub.docker.com/r/carvicsforth/) for both `amd64` and `arm64` architectures.

To build your own locally, set the `REGISTRY` variable and run:
```bash
REGISTRY=<Docker Hub username> make container
```

The image tag for the `launcher` and `console` images is controlled via the `VERSION` variable.

## Acknowledgements

This project has received funding from the European Union’s Horizon Europe research and innovation programme through project RISER ("RISC-V for Cloud Services", GA-101092993) and from the Key Digital Technologies Joint Undertaking through project REBECCA ("Reconfigurable Heterogeneous Highly Parallel Processing Platform for safe and secure AI", GA-101097224). KDT JU projects are jointly funded by the European Commission and the involved state members (including the Greek General Secretariat for Research and Innovation).
