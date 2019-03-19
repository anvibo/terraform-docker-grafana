
resource "docker_volume" "grafana_data" {
  name = "grafana_data"
  driver = "local-persist"
  driver_opts = {
      "mountpoint" = "${var.vol1_mountpoint}"
  }
}
resource "docker_service" "grafana" {
    name = "grafana-service"

    task_spec {
        container_spec {
            image = "grafana/grafana"

            labels {
                traefik.frontend.rule = "Host:${var.url}"
                traefik.port = 3000
                traefik.docker.network = "${var.traefik_network}"
            }

         

            mounts = [
                {
                    source      = "${docker_volume.grafana_data.name}"
                    target      = "/var/lib/grafana"   
                    type        = "volume"
                    read_only   = false
                },
                
            ]
        }
        networks     = ["${var.networks}"]
    }
}