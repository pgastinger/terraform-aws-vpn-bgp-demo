resource "null_resource" "ssh-keys" {

  provisioner "local-exec" {
    command = "ssh-keygen -f my_keys -N \"\""

  }
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "10s"
}


resource "aws_key_pair" "my_pub_key" {
  key_name   = "my_pub_key"
  public_key = file("${path.module}/my_keys.pub")
  depends_on       = [time_sleep.wait_30_seconds]

}
