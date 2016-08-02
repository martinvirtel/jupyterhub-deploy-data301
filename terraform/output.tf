output "ip" {
        value = "${aws_eip.jupyter_ip.public_ip}"
}
