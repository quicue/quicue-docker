// Docker Provider - Action implementations for Docker containers and Compose stacks
// Uses docker and docker compose commands
//
// Usage:
//   import "quicue.ca/docker/patterns"
//   container_actions: patterns.#ContainerActions & {CONTAINER: "nginx"}
package patterns

// #ContainerActions - Docker container actions
#ContainerActions: {
	CONTAINER: string

	status: {
		name:        string | *"Status"
		description: string | *"Check container \(CONTAINER) status"
		command:     string | *"docker inspect -f '{{.State.Status}}' \(CONTAINER)"
		icon:        string | *"[status]"
		category:    string | *"monitor"
	}
	logs: {
		name:        string | *"Logs"
		description: string | *"View container \(CONTAINER) logs"
		command:     string | *"docker logs --tail 100 \(CONTAINER)"
		icon:        string | *"[logs]"
		category:    string | *"monitor"
	}
	shell: {
		name:        string | *"Shell"
		description: string | *"Open shell in container \(CONTAINER)"
		command:     string | *"docker exec -it \(CONTAINER) /bin/sh"
		icon:        string | *"[shell]"
		category:    string | *"connect"
	}
	start: {
		name:        string | *"Start"
		description: string | *"Start container \(CONTAINER)"
		command:     string | *"docker start \(CONTAINER)"
		icon:        string | *"[start]"
		category:    string | *"admin"
	}
	stop: {
		name:        string | *"Stop"
		description: string | *"Stop container \(CONTAINER)"
		command:     string | *"docker stop \(CONTAINER)"
		icon:        string | *"[stop]"
		category:    string | *"admin"
	}
	restart: {
		name:        string | *"Restart"
		description: string | *"Restart container \(CONTAINER)"
		command:     string | *"docker restart \(CONTAINER)"
		icon:        string | *"[restart]"
		category:    string | *"admin"
	}
}

// #ContainerLifecycle - Extended container lifecycle operations
#ContainerLifecycle: {
	CONTAINER: string

	start: {
		name:        string | *"Start"
		description: string | *"Start container \(CONTAINER)"
		command:     string | *"docker start \(CONTAINER)"
		icon:        string | *"[start]"
		category:    string | *"admin"
	}
	stop: {
		name:        string | *"Stop"
		description: string | *"Stop container \(CONTAINER)"
		command:     string | *"docker stop \(CONTAINER)"
		icon:        string | *"[stop]"
		category:    string | *"admin"
	}
	restart: {
		name:        string | *"Restart"
		description: string | *"Restart container \(CONTAINER)"
		command:     string | *"docker restart \(CONTAINER)"
		icon:        string | *"[restart]"
		category:    string | *"admin"
	}
	kill: {
		name:        string | *"Kill"
		description: string | *"Force kill container \(CONTAINER)"
		command:     string | *"docker kill \(CONTAINER)"
		icon:        string | *"[kill]"
		category:    string | *"admin"
	}
	pause: {
		name:        string | *"Pause"
		description: string | *"Pause container \(CONTAINER)"
		command:     string | *"docker pause \(CONTAINER)"
		icon:        string | *"[pause]"
		category:    string | *"admin"
	}
	unpause: {
		name:        string | *"Unpause"
		description: string | *"Unpause container \(CONTAINER)"
		command:     string | *"docker unpause \(CONTAINER)"
		icon:        string | *"[unpause]"
		category:    string | *"admin"
	}
	remove: {
		name:        string | *"Remove"
		description: string | *"Remove container \(CONTAINER)"
		command:     string | *"docker rm \(CONTAINER)"
		icon:        string | *"[remove]"
		category:    string | *"admin"
	}
}

// #ComposeActions - Docker Compose stack actions
#ComposeActions: {
	PROJECT: string
	DIR:     string // path to docker-compose.yml directory

	up: {
		name:        string | *"Up"
		description: string | *"Start \(PROJECT) stack"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml up -d"
		icon:        string | *"[up]"
		category:    string | *"admin"
	}
	down: {
		name:        string | *"Down"
		description: string | *"Stop and remove \(PROJECT) stack"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml down"
		icon:        string | *"[down]"
		category:    string | *"admin"
	}
	ps: {
		name:        string | *"List"
		description: string | *"List \(PROJECT) stack services"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml ps"
		icon:        string | *"[list]"
		category:    string | *"monitor"
	}
	logs: {
		name:        string | *"Logs"
		description: string | *"View \(PROJECT) stack logs"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml logs --tail 100"
		icon:        string | *"[logs]"
		category:    string | *"monitor"
	}
	restart: {
		name:        string | *"Restart"
		description: string | *"Restart \(PROJECT) stack"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml restart"
		icon:        string | *"[restart]"
		category:    string | *"admin"
	}
	pull: {
		name:        string | *"Pull"
		description: string | *"Pull latest images for \(PROJECT) stack"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml pull"
		icon:        string | *"[pull]"
		category:    string | *"admin"
	}
	config: {
		name:        string | *"Config"
		description: string | *"Validate and view \(PROJECT) compose config"
		command:     string | *"docker compose -p \(PROJECT) -f \(DIR)/docker-compose.yml config"
		icon:        string | *"[config]"
		category:    string | *"info"
	}
}

