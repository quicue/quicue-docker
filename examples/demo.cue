// Demo: Docker provider usage
package example

import "quicue.ca/docker/patterns"

// =============================================================================
// Standalone containers
// =============================================================================

// Web server container
nginx: {
	container: patterns.#ContainerActions & {CONTAINER: "nginx"}
	lifecycle: patterns.#ContainerLifecycle & {CONTAINER: "nginx"}
	connect:   patterns.#ConnectivityActions & {IP: "172.17.0.2", USER: "root"}
}

// Database container
postgres: {
	container: patterns.#ContainerActions & {CONTAINER: "postgres"}
	lifecycle: patterns.#ContainerLifecycle & {CONTAINER: "postgres"}
	image:     patterns.#ImageActions & {IMAGE: "postgres:15"}
}

// Redis cache
redis: {
	container: patterns.#ContainerActions & {CONTAINER: "redis"}
	lifecycle: patterns.#ContainerLifecycle & {CONTAINER: "redis"}
}

// =============================================================================
// Docker Compose stacks
// =============================================================================

// Web application stack
webapp_stack: patterns.#ComposeActions & {
	PROJECT: "webapp"
	DIR:     "/opt/stacks/webapp"
}

// Monitoring stack (Prometheus + Grafana)
monitoring_stack: patterns.#ComposeActions & {
	PROJECT: "monitoring"
	DIR:     "/opt/stacks/monitoring"
}

// =============================================================================
// Docker resources
// =============================================================================

// Networks
networks: {
	frontend: patterns.#NetworkActions & {NETWORK: "frontend"}
	backend:  patterns.#NetworkActions & {NETWORK: "backend"}
}

// Volumes
volumes: {
	postgres_data: patterns.#VolumeActions & {VOLUME: "postgres_data"}
	redis_data:    patterns.#VolumeActions & {VOLUME: "redis_data"}
}

// Images
images: {
	nginx:    patterns.#ImageActions & {IMAGE: "nginx:alpine"}
	postgres: patterns.#ImageActions & {IMAGE: "postgres:15"}
	redis:    patterns.#ImageActions & {IMAGE: "redis:7-alpine"}
}

// =============================================================================
// Docker host
// =============================================================================

docker_host: patterns.#HostActions & {}

// Remote Docker host
remote_docker: patterns.#HostActions & {
	HOST: "docker-server.local"
	USER: "deploy"
}

// =============================================================================
// Using templates for custom actions
// =============================================================================

_T: patterns.#ActionTemplates

custom_actions: {
	// Container with custom shell
	app_bash: _T.container_shell & {
		CONTAINER: "myapp"
		SHELL:     "/bin/bash"
	}

	// Container logs with more lines
	app_logs: _T.container_logs & {
		CONTAINER: "myapp"
		LINES:     500
	}

	// Execute specific command
	app_migrate: _T.container_exec & {
		CONTAINER: "myapp"
		COMMAND:   "python manage.py migrate"
	}

	// Health check endpoint
	api_health: _T.http_health & {
		URL: "http://localhost:8080/health"
	}

	// Port connectivity check
	db_port: _T.port_check & {
		IP:   "172.17.0.3"
		PORT: 5432
	}
}

// Export commands:
//   cue export ./examples -e nginx.container.status.command --out text
//   cue export ./examples -e webapp_stack.up.command --out text
//   cue export ./examples -e networks.frontend.inspect.command --out text
//   cue export ./examples -e docker_host.ps.command --out text

// Summary output
output: {
	example_commands: {
		"container_status": "docker inspect -f '{{.State.Status}}' nginx"
		"container_logs":   "docker logs --tail 100 postgres"
		"compose_up":       "docker compose -p webapp -f /opt/stacks/webapp/docker-compose.yml up -d"
		"network_inspect":  "docker network inspect frontend"
		"host_ps":          "docker ps -a"
		"custom_exec":      "docker exec myapp python manage.py migrate"
	}
	usage: """
		# Get any command:
		cue export ./examples -e nginx.container.status.command --out text
		cue export ./examples -e webapp_stack.up.command --out text
		cue export ./examples -e custom_actions.app_migrate.command --out text
		"""
}
