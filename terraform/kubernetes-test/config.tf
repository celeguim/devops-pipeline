provider "kubernetes" {
  # host = "https://localhost:6443"
}
resource "kubernetes_namespace" "namespace1" {
  metadata {
    name = "test-namespace"
  }
}
