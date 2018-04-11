# FireWall Resource for Allowing Access : SSH, HTTP & HTTPS

resource "google_compute_firewall" "ssh-from-office"
{
  name = "allow-ssh-office"
  network = "default"
    allow
    {
      protocol = "tcp"
      ports = ["22"]
    }
  source_ranges = ["${var.cidr}"]
}


resource "google_compute_firewall" "http-https"
{
  name = "httphttps"
  network = "default"
  allow
  {
    protocol = "tcp"
    ports = ["80","443",]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "prometheus"
{
  name = "montoring"
  network = "default"
  allow
  {
    protocol = "tcp"
    ports = ["9100"]
  }
  source_ranges = ["54.153.41.181"]
}
