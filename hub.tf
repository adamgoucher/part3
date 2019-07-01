data "aws_ami" "linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # AWS
}

resource "aws_instance" "hub" {
  ami           = "${data.aws_ami.linux2.id}"
  instance_type = "t2.micro"

  tags = {
    Name = "hub"
  }
}