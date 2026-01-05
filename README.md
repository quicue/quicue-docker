# quicue-docker

Docker provider for [quicue](https://github.com/quicue/quicue). Implements action patterns for Docker containers, Compose stacks, networks, volumes, and images.

**Security note:** Command strings use direct interpolation. Do not pass untrusted input as parameters.

## Install

### From Registry (when published)

```bash
export CUE_REGISTRY='quicue.ca=ghcr.io/quicue'
cue mod tidy
```

### Local Development

```bash
mkdir -p cue.mod/pkg/quicue.ca
ln -sf /path/to/quicue/vocab cue.mod/pkg/quicue.ca/vocab
ln -sf /path/to/quicue/patterns cue.mod/pkg/quicue.ca/patterns
```

## Usage

```cue
import "quicue.ca/docker/patterns"

// Container with all action types
nginx: {
    container: patterns.#ContainerActions & {CONTAINER: "nginx"}
    lifecycle: patterns.#ContainerLifecycle & {CONTAINER: "nginx"}
}

// Docker Compose stack
webapp: patterns.#ComposeActions & {
    PROJECT: "webapp"
    DIR:     "/opt/stacks/webapp"
}

// Docker host
host: patterns.#HostActions & {}
```

## Patterns

### Action Patterns (docker.cue)

Direct action implementations:

| Pattern | Description | Actions |
|---------|-------------|---------|
| `#ContainerActions` | Container operations | status, logs, shell, start, stop, restart |
| `#ContainerLifecycle` | Extended lifecycle | start, stop, restart, kill, pause, unpause, remove |
| `#ComposeActions` | Docker Compose stacks | up, down, ps, logs, restart, pull, config |
| `#NetworkActions` | Network operations | inspect, ls, connect, disconnect |
| `#VolumeActions` | Volume operations | inspect, ls, remove |
| `#ImageActions` | Image operations | pull, inspect, history, remove |
| `#HostActions` | Docker host operations | info, ps, images, stats, prune, df |
| `#ConnectivityActions` | Network connectivity | ping, ssh |

### Action Templates (templates.cue)

Standalone templates with UPPERCASE parameters for flexible composition:

```cue
import "quicue.ca/docker/patterns"

_T: patterns.#ActionTemplates

// Build actions from templates
actions: {
    status: _T.container_status & {CONTAINER: "nginx"}
    logs:   _T.container_logs & {CONTAINER: "nginx", LINES: 500}
    shell:  _T.container_shell & {CONTAINER: "nginx", SHELL: "/bin/bash"}
    exec:   _T.container_exec & {CONTAINER: "nginx", COMMAND: "nginx -t"}
}
```

Available templates with UPPERCASE parameters:

**Container:** `container_status` (CONTAINER), `container_logs` (CONTAINER, LINES), `container_shell` (CONTAINER, SHELL), `container_start`, `container_stop`, `container_restart`, `container_exec` (CONTAINER, COMMAND), `container_inspect`, `container_top`, `container_stats`, `container_kill`, `container_pause`, `container_unpause`, `container_remove`

**Image:** `image_pull` (IMAGE), `image_inspect`, `image_history`, `image_remove`, `image_ls`

**Network:** `network_inspect` (NETWORK), `network_ls`, `network_connect` (NETWORK, CONTAINER), `network_disconnect`

**Volume:** `volume_inspect` (VOLUME), `volume_ls`, `volume_remove`

**Compose:** `compose_up` (PROJECT, DIR), `compose_down`, `compose_ps`, `compose_logs` (PROJECT, DIR, LINES), `compose_restart`, `compose_pull`, `compose_config`, `compose_exec` (PROJECT, DIR, SERVICE, COMMAND)

**System:** `docker_info`, `docker_ps`, `docker_stats`, `docker_prune`, `docker_df`

**Connectivity:** `ping` (IP), `ssh` (IP, USER), `info` (NAME)

**Health:** `health_check` (CONTAINER), `port_check` (IP, PORT), `http_health` (URL)

## Examples

### Standalone Container

```cue
import "quicue.ca/docker/patterns"

postgres: {
    container: patterns.#ContainerActions & {CONTAINER: "postgres"}
    lifecycle: patterns.#ContainerLifecycle & {CONTAINER: "postgres"}
    image:     patterns.#ImageActions & {IMAGE: "postgres:15"}
}

// Get status command
// cue export . -e postgres.container.status.command --out text
// -> docker inspect -f '{{.State.Status}}' postgres
```

### Docker Compose Stack

```cue
import "quicue.ca/docker/patterns"

monitoring: patterns.#ComposeActions & {
    PROJECT: "monitoring"
    DIR:     "/opt/stacks/monitoring"
}

// Get up command
// cue export . -e monitoring.up.command --out text
// -> docker compose -p monitoring -f /opt/stacks/monitoring/docker-compose.yml up -d
```

### Custom Actions with Templates

```cue
import "quicue.ca/docker/patterns"

_T: patterns.#ActionTemplates

app_actions: {
    // Custom shell
    bash: _T.container_shell & {
        CONTAINER: "myapp"
        SHELL:     "/bin/bash"
    }

    // Run migrations
    migrate: _T.container_exec & {
        CONTAINER: "myapp"
        COMMAND:   "python manage.py migrate"
    }

    // Health check
    health: _T.http_health & {
        URL: "http://localhost:8080/health"
    }
}
```

## Export Commands

```bash
# Quick overview
cue export ./examples -e output

# Get specific command
cue export ./examples -e nginx.container.status.command --out text
# -> docker inspect -f '{{.State.Status}}' nginx

# Get compose up command
cue export ./examples -e webapp_stack.up.command --out text
# -> docker compose -p webapp -f /opt/stacks/webapp/docker-compose.yml up -d

# Export all actions as YAML
cue export ./examples -e nginx.container --out yaml
```

## Run Tests

```bash
cue vet -c ./...
```

## Publishing

```bash
# Authenticate to ghcr.io
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Publish (requires quicue.ca to be published first)
CUE_REGISTRY='quicue.ca=ghcr.io/quicue' cue mod publish v0.1.0
```

## License

MIT
