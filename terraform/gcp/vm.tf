resource "google_compute_instance" "dev" {
  name         = "zox-${count.index}" # Name of the Machine -get from the variable
  machine_type = "${var.machine_type}" # Capacity of instance
  zone         = "${var.region}-a" # Where to create the instance

  count = "${var.count}"
  # i am the  boot disk. you are nothing without me
  boot_disk {
    initialize_params{
     image = "ubuntu-os-cloud/ubuntu-1604-lts" # OS image that you want for your servers
     size = "20" # HDD size
     type = "pd-ssd" # Type of HDD - SSD or Magnetic
    }
  }


  # without me you wont be able to access your instance

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  # Hi i am metadata. i will be your key pair friend

  metadata
  {
    startup-script = "${file("${var.startup_script}")}" # get the startup_script from a file which is  bootstrap script
  }
}

output "ipaddress" {
  value = "${google_compute_instance.dev.*.network_interface.0.access_config.0.assigned_nat_ip}"
}
