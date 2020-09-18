
resource "kubernetes_deployment" "jvminfo" {
  metadata {
    name = "jvminfo-deployment"
    labels = {
      App = "jvminfo"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "jvminfo"
      }
    }
    template {
      metadata {
        labels = {
          App = "jvminfo"
        }
      }
      spec {
        container {
          image = "celeguim/jvminfo"
          name  = "jvminfo"

          port {
            container_port = 8080
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jvminfo" {
  metadata {
    name = "jvminfo"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}
