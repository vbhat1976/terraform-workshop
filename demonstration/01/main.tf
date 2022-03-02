resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "demo_eni" {
  subnet_id   = aws_subnet.demo_subnet.id
  private_ips = ["10.0.0.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-09a2a0f7d2db8baca"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.demo_eni.id
    device_index         = 0
  }
}