// #NetworkActions - Docker network actions
#NetworkActions: {
	NETWORK: string

	inspect: {
		name:        string | *"Inspect"
		description: string | *"Inspect network \(NETWORK)"
		command:     string | *"docker network inspect \(NETWORK)"
		icon:        string | *"[inspect]"
		category:    string | *"info"
	}
	ls: {
		name:        string | *"List"
		description: string | *"List all networks"
		command:     string | *"docker network ls"
		icon:        string | *"[list]"
		category:    string | *"info"
	}
	connect: {
		name:        string | *"Connect"
		description: string | *"Connect container to network \(NETWORK)"
		command:     string | *"docker network connect \(NETWORK) <container>"
		icon:        string | *"[connect]"
		category:    string | *"admin"
	}
	disconnect: {
		name:        string | *"Disconnect"
		description: string | *"Disconnect container from network \(NETWORK)"
		command:     string | *"docker network disconnect \(NETWORK) <container>"
		icon:        string | *"[disconnect]"
		category:    string | *"admin"
	}
}

// #VolumeActions - Docker volume actions
#VolumeActions: {
	VOLUME: string

	inspect: {
		name:        string | *"Inspect"
		description: string | *"Inspect volume \(VOLUME)"
		command:     string | *"docker volume inspect \(VOLUME)"
		icon:        string | *"[inspect]"
		category:    string | *"info"
	}
	ls: {
		name:        string | *"List"
		description: string | *"List all volumes"
		command:     string | *"docker volume ls"
		icon:        string | *"[list]"
		category:    string | *"info"
	}
	remove: {
		name:        string | *"Remove"
		description: string | *"Remove volume \(VOLUME)"
		command:     string | *"docker volume rm \(VOLUME)"
		icon:        string | *"[remove]"
		category:    string | *"admin"
	}
}

// #ImageActions - Docker image actions
#ImageActions: {
	IMAGE: string

	pull: {
		name:        string | *"Pull"
		description: string | *"Pull image \(IMAGE)"
		command:     string | *"docker pull \(IMAGE)"
		icon:        string | *"[pull]"
		category:    string | *"admin"
	}
	inspect: {
		name:        string | *"Inspect"
		description: string | *"Inspect image \(IMAGE)"
		command:     string | *"docker image inspect \(IMAGE)"
		icon:        string | *"[inspect]"
		category:    string | *"info"
	}
	history: {
		name:        string | *"History"
		description: string | *"Show image \(IMAGE) history"
		command:     string | *"docker image history \(IMAGE)"
		icon:        string | *"[history]"
		category:    string | *"info"
	}
	remove: {
		name:        string | *"Remove"
		description: string | *"Remove image \(IMAGE)"
		command:     string | *"docker image rm \(IMAGE)"
		icon:        string | *"[remove]"
		category:    string | *"admin"
	}
}

// #HostActions - Docker host actions (system-wide)
#HostActions: {
	HOST: string | *"localhost"
	USER: string | *""

	// Helper for optional SSH prefix
	_sshPrefix: string | *""
	if USER != "" && HOST != "localhost" {
		_sshPrefix: "ssh \(USER)@\(HOST) "
	}

	info: {
		name:        string | *"Docker Info"
		description: string | *"Show Docker system info"
		command:     string | *"\(_sshPrefix)docker info"
		icon:        string | *"[info]"
		category:    string | *"info"
	}
	ps: {
		name:        string | *"List Containers"
		description: string | *"List all containers"
		command:     string | *"\(_sshPrefix)docker ps -a"
		icon:        string | *"[list]"
		category:    string | *"monitor"
	}
	images: {
		name:        string | *"List Images"
		description: string | *"List all images"
		command:     string | *"\(_sshPrefix)docker images"
		icon:        string | *"[images]"
		category:    string | *"info"
	}
	stats: {
		name:        string | *"Container Stats"
		description: string | *"Show live resource usage"
		command:     string | *"\(_sshPrefix)docker stats --no-stream"
		icon:        string | *"[stats]"
		category:    string | *"monitor"
	}
	prune: {
		name:        string | *"Prune"
		description: string | *"Remove unused containers, networks, images"
		command:     string | *"\(_sshPrefix)docker system prune -f"
		icon:        string | *"[prune]"
		category:    string | *"admin"
	}
	df: {
		name:        string | *"Disk Usage"
		description: string | *"Show Docker disk usage"
		command:     string | *"\(_sshPrefix)docker system df"
		icon:        string | *"[disk]"
		category:    string | *"monitor"
	}
}

// #ConnectivityActions - Network connectivity testing
#ConnectivityActions: {
	IP:   string
	USER: string | *"root"

	ping: {
		name:        string | *"Ping"
		description: string | *"Test network connectivity to \(IP)"
		command:     string | *"ping -c 3 \(IP)"
		icon:        string | *"[ping]"
		category:    string | *"connect"
	}
	ssh: {
		name:        string | *"SSH"
		description: string | *"SSH into host as \(USER)"
		command:     string | *"ssh \(USER)@\(IP)"
		icon:        string | *"[ssh]"
		category:    string | *"connect"
	}
}
