# terraform-aws-vpn-bgp-demo

based on Adrians advanced demos:
https://www.reddit.com/r/AmazonWebServices/comments/hzbj9e/series_of_mini_projectsadvanced_demos_for_aws/
https://github.com/acantril/learn-cantrill-io-labs

## Mini Project : Implement a BGP Based, HA, Dynamic Site-to-Site VPN with no hardware
https://www.reddit.com/r/aws/comments/hjtq23/mini_project_implement_a_bgp_based_ha_dynamic/

## How To
### Generate SSH keys
```
peter@peter-desktop:~/github/terraform-aws-vpn-bgp-demo$ ssh-keygen -f my_keys
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in my_keys
Your public key has been saved in my_keys.pub
The key fingerprint is:
SHA256:xRVofo35sZux1XHN7S0RfSVqSsxI1MBY76OMwowlne4 peter@peter-desktop
The key's randomart image is:
+---[RSA 3072]----+
|       ==o .o...o|
|      ...*+. ...o|
|        .oB o+ o+|
|   . .   +.o+ +.=|
|  . +   S +. . ==|
|   B   o . .  = =|
|  . = . o      B |
|   . .        +  |
|    E            |
+----[SHA256]-----+
```

### Terraform apply

```
root@v22019078674692622:~/terraform-aws-vpn-bgp-demo# terraform apply
data.aws_ami.app_ami: Refreshing state...
data.aws_availability_zones.available: Refreshing state...
data.aws_ami.router_ami: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.aws_availability_zones.available will be read during apply
  # (config refers to values not yet known)
 <= data "aws_availability_zones" "available"  {
        group_names = [
            "eu-central-1",
        ]
      ~ id          = "2020-08-28 08:21:47.323722663 +0000 UTC" -> "2020-08-28 08:21:49.489938925 +0000 UTC"
        names       = [
            "eu-central-1a",
            "eu-central-1b",
            "eu-central-1c",
        ]
        state       = "available"
        zone_ids    = [
            "euc1-az2",
            "euc1-az3",
            "euc1-az1",
        ]
    }

  # aws_customer_gateway.router1 will be created
  + resource "aws_customer_gateway" "router1" {
      + arn        = (known after apply)
      + bgp_asn    = "65016"
      + id         = (known after apply)
      + ip_address = (known after apply)
      + tags       = {
          + "Name" = "ONPREM-ROUTER1"
        }
      + type       = "ipsec.1"
    }

  # aws_customer_gateway.router2 will be created
  + resource "aws_customer_gateway" "router2" {
      + arn        = (known after apply)
      + bgp_asn    = "65016"
      + id         = (known after apply)
      + ip_address = (known after apply)
      + tags       = {
          + "Name" = "ONPREM-ROUTER2"
        }
      + type       = "ipsec.1"
    }

  # aws_ec2_transit_gateway.tgw will be created
  + resource "aws_ec2_transit_gateway" "tgw" {
      + amazon_side_asn                    = 64512
      + arn                                = (known after apply)
      + association_default_route_table_id = (known after apply)
      + auto_accept_shared_attachments     = "disable"
      + default_route_table_association    = "enable"
      + default_route_table_propagation    = "enable"
      + dns_support                        = "enable"
      + id                                 = (known after apply)
      + owner_id                           = (known after apply)
      + propagation_default_route_table_id = (known after apply)
      + tags                               = {
          + "Name" = "TGW"
        }
      + vpn_ecmp_support                   = "enable"
    }

  # aws_ec2_transit_gateway_vpc_attachment.tgw_attach will be created
  + resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
      + dns_support                                     = "enable"
      + id                                              = (known after apply)
      + ipv6_support                                    = "disable"
      + subnet_ids                                      = (known after apply)
      + transit_gateway_default_route_table_association = true
      + transit_gateway_default_route_table_propagation = true
      + transit_gateway_id                              = (known after apply)
      + vpc_id                                          = (known after apply)
      + vpc_owner_id                                    = (known after apply)
    }

  # aws_eip.router1_eip will be created
  + resource "aws_eip" "router1_eip" {
      + allocation_id     = (known after apply)
      + association_id    = (known after apply)
      + customer_owned_ip = (known after apply)
      + domain            = (known after apply)
      + id                = (known after apply)
      + instance          = (known after apply)
      + network_interface = (known after apply)
      + private_dns       = (known after apply)
      + private_ip        = (known after apply)
      + public_dns        = (known after apply)
      + public_ip         = (known after apply)
      + public_ipv4_pool  = (known after apply)
      + vpc               = true
    }

  # aws_eip.router2_eip will be created
  + resource "aws_eip" "router2_eip" {
      + allocation_id     = (known after apply)
      + association_id    = (known after apply)
      + customer_owned_ip = (known after apply)
      + domain            = (known after apply)
      + id                = (known after apply)
      + instance          = (known after apply)
      + network_interface = (known after apply)
      + private_dns       = (known after apply)
      + private_ip        = (known after apply)
      + public_dns        = (known after apply)
      + public_ip         = (known after apply)
      + public_ipv4_pool  = (known after apply)
      + vpc               = true
    }

  # aws_iam_instance_profile.ec2_profile will be created
  + resource "aws_iam_instance_profile" "ec2_profile" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = "ec2_profile"
      + path        = "/"
      + role        = "ssm_role"
      + unique_id   = (known after apply)
    }

  # aws_iam_role.ssm_role will be created
  + resource "aws_iam_role" "ssm_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = {
                  + Action    = "sts:AssumeRole"
                  + Effect    = "Allow"
                  + Principal = {
                      + Service = "ssm.amazonaws.com"
                    }
                }
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ssm_role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy_attachment.ssm_attach will be created
  + resource "aws_iam_role_policy_attachment" "ssm_attach" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      + role       = "ssm_role"
    }

  # aws_instance.aws_ec2_a will be created
  + resource "aws_instance" "aws_ec2_a" {
      + ami                          = "ami-0c115dbd34c69a004"
      + arn                          = (known after apply)
      + associate_public_ip_address  = false
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "AWS-EC2-A"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.aws_ec2_b will be created
  + resource "aws_instance" "aws_ec2_b" {
      + ami                          = "ami-0c115dbd34c69a004"
      + arn                          = (known after apply)
      + associate_public_ip_address  = false
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "AWS-EC2-B"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.router[0] will be created
  + resource "aws_instance" "router" {
      + ami                          = "ami-0a072f8c9a7fccb6e"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t3.small"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "ONPREM-ROUTER1"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.router[1] will be created
  + resource "aws_instance" "router" {
      + ami                          = "ami-0a072f8c9a7fccb6e"
      + arn                          = (known after apply)
      + associate_public_ip_address  = (known after apply)
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t3.small"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "ONPREM-ROUTER2"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.server1 will be created
  + resource "aws_instance" "server1" {
      + ami                          = "ami-0c115dbd34c69a004"
      + arn                          = (known after apply)
      + associate_public_ip_address  = false
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "ONPREM-SERVER1"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_instance.server2 will be created
  + resource "aws_instance" "server2" {
      + ami                          = "ami-0c115dbd34c69a004"
      + arn                          = (known after apply)
      + associate_public_ip_address  = false
      + availability_zone            = (known after apply)
      + cpu_core_count               = (known after apply)
      + cpu_threads_per_core         = (known after apply)
      + get_password_data            = false
      + host_id                      = (known after apply)
      + iam_instance_profile         = "ec2_profile"
      + id                           = (known after apply)
      + instance_state               = (known after apply)
      + instance_type                = "t2.micro"
      + ipv6_address_count           = (known after apply)
      + ipv6_addresses               = (known after apply)
      + key_name                     = "my_pub_key"
      + outpost_arn                  = (known after apply)
      + password_data                = (known after apply)
      + placement_group              = (known after apply)
      + primary_network_interface_id = (known after apply)
      + private_dns                  = (known after apply)
      + private_ip                   = (known after apply)
      + public_dns                   = (known after apply)
      + public_ip                    = (known after apply)
      + secondary_private_ips        = (known after apply)
      + security_groups              = (known after apply)
      + source_dest_check            = true
      + subnet_id                    = (known after apply)
      + tags                         = {
          + "Name" = "ONPREM-SERVER2"
        }
      + tenancy                      = (known after apply)
      + volume_tags                  = (known after apply)
      + vpc_security_group_ids       = (known after apply)

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.igw_aws will be created
  + resource "aws_internet_gateway" "igw_aws" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "IGW-AWS"
        }
      + vpc_id   = (known after apply)
    }

  # aws_internet_gateway.igw_onprem will be created
  + resource "aws_internet_gateway" "igw_onprem" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "IGW-ONPREM"
        }
      + vpc_id   = (known after apply)
    }

  # aws_key_pair.my_pub_key will be created
  + resource "aws_key_pair" "my_pub_key" {
      + arn         = (known after apply)
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + key_name    = "my_pub_key"
      + key_pair_id = (known after apply)
      + public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg4LAIvXRk9TMr/FbBFRUQeA9GcUs3yC8GuUvUG+oYP+BjPlaj+LPotFXsqR0u1ihbozk1OrXXgpQb2A5YTTjZ5hVBsL7z6GR5LN1G3Nxk9SSt696lDSbchZ5SruhuSd9NX61jr0F4n0qDvpPC6ow3tKS9ve/G4g1/pWcLIXCI+S8qmMM3l11bscE67C+5FiAHpxgPd5YLt9qNrYxxRqcDDYpIdPwSu/2fwP0GWKJqO7u345nJdOnwE7HhV+HIfixAZ1c5ss+712T/5tZ5D/q1OAwLRiPzX0gBT6DmIWPpJRx1JocXDEwd5StP5W6wFRqnSg+XiyZMnJjeBqyBGqwj root@v22019078674692622"
    }

  # aws_route_table.aws-rt will be created
  + resource "aws_route_table" "aws-rt" {
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                = "0.0.0.0/0"
              + egress_only_gateway_id    = ""
              + gateway_id                = (known after apply)
              + instance_id               = ""
              + ipv6_cidr_block           = ""
              + nat_gateway_id            = ""
              + network_interface_id      = ""
              + transit_gateway_id        = ""
              + vpc_peering_connection_id = ""
            },
        ]
      + tags             = {
          + "Name" = "A4L-AWS-RT"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table.onprem-public-route-table will be created
  + resource "aws_route_table" "onprem-public-route-table" {
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                = "0.0.0.0/0"
              + egress_only_gateway_id    = ""
              + gateway_id                = (known after apply)
              + instance_id               = ""
              + ipv6_cidr_block           = ""
              + nat_gateway_id            = ""
              + network_interface_id      = ""
              + transit_gateway_id        = ""
              + vpc_peering_connection_id = ""
            },
        ]
      + tags             = {
          + "Name" = "main"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.aws-subnet-A will be created
  + resource "aws_route_table_association" "aws-subnet-A" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.aws-subnet-B will be created
  + resource "aws_route_table_association" "aws-subnet-B" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_route_table_association.onprem-public-subnet will be created
  + resource "aws_route_table_association" "onprem-public-subnet" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.aws-sg will be created
  + resource "aws_security_group" "aws-sg" {
      + arn                    = (known after apply)
      + description            = "AWS-Instance-SG"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Any from World"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = "AWS-Instance-SG"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "AWS-Instance-SG"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.onprem-sg will be created
  + resource "aws_security_group" "onprem-sg" {
      + arn                    = (known after apply)
      + description            = "ONPREM-Instance-SG"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Any from World"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = "ONPREM-Instance-SG"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "ONPREM-Instance-SG"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_ssm_activation.ssm_activation will be created
  + resource "aws_ssm_activation" "ssm_activation" {
      + activation_code    = (known after apply)
      + description        = "SSM Activation"
      + expiration_date    = (known after apply)
      + expired            = (known after apply)
      + iam_role           = (known after apply)
      + id                 = (known after apply)
      + name               = "ssm_activation"
      + registration_count = (known after apply)
      + registration_limit = 6
    }

  # aws_subnet.ONPREM-PRIVATE-1 will be created
  + resource "aws_subnet" "ONPREM-PRIVATE-1" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "192.168.10.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "ONPREM-PRIVATE-1"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.ONPREM-PRIVATE-2 will be created
  + resource "aws_subnet" "ONPREM-PRIVATE-2" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "192.168.11.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "ONPREM-PRIVATE-2"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.ONPREM-PUBLIC will be created
  + resource "aws_subnet" "ONPREM-PUBLIC" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1c"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "192.168.12.0/24"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "ONPREM-PUBLIC"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.sn-aws-private-A will be created
  + resource "aws_subnet" "sn-aws-private-A" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1a"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.16.32.0/20"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "sn-aws-private-A"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_subnet.sn-aws-private-B will be created
  + resource "aws_subnet" "sn-aws-private-B" {
      + arn                             = (known after apply)
      + assign_ipv6_address_on_creation = false
      + availability_zone               = "eu-central-1b"
      + availability_zone_id            = (known after apply)
      + cidr_block                      = "10.16.96.0/20"
      + id                              = (known after apply)
      + ipv6_cidr_block_association_id  = (known after apply)
      + map_public_ip_on_launch         = true
      + owner_id                        = (known after apply)
      + tags                            = {
          + "Name" = "sn-aws-private-B"
        }
      + vpc_id                          = (known after apply)
    }

  # aws_vpc.a4l_aws will be created
  + resource "aws_vpc" "a4l_aws" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "10.16.0.0/16"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "Name" = "A4L-AWS"
        }
    }

  # aws_vpc.onprem will be created
  + resource "aws_vpc" "onprem" {
      + arn                              = (known after apply)
      + assign_generated_ipv6_cidr_block = false
      + cidr_block                       = "192.168.8.0/21"
      + default_network_acl_id           = (known after apply)
      + default_route_table_id           = (known after apply)
      + default_security_group_id        = (known after apply)
      + dhcp_options_id                  = (known after apply)
      + enable_classiclink               = (known after apply)
      + enable_classiclink_dns_support   = (known after apply)
      + enable_dns_hostnames             = (known after apply)
      + enable_dns_support               = true
      + id                               = (known after apply)
      + instance_tenancy                 = "default"
      + ipv6_association_id              = (known after apply)
      + ipv6_cidr_block                  = (known after apply)
      + main_route_table_id              = (known after apply)
      + owner_id                         = (known after apply)
      + tags                             = {
          + "Name" = "ONPREM"
        }
    }

  # aws_vpn_connection.A4LTGW_R1 will be created
  + resource "aws_vpn_connection" "A4LTGW_R1" {
      + arn                            = (known after apply)
      + customer_gateway_configuration = (known after apply)
      + customer_gateway_id            = (known after apply)
      + id                             = (known after apply)
      + routes                         = (known after apply)
      + static_routes_only             = (known after apply)
      + tags                           = {
          + "Name" = "ONPREM-ROUTER1-VPN"
        }
      + transit_gateway_attachment_id  = (known after apply)
      + transit_gateway_id             = (known after apply)
      + tunnel1_address                = (known after apply)
      + tunnel1_bgp_asn                = (known after apply)
      + tunnel1_bgp_holdtime           = (known after apply)
      + tunnel1_cgw_inside_address     = (known after apply)
      + tunnel1_inside_cidr            = (known after apply)
      + tunnel1_preshared_key          = (sensitive value)
      + tunnel1_vgw_inside_address     = (known after apply)
      + tunnel2_address                = (known after apply)
      + tunnel2_bgp_asn                = (known after apply)
      + tunnel2_bgp_holdtime           = (known after apply)
      + tunnel2_cgw_inside_address     = (known after apply)
      + tunnel2_inside_cidr            = (known after apply)
      + tunnel2_preshared_key          = (sensitive value)
      + tunnel2_vgw_inside_address     = (known after apply)
      + type                           = "ipsec.1"
      + vgw_telemetry                  = (known after apply)
    }

  # aws_vpn_connection.A4LTGW_R2 will be created
  + resource "aws_vpn_connection" "A4LTGW_R2" {
      + arn                            = (known after apply)
      + customer_gateway_configuration = (known after apply)
      + customer_gateway_id            = (known after apply)
      + id                             = (known after apply)
      + routes                         = (known after apply)
      + static_routes_only             = (known after apply)
      + tags                           = {
          + "Name" = "ONPREM-ROUTER2-VPN"
        }
      + transit_gateway_attachment_id  = (known after apply)
      + transit_gateway_id             = (known after apply)
      + tunnel1_address                = (known after apply)
      + tunnel1_bgp_asn                = (known after apply)
      + tunnel1_bgp_holdtime           = (known after apply)
      + tunnel1_cgw_inside_address     = (known after apply)
      + tunnel1_inside_cidr            = (known after apply)
      + tunnel1_preshared_key          = (sensitive value)
      + tunnel1_vgw_inside_address     = (known after apply)
      + tunnel2_address                = (known after apply)
      + tunnel2_bgp_asn                = (known after apply)
      + tunnel2_bgp_holdtime           = (known after apply)
      + tunnel2_cgw_inside_address     = (known after apply)
      + tunnel2_inside_cidr            = (known after apply)
      + tunnel2_preshared_key          = (sensitive value)
      + tunnel2_vgw_inside_address     = (known after apply)
      + type                           = "ipsec.1"
      + vgw_telemetry                  = (known after apply)
    }

Plan: 35 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + router1_private_ip         = (known after apply)
  + router1_public_ip          = (known after apply)
  + router2_private_ip         = (known after apply)
  + router2_public_ip          = (known after apply)
  + tunnel1_address            = (known after apply)
  + tunnel1_cgw_inside_address = (known after apply)
  + tunnel1_preshared_key      = (known after apply)
  + tunnel1_vgw_inside_address = (known after apply)
  + tunnel2_address            = (known after apply)
  + tunnel2_cgw_inside_address = (known after apply)
  + tunnel2_preshared_key      = (known after apply)
  + tunnel2_vgw_inside_address = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

data.aws_availability_zones.available: Reading... [id=2020-08-28 08:21:47.323722663 +0000 UTC]
data.aws_availability_zones.available: Read complete after 0s [id=2020-08-28 08:21:49.489938925 +0000 UTC]
aws_ec2_transit_gateway.tgw: Creating...
aws_vpc.a4l_aws: Creating...
aws_iam_role.ssm_role: Creating...
aws_key_pair.my_pub_key: Creating...
aws_vpc.onprem: Creating...
aws_key_pair.my_pub_key: Creation complete after 0s [id=my_pub_key]
aws_vpc.a4l_aws: Creation complete after 1s [id=vpc-0b7d3e69e0bab2f20]
aws_vpc.onprem: Creation complete after 1s [id=vpc-0d81b51ac53491bf4]
aws_security_group.aws-sg: Creating...
aws_internet_gateway.igw_aws: Creating...
aws_subnet.sn-aws-private-B: Creating...
aws_subnet.sn-aws-private-A: Creating...
aws_internet_gateway.igw_onprem: Creating...
aws_subnet.ONPREM-PRIVATE-2: Creating...
aws_security_group.onprem-sg: Creating...
aws_subnet.ONPREM-PRIVATE-1: Creating...
aws_iam_role.ssm_role: Creation complete after 1s [id=ssm_role]
aws_subnet.ONPREM-PUBLIC: Creating...
aws_internet_gateway.igw_aws: Creation complete after 0s [id=igw-01f60298cc4cfff24]
aws_iam_role_policy_attachment.ssm_attach: Creating...
aws_internet_gateway.igw_onprem: Creation complete after 0s [id=igw-0392f6311c7746cab]
aws_iam_instance_profile.ec2_profile: Creating...
aws_subnet.sn-aws-private-A: Creation complete after 0s [id=subnet-07e45f9634a87e883]
aws_route_table.onprem-public-route-table: Creating...
aws_subnet.sn-aws-private-B: Creation complete after 0s [id=subnet-018bc3004dc0fa208]
aws_subnet.ONPREM-PUBLIC: Creation complete after 0s [id=subnet-03723dc752b069bc2]
aws_subnet.ONPREM-PRIVATE-2: Creation complete after 1s [id=subnet-05b63413c2e541e1d]
aws_subnet.ONPREM-PRIVATE-1: Creation complete after 1s [id=subnet-09ab77f87355312de]
aws_route_table.onprem-public-route-table: Creation complete after 1s [id=rtb-0ed790f1a0df4a576]
aws_route_table_association.onprem-public-subnet: Creating...
aws_route_table_association.onprem-public-subnet: Creation complete after 0s [id=rtbassoc-0a1cfb4a26fdaf33c]
aws_security_group.onprem-sg: Creation complete after 1s [id=sg-0fa8657593c7a57bb]
aws_security_group.aws-sg: Creation complete after 1s [id=sg-01611f4819c87d27e]
aws_iam_role_policy_attachment.ssm_attach: Creation complete after 1s [id=ssm_role-20200828082156704400000001]
aws_ssm_activation.ssm_activation: Creating...
aws_iam_instance_profile.ec2_profile: Creation complete after 2s [id=ec2_profile]
aws_instance.router[0]: Creating...
aws_instance.aws_ec2_b: Creating...
aws_instance.server1: Creating...
aws_instance.server2: Creating...
aws_instance.router[1]: Creating...
aws_instance.aws_ec2_a: Creating...
aws_ec2_transit_gateway.tgw: Still creating... [10s elapsed]
aws_ssm_activation.ssm_activation: Creation complete after 8s [id=5484976f-8b8d-4278-9aef-54d7c5a61b87]
aws_instance.router[0]: Still creating... [10s elapsed]
aws_instance.aws_ec2_b: Still creating... [10s elapsed]
aws_instance.server1: Still creating... [10s elapsed]
aws_instance.router[1]: Still creating... [10s elapsed]
aws_instance.server2: Still creating... [10s elapsed]
aws_instance.aws_ec2_a: Still creating... [10s elapsed]
aws_ec2_transit_gateway.tgw: Still creating... [20s elapsed]
aws_instance.router[1]: Provisioning with 'remote-exec'...
aws_instance.router[1] (remote-exec): Connecting to remote host via SSH...
aws_instance.router[1] (remote-exec):   Host: 3.123.227.33
aws_instance.router[1] (remote-exec):   User: ubuntu
aws_instance.router[1] (remote-exec):   Password: false
aws_instance.router[1] (remote-exec):   Private key: true
aws_instance.router[1] (remote-exec):   Certificate: false
aws_instance.router[1] (remote-exec):   SSH Agent: false
aws_instance.router[1] (remote-exec):   Checking Host Key: false
aws_instance.router[0]: Still creating... [20s elapsed]
aws_instance.aws_ec2_b: Still creating... [20s elapsed]
aws_instance.server1: Still creating... [20s elapsed]
aws_instance.router[1]: Still creating... [20s elapsed]
aws_instance.server2: Still creating... [20s elapsed]
aws_instance.aws_ec2_a: Still creating... [20s elapsed]
aws_instance.router[0]: Provisioning with 'remote-exec'...
aws_instance.router[0] (remote-exec): Connecting to remote host via SSH...
aws_instance.router[0] (remote-exec):   Host: 18.159.248.21
aws_instance.router[0] (remote-exec):   User: ubuntu
aws_instance.router[0] (remote-exec):   Password: false
aws_instance.router[0] (remote-exec):   Private key: true
aws_instance.router[0] (remote-exec):   Certificate: false
aws_instance.router[0] (remote-exec):   SSH Agent: false
aws_instance.router[0] (remote-exec):   Checking Host Key: false
aws_ec2_transit_gateway.tgw: Still creating... [30s elapsed]
aws_instance.server1: Creation complete after 28s [id=i-01e2998963e1044eb]
aws_instance.router[0]: Still creating... [30s elapsed]
aws_instance.aws_ec2_b: Still creating... [30s elapsed]
aws_instance.server2: Still creating... [30s elapsed]
aws_instance.router[1]: Still creating... [30s elapsed]
aws_instance.aws_ec2_a: Still creating... [30s elapsed]
aws_instance.aws_ec2_b: Creation complete after 31s [id=i-0efa5b07f0a382ba9]
aws_instance.aws_ec2_a: Creation complete after 32s [id=i-09cffa5f2a53d6cee]
aws_instance.router[1] (remote-exec): Connecting to remote host via SSH...
aws_instance.router[1] (remote-exec):   Host: 3.123.227.33
aws_instance.router[1] (remote-exec):   User: ubuntu
aws_instance.router[1] (remote-exec):   Password: false
aws_instance.router[1] (remote-exec):   Private key: true
aws_instance.router[1] (remote-exec):   Certificate: false
aws_instance.router[1] (remote-exec):   SSH Agent: false
aws_instance.router[1] (remote-exec):   Checking Host Key: false
aws_instance.router[1] (remote-exec): Connected!
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [Working]
aws_instance.router[1] (remote-exec): Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [Connecting to security.ubuntu.com (
aws_instance.router[1] (remote-exec): Get:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease [111 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [2 InRelease 15.6 kB/111 kB 14%] [Co
aws_instance.router[1] (remote-exec): 0% [Waiting for headers] [Waiting for h
aws_instance.router[1] (remote-exec): Get:3 http://archive.ubuntu.com/ubuntu focal-backports InRelease [98.3 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [3 InRelease 56.4 kB/98.3 kB 57%] [W
aws_instance.router[1] (remote-exec): 0% [Waiting for headers]
aws_instance.router[1] (remote-exec): Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [107 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [4 InRelease 2585 B/107 kB 2%]
aws_instance.router[1] (remote-exec): 0% [4 InRelease 5481 B/107 kB 5%]
aws_instance.router[1] (remote-exec): Get:5 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [8628 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [5 Packages 56.5 kB/8628 kB 1%] [4 I
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [5 Packages 498 kB/8628 kB 6%] [4 In
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [5 Packages 1414 kB/8628 kB 16%]
aws_instance.router[1] (remote-exec): 0% [5 Packages 1730 kB/8628 kB 20%]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 30% [5 Packages 3096 kB/8628 kB 36%]
aws_instance.router[1] (remote-exec): Get:6 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [163 kB]
aws_ec2_transit_gateway.tgw: Still creating... [40s elapsed]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 39% [5 Packages 4842 kB/8628 kB 56%] [6
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 59% [6 Packages 159 kB/163 kB 97%]
aws_instance.router[1] (remote-exec): 59% [5 Packages store 0 B] [Waiting for
aws_instance.router[1] (remote-exec): 59% [5 Packages store 0 B] [Waiting for
aws_instance.router[1] (remote-exec): Get:7 http://archive.ubuntu.com/ubuntu focal/universe Translation-en [5124 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 60% [5 Packages store 0 B] [7 Translati
aws_instance.router[1] (remote-exec): Get:8 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [60.1 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 77% [5 Packages store 0 B] [7 Translati
aws_instance.router[1] (remote-exec): 86% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:9 http://archive.ubuntu.com/ubuntu focal/universe amd64 c-n-f Metadata [265 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 86% [5 Packages store 0 B] [9 Commands-
aws_instance.router[1] (remote-exec): 87% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:10 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [144 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 87% [5 Packages store 0 B] [10 Packages
aws_instance.router[1] (remote-exec): 88% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:11 http://archive.ubuntu.com/ubuntu focal/multiverse Translation-en [104 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 88% [5 Packages store 0 B] [11 Translat
aws_instance.router[1] (remote-exec): 89% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:12 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 c-n-f Metadata [9136 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 89% [5 Packages store 0 B] [12 Commands
aws_instance.router[1] (remote-exec): 89% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:13 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [332 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 89% [5 Packages store 0 B] [13 Packages
aws_instance.router[1] (remote-exec): 90% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:14 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [127 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 90% [5 Packages store 0 B] [14 Translat
aws_instance.router[1] (remote-exec): 91% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 c-n-f Metadata [8780 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 91% [5 Packages store 0 B] [15 Commands
aws_instance.router[1] (remote-exec): 91% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:16 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [163 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 91% [5 Packages store 0 B] [16 Packages
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [8 Translati
aws_instance.router[1] (remote-exec): Get:17 http://security.ubuntu.com/ubuntu focal-security/main amd64 c-n-f Metadata [4432 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [17 Commands
aws_instance.router[1] (remote-exec): Get:18 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [81.7 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [18 Translat
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [17 Commands
aws_instance.router[1] (remote-exec): Get:19 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 c-n-f Metadata [5404 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [19 Commands
aws_instance.router[1] (remote-exec): Get:20 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [55.1 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [19 Commands
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:21 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [11.6 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [21 Packages
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:22 http://archive.ubuntu.com/ubuntu focal-updates/multiverse Translation-en [3892 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [22 Translat
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:23 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 c-n-f Metadata [480 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [23 Commands
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:24 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 c-n-f Metadata [112 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [24 Commands
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:25 http://archive.ubuntu.com/ubuntu focal-backports/restricted amd64 c-n-f Metadata [116 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [25 Commands
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:26 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [3092 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 92% [5 Packages store 0 B] [26 Packages
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:27 http://archive.ubuntu.com/ubuntu focal-backports/universe Translation-en [1448 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [27 Translat
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:28 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 c-n-f Metadata [224 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [28 Commands
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:29 http://archive.ubuntu.com/ubuntu focal-backports/multiverse amd64 c-n-f Metadata [116 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [29 Commands
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [20 Packages
aws_instance.router[1] (remote-exec): Get:30 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [28.4 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [30 Translat
aws_instance.router[1] (remote-exec): Get:31 http://security.ubuntu.com/ubuntu focal-security/universe amd64 c-n-f Metadata [2212 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [31 Commands
aws_instance.router[1] (remote-exec): Get:32 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [1172 B]
aws_instance.router[1] (remote-exec): Get:33 http://security.ubuntu.com/ubuntu focal-security/multiverse Translation-en [540 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B] [Waiting for
aws_instance.router[1] (remote-exec): Get:34 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 c-n-f Metadata [116 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [Working]
aws_instance.router[1] (remote-exec): 93% [6 Packages store 0 B]
aws_instance.router[1] (remote-exec): 93% [Working]
aws_instance.router[1] (remote-exec): 93% [7 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): Connecting to remote host via SSH...
aws_instance.router[0] (remote-exec):   Host: 18.159.248.21
aws_instance.router[0] (remote-exec):   User: ubuntu
aws_instance.router[0] (remote-exec):   Password: false
aws_instance.router[0] (remote-exec):   Private key: true
aws_instance.router[0] (remote-exec):   Certificate: false
aws_instance.router[0] (remote-exec):   SSH Agent: false
aws_instance.router[0] (remote-exec):   Checking Host Key: false
aws_instance.router[0]: Still creating... [40s elapsed]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 93% [7 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): Connected!
aws_instance.router[1]: Still creating... [40s elapsed]
aws_instance.server2: Still creating... [40s elapsed]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 94% [Working]
aws_instance.router[1] (remote-exec): 94% [9 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 94% [Working]
aws_instance.router[1] (remote-exec): 94% [10 Packages store 0 B]
aws_instance.router[1] (remote-exec): 94% [Working]
aws_instance.router[1] (remote-exec): 94% [11 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 94% [Working]
aws_instance.router[1] (remote-exec): 94% [12 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): 95% [13 Packages store 0 B]
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): 95% [14 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): 95% [15 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): 95% [16 Packages store 0 B]
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): 95% [8 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 96% [Working]
aws_instance.router[1] (remote-exec): 96% [18 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 96% [Working]
aws_instance.router[1] (remote-exec): 96% [17 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 96% [Working]
aws_instance.router[1] (remote-exec): 96% [19 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 96% [Working]
aws_instance.router[1] (remote-exec): 96% [21 Packages store 0 B]
aws_instance.router[1] (remote-exec): 97% [Working]
aws_instance.router[1] (remote-exec): 97% [22 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 97% [Working]
aws_instance.router[1] (remote-exec): 97% [23 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 97% [Working]
aws_instance.router[1] (remote-exec): 97% [24 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 97% [Working]
aws_instance.router[1] (remote-exec): 97% [25 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 98% [Working]
aws_instance.router[1] (remote-exec): 98% [26 Packages store 0 B]
aws_instance.router[1] (remote-exec): 98% [Working]
aws_instance.router[1] (remote-exec): 98% [27 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 98% [Working]
aws_instance.router[1] (remote-exec): 98% [28 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 98% [Working]
aws_instance.router[1] (remote-exec): 98% [29 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 99% [Working]
aws_instance.router[1] (remote-exec): 99% [20 Packages store 0 B]
aws_instance.router[1] (remote-exec): 99% [Working]
aws_instance.router[1] (remote-exec): 99% [30 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 99% [Working]
aws_instance.router[1] (remote-exec): 99% [31 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 99% [Working]
aws_instance.router[1] (remote-exec): 99% [32 Packages store 0 B]
aws_instance.router[1] (remote-exec): 100% [Working]
aws_instance.router[1] (remote-exec): 100% [33 Translation-en store 0 B]
aws_instance.router[1] (remote-exec): 100% [Working]
aws_instance.router[1] (remote-exec): 100% [34 Commands-amd64 store 0 B]
aws_instance.router[1] (remote-exec): 100% [Working]
aws_instance.router[1] (remote-exec): Fetched 15.6 MB in 4s (3857 kB/s)
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [Working]
aws_instance.router[0] (remote-exec): Hit:1 http://archive.ubuntu.com/ubuntu focal InRelease
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [Waiting for headers]
aws_instance.router[0] (remote-exec): Get:2 http://archive.ubuntu.com/ubuntu focal-updates InRelease [111 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [2 InRelease 15.6 kB/111 kB 14%] [Wa
aws_instance.router[0] (remote-exec): Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [107 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [2 InRelease 89.5 kB/111 kB 80%] [3
aws_instance.router[0] (remote-exec): 0% [Waiting for headers] [3 InRelease 5
aws_instance.router[0] (remote-exec): Get:4 http://archive.ubuntu.com/ubuntu focal-backports InRelease [98.3 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [4 InRelease 18.8 kB/98.3 kB 19%] [3
aws_instance.router[0] (remote-exec): 0% [3 InRelease 14.2 kB/107 kB 13%]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [3 InRelease 41.7 kB/107 kB 39%]
aws_instance.router[0] (remote-exec): Get:5 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [8628 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages 49.2 kB/8628 kB 1%] [3 I
aws_instance.router[0] (remote-exec): 0% [5 Packages 1008 kB/8628 kB 12%] [3
aws_instance.router[0] (remote-exec): 0% [5 Packages 1038 kB/8628 kB 12%]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [Working]
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [Waiting for
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [Waiting for
aws_instance.router[0] (remote-exec): Get:6 http://archive.ubuntu.com/ubuntu focal/universe Translation-en [5124 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [6 Translatio
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:7 http://archive.ubuntu.com/ubuntu focal/universe amd64 c-n-f Metadata [265 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [7 Commands-a
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:8 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [144 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [8 Packages 5
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse Translation-en [104 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [9 Translatio
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:10 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 c-n-f Metadata [9136 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [10 Commands-
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:11 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [332 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [11 Packages
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:12 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [127 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [12 Translati
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:13 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 c-n-f Metadata [8780 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [13 Commands-
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:14 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [163 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [14 Packages
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:15 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [81.7 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [15 Translati
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:16 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 c-n-f Metadata [5404 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [16 Commands-
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:17 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [11.6 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [17 Packages
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:18 http://archive.ubuntu.com/ubuntu focal-updates/multiverse Translation-en [3892 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [18 Translati
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:19 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 c-n-f Metadata [480 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [19 Commands-
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:20 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 c-n-f Metadata [112 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [20 Commands-
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B] [Waiting for
aws_instance.router[0] (remote-exec): Get:21 http://archive.ubuntu.com/ubuntu focal-backports/restricted amd64 c-n-f Metadata [116 B]
aws_instance.router[0] (remote-exec): Get:22 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [3092 B]
aws_instance.router[0] (remote-exec): Get:23 http://archive.ubuntu.com/ubuntu focal-backports/universe Translation-en [1448 B]
aws_instance.router[0] (remote-exec): Get:24 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 c-n-f Metadata [224 B]
aws_instance.router[0] (remote-exec): Get:25 http://archive.ubuntu.com/ubuntu focal-backports/multiverse amd64 c-n-f Metadata [116 B]
aws_instance.server2: Creation complete after 42s [id=i-0fda70670b6ea865d]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): 91% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:26 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [163 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 91% [5 Packages store 0 B] [26 Packages
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 92% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec): Get:27 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [60.1 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 92% [5 Packages store 0 B] [27 Translat
aws_instance.router[0] (remote-exec): Get:28 http://security.ubuntu.com/ubuntu focal-security/main amd64 c-n-f Metadata [4432 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 92% [5 Packages store 0 B] [28 Commands
aws_instance.router[0] (remote-exec): Get:29 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [55.1 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 92% [5 Packages store 0 B] [29 Packages
aws_instance.router[0] (remote-exec): Get:30 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [28.4 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [5 Packages store 0 B] [30 Translat
aws_instance.router[0] (remote-exec): Get:31 http://security.ubuntu.com/ubuntu focal-security/universe amd64 c-n-f Metadata [2212 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [5 Packages store 0 B] [31 Commands
aws_instance.router[0] (remote-exec): Get:32 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [1172 B]
aws_instance.router[0] (remote-exec): Get:33 http://security.ubuntu.com/ubuntu focal-security/multiverse Translation-en [540 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [5 Packages store 0 B] [Waiting for
aws_instance.router[0] (remote-exec): Get:34 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 c-n-f Metadata [116 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [5 Packages store 0 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [Working]
aws_instance.router[0] (remote-exec): 93% [6 Translation-en store 0 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [6 Translation-en store 0 B]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 93% [Working]
aws_instance.router[0] (remote-exec): 93% [7 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 94% [Working]
aws_instance.router[0] (remote-exec): 94% [8 Packages store 0 B]
aws_instance.router[0] (remote-exec): 94% [Working]
aws_instance.router[0] (remote-exec): 94% [9 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 94% [Working]
aws_instance.router[0] (remote-exec): 94% [10 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 94% [Working]
aws_instance.router[0] (remote-exec): 94% [11 Packages store 0 B]
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): 95% [12 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): 95% [13 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): 95% [14 Packages store 0 B]
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): 95% [15 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): 95% [16 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 96% [Working]
aws_instance.router[0] (remote-exec): 96% [17 Packages store 0 B]
aws_instance.router[0] (remote-exec): 96% [Working]
aws_instance.router[0] (remote-exec): 96% [18 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 96% [Working]
aws_instance.router[0] (remote-exec): 96% [19 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 96% [Working]
aws_instance.router[0] (remote-exec): 96% [20 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 97% [Working]
aws_instance.router[0] (remote-exec): 97% [21 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 97% [Working]
aws_instance.router[0] (remote-exec): 97% [22 Packages store 0 B]
aws_instance.router[0] (remote-exec): 97% [Working]
aws_instance.router[0] (remote-exec): 97% [23 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 97% [Working]
aws_instance.router[0] (remote-exec): 97% [24 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 98% [Working]
aws_instance.router[0] (remote-exec): 98% [25 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 98% [Working]
aws_instance.router[0] (remote-exec): 98% [26 Packages store 0 B]
aws_instance.router[0] (remote-exec): 98% [Working]
aws_instance.router[0] (remote-exec): 98% [27 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 98% [Working]
aws_instance.router[0] (remote-exec): 98% [28 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 99% [Working]
aws_instance.router[0] (remote-exec): 99% [29 Packages store 0 B]
aws_instance.router[0] (remote-exec): 99% [Working]
aws_instance.router[0] (remote-exec): 99% [30 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 99% [Working]
aws_instance.router[0] (remote-exec): 99% [31 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 99% [Working]
aws_instance.router[0] (remote-exec): 99% [32 Packages store 0 B]
aws_instance.router[0] (remote-exec): 100% [Working]
aws_instance.router[0] (remote-exec): 100% [33 Translation-en store 0 B]
aws_instance.router[0] (remote-exec): 100% [Working]
aws_instance.router[0] (remote-exec): 100% [34 Commands-amd64 store 0 B]
aws_instance.router[0] (remote-exec): 100% [Working]
aws_instance.router[0] (remote-exec): Fetched 15.6 MB in 3s (4596 kB/s)
aws_instance.router[1] (remote-exec): Reading package lists... 0%
aws_instance.router[1] (remote-exec): Reading package lists... 0%
aws_instance.router[1] (remote-exec): Reading package lists... 0%
aws_instance.router[1] (remote-exec): Reading package lists... 6%
aws_instance.router[1] (remote-exec): Reading package lists... 6%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 9%
aws_instance.router[1] (remote-exec): Reading package lists... 61%
aws_instance.router[1] (remote-exec): Reading package lists... 62%
aws_instance.router[1] (remote-exec): Reading package lists... 62%
aws_instance.router[1] (remote-exec): Reading package lists... 90%
aws_instance.router[1] (remote-exec): Reading package lists... 90%
aws_instance.router[1] (remote-exec): Reading package lists... 90%
aws_instance.router[1] (remote-exec): Reading package lists... 90%
aws_instance.router[1] (remote-exec): Reading package lists... 91%
aws_instance.router[1] (remote-exec): Reading package lists... 91%
aws_instance.router[1] (remote-exec): Reading package lists... 93%
aws_instance.router[1] (remote-exec): Reading package lists... 93%
aws_instance.router[1] (remote-exec): Reading package lists... 94%
aws_instance.router[1] (remote-exec): Reading package lists... 94%
aws_instance.router[1] (remote-exec): Reading package lists... 95%
aws_instance.router[1] (remote-exec): Reading package lists... 95%
aws_instance.router[1] (remote-exec): Reading package lists... 95%
aws_instance.router[1] (remote-exec): Reading package lists... 95%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 96%
aws_instance.router[1] (remote-exec): Reading package lists... 97%
aws_instance.router[1] (remote-exec): Reading package lists... 97%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 98%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... 99%
aws_instance.router[1] (remote-exec): Reading package lists... Done
aws_instance.router[1] (remote-exec): Building dependency tree... 0%
aws_instance.router[1] (remote-exec): Building dependency tree... 0%
aws_instance.router[1] (remote-exec): Building dependency tree... 0%
aws_instance.router[1] (remote-exec): Building dependency tree... 50%
aws_instance.router[1] (remote-exec): Building dependency tree... 50%
aws_instance.router[1] (remote-exec): Building dependency tree
aws_instance.router[1] (remote-exec): Reading state information... 0%
aws_instance.router[1] (remote-exec): Reading state information... 0%
aws_instance.router[1] (remote-exec): Reading state information... Done
aws_instance.router[1] (remote-exec): 16 packages can be upgraded. Run 'apt list --upgradable' to see them.
aws_instance.router[1] (remote-exec): Reading package lists... 0%
aws_instance.router[1] (remote-exec): Reading package lists... 100%
aws_instance.router[1] (remote-exec): Reading package lists... Done
aws_instance.router[1] (remote-exec): Building dependency tree... 0%
aws_instance.router[1] (remote-exec): Building dependency tree... 0%
aws_instance.router[1] (remote-exec): Building dependency tree... 50%
aws_instance.router[1] (remote-exec): Building dependency tree... 50%
aws_instance.router[1] (remote-exec): Building dependency tree
aws_instance.router[1] (remote-exec): Reading state information... 0%
aws_instance.router[1] (remote-exec): Reading state information... 0%
aws_instance.router[1] (remote-exec): Reading state information... Done
aws_instance.router[1] (remote-exec): wget is already the newest version (1.20.3-1ubuntu1).
aws_instance.router[1] (remote-exec): wget set to manually installed.
aws_ec2_transit_gateway.tgw: Still creating... [50s elapsed]
aws_instance.router[1] (remote-exec): The following additional packages will be installed:
aws_instance.router[1] (remote-exec):   libcharon-extauth-plugins
aws_instance.router[1] (remote-exec):   libstrongswan
aws_instance.router[1] (remote-exec):   libstrongswan-standard-plugins
aws_instance.router[1] (remote-exec):   strongswan-charon
aws_instance.router[1] (remote-exec):   strongswan-libcharon
aws_instance.router[1] (remote-exec):   strongswan-starter
aws_instance.router[1] (remote-exec): Suggested packages:
aws_instance.router[1] (remote-exec):   libstrongswan-extra-plugins
aws_instance.router[1] (remote-exec):   libcharon-extra-plugins
aws_instance.router[1] (remote-exec): The following NEW packages will be installed:
aws_instance.router[1] (remote-exec):   libcharon-extauth-plugins
aws_instance.router[1] (remote-exec):   libstrongswan
aws_instance.router[1] (remote-exec):   libstrongswan-standard-plugins
aws_instance.router[1] (remote-exec):   strongswan strongswan-charon
aws_instance.router[1] (remote-exec):   strongswan-libcharon
aws_instance.router[1] (remote-exec):   strongswan-starter
aws_instance.router[1] (remote-exec): 0 upgraded, 7 newly installed, 0 to remove and 16 not upgraded.
aws_instance.router[1] (remote-exec): Need to get 876 kB of archives.
aws_instance.router[1] (remote-exec): After this operation, 4163 kB of additional disk space will be used.
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [Working]
aws_instance.router[1] (remote-exec): Get:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libstrongswan amd64 5.8.2-1ubuntu3.1 [357 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 0% [1 libstrongswan 0 B/357 kB 0%]
aws_instance.router[1] (remote-exec): 35% [Working]
aws_instance.router[1] (remote-exec): Get:2 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-libcharon amd64 5.8.2-1ubuntu3.1 [241 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 35% [2 strongswan-libcharon 0 B/241 kB
aws_instance.router[1] (remote-exec): 60% [Working]
aws_instance.router[1] (remote-exec): Get:3 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-charon amd64 5.8.2-1ubuntu3.1 [22.2 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 60% [3 strongswan-charon 0 B/22.2 kB 0%
aws_instance.router[1] (remote-exec): 65% [Working]
aws_instance.router[1] (remote-exec): Get:4 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-starter amd64 5.8.2-1ubuntu3.1 [148 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 65% [4 strongswan-starter 0 B/148 kB 0%
aws_instance.router[1] (remote-exec): 81% [Working]
aws_instance.router[1] (remote-exec): Get:5 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libcharon-extauth-plugins amd64 5.8.2-1ubuntu3.1 [23.0 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 81% [5 libcharon-extauth-plugins 0 B/23
aws_instance.router[1] (remote-exec): 86% [Working]
aws_instance.router[1] (remote-exec): Get:6 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libstrongswan-standard-plugins amd64 5.8.2-1ubuntu3.1 [67.6 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 86% [6 libstrongswan-standard-plugins 0
aws_instance.router[1] (remote-exec): 95% [Working]
aws_instance.router[1] (remote-exec): Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan all 5.8.2-1ubuntu3.1 [18.2 kB]
aws_instance.router[1] (remote-exec):
aws_instance.router[1] (remote-exec): 95% [7 strongswan 0 B/18.2 kB 0%]
aws_instance.router[1] (remote-exec): 100% [Working]
aws_instance.router[1] (remote-exec): Fetched 876 kB in 0s (5291 kB/s)
aws_instance.router[1] (remote-exec): Preconfiguring packages ...
                                      Selecting previously unselected package libstrongswan.
aws_instance.router[1] (remote-exec): (Reading database ...
aws_instance.router[1] (remote-exec): (Reading database ... 5%
aws_instance.router[1] (remote-exec): (Reading database ... 10%
aws_instance.router[1] (remote-exec): (Reading database ... 15%
aws_instance.router[1] (remote-exec): (Reading database ... 20%
aws_instance.router[1] (remote-exec): (Reading database ... 25%
aws_instance.router[1] (remote-exec): (Reading database ... 30%
aws_instance.router[1] (remote-exec): (Reading database ... 35%
aws_instance.router[1] (remote-exec): (Reading database ... 40%
aws_instance.router[1] (remote-exec): (Reading database ... 45%
aws_instance.router[1] (remote-exec): (Reading database ... 50%
aws_instance.router[1] (remote-exec): (Reading database ... 55%
aws_instance.router[1] (remote-exec): (Reading database ... 60%
aws_instance.router[1] (remote-exec): (Reading database ... 65%
aws_instance.router[1] (remote-exec): (Reading database ... 70%
aws_instance.router[1] (remote-exec): (Reading database ... 75%
aws_instance.router[1] (remote-exec): (Reading database ... 80%
aws_instance.router[1] (remote-exec): (Reading database ... 85%
aws_instance.router[1] (remote-exec): (Reading database ... 90%
aws_instance.router[1] (remote-exec): (Reading database ... 95%
aws_instance.router[1] (remote-exec): (Reading database ... 100%
aws_instance.router[1] (remote-exec): (Reading database ... 59625 files and directories currently installed.)
aws_instance.router[1] (remote-exec): Preparing to unpack .../0-libstrongswan_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [  3%] [..................] Unpacking libstrongswan (5.8.2-1ubuntu3.1) ...
Progress: [  7%] [#.................] Selecting previously unselected package strongswan-libcharon.
aws_instance.router[1] (remote-exec): Preparing to unpack .../1-strongswan-libcharon_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 10%] [#.................] Unpacking strongswan-libcharon (5.8.2-1ubuntu3.1) ...
Progress: [ 14%] [##................] Selecting previously unselected package strongswan-charon.
aws_instance.router[1] (remote-exec): Preparing to unpack .../2-strongswan-charon_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 17%] [###...............] Unpacking strongswan-charon (5.8.2-1ubuntu3.1) ...
Progress: [ 21%] [###...............] Selecting previously unselected package strongswan-starter.
aws_instance.router[1] (remote-exec): Preparing to unpack .../3-strongswan-starter_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 24%] [####..............] Unpacking strongswan-starter (5.8.2-1ubuntu3.1) ...
aws_instance.router[0]: Still creating... [50s elapsed]
Progress: [ 28%] [####..............] Selecting previously unselected package libcharon-extauth-plugins.
aws_instance.router[1] (remote-exec): Preparing to unpack .../4-libcharon-extauth-plugins_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 31%] [#####.............] Unpacking libcharon-extauth-plugins (5.8.2-1ubuntu3.1) ...
aws_instance.router[1]: Still creating... [50s elapsed]
Progress: [ 34%] [######............] Selecting previously unselected package libstrongswan-standard-plugins.
aws_instance.router[1] (remote-exec): Preparing to unpack .../5-libstrongswan-standard-plugins_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 38%] [######............] Unpacking libstrongswan-standard-plugins (5.8.2-1ubuntu3.1) ...
Progress: [ 41%] [#######...........] Selecting previously unselected package strongswan.
aws_instance.router[1] (remote-exec): Preparing to unpack .../6-strongswan_5.8.2-1ubuntu3.1_all.deb ...
Progress: [ 45%] [########..........] Unpacking strongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 48%] [########..........] Setting up libstrongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 55%] [#########.........] Setting up strongswan-libcharon (5.8.2-1ubuntu3.1) ...
Progress: [ 62%] [###########.......] Setting up libcharon-extauth-plugins (5.8.2-1ubuntu3.1) ...
Progress: [ 69%] [############......] Setting up strongswan-charon (5.8.2-1ubuntu3.1) ...
Progress: [ 72%] [#############.....]
Progress: [ 76%] [#############.....] Setting up libstrongswan-standard-plugins (5.8.2-1ubuntu3.1) ...
Progress: [ 83%] [##############....] Setting up strongswan-starter (5.8.2-1ubuntu3.1) ...
aws_instance.router[0] (remote-exec): Reading package lists... 0%
aws_instance.router[0] (remote-exec): Reading package lists... 0%
aws_instance.router[0] (remote-exec): Reading package lists... 0%
aws_instance.router[0] (remote-exec): Reading package lists... 6%
aws_instance.router[0] (remote-exec): Reading package lists... 6%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
aws_instance.router[0] (remote-exec): Reading package lists... 9%
Progress: [ 86%] [###############...]
aws_instance.router[0] (remote-exec): Reading package lists... 62%
aws_instance.router[0] (remote-exec): Reading package lists... 62%
aws_instance.router[0] (remote-exec): Reading package lists... 66%
aws_instance.router[0] (remote-exec): Reading package lists... 90%
aws_instance.router[0] (remote-exec): Reading package lists... 90%
aws_instance.router[0] (remote-exec): Reading package lists... 90%
aws_instance.router[0] (remote-exec): Reading package lists... 90%
aws_instance.router[0] (remote-exec): Reading package lists... 91%
aws_instance.router[0] (remote-exec): Reading package lists... 91%
aws_instance.router[0] (remote-exec): Reading package lists... 93%
aws_instance.router[0] (remote-exec): Reading package lists... 93%
aws_instance.router[0] (remote-exec): Reading package lists... 94%
aws_instance.router[0] (remote-exec): Reading package lists... 94%
aws_instance.router[0] (remote-exec): Reading package lists... 95%
aws_instance.router[0] (remote-exec): Reading package lists... 95%
aws_instance.router[0] (remote-exec): Reading package lists... 95%
aws_instance.router[0] (remote-exec): Reading package lists... 95%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 96%
aws_instance.router[0] (remote-exec): Reading package lists... 97%
aws_instance.router[0] (remote-exec): Reading package lists... 97%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 98%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... 99%
aws_instance.router[0] (remote-exec): Reading package lists... Done
aws_instance.router[0] (remote-exec): Building dependency tree... 0%
aws_instance.router[0] (remote-exec): Building dependency tree... 0%
aws_instance.router[0] (remote-exec): Building dependency tree... 0%
aws_instance.router[0] (remote-exec): Building dependency tree... 50%
aws_instance.router[0] (remote-exec): Building dependency tree... 50%
aws_instance.router[0] (remote-exec): Building dependency tree
aws_instance.router[0] (remote-exec): Reading state information... 0%
aws_instance.router[0] (remote-exec): Reading state information... 0%
aws_instance.router[0] (remote-exec): Reading state information... Done
aws_instance.router[0] (remote-exec): 16 packages can be upgraded. Run 'apt list --upgradable' to see them.
aws_instance.router[0] (remote-exec): Reading package lists... 0%
aws_instance.router[0] (remote-exec): Reading package lists... 100%
aws_instance.router[0] (remote-exec): Reading package lists... Done
aws_instance.router[1] (remote-exec): Created symlink /etc/systemd/system/multi-user.target.wants/strongswan-starter.service → /lib/systemd/system/strongswan-starter.service.
aws_instance.router[0] (remote-exec): Building dependency tree... 0%
aws_instance.router[0] (remote-exec): Building dependency tree... 0%
aws_instance.router[0] (remote-exec): Building dependency tree... 50%
aws_instance.router[0] (remote-exec): Building dependency tree... 50%
aws_instance.router[0] (remote-exec): Building dependency tree
aws_instance.router[0] (remote-exec): Reading state information... 0%
aws_instance.router[0] (remote-exec): Reading state information... 0%
aws_instance.router[0] (remote-exec): Reading state information... Done
aws_instance.router[0] (remote-exec): wget is already the newest version (1.20.3-1ubuntu1).
aws_instance.router[0] (remote-exec): wget set to manually installed.
aws_instance.router[0] (remote-exec): The following additional packages will be installed:
aws_instance.router[0] (remote-exec):   libcharon-extauth-plugins
aws_instance.router[0] (remote-exec):   libstrongswan
aws_instance.router[0] (remote-exec):   libstrongswan-standard-plugins
aws_instance.router[0] (remote-exec):   strongswan-charon
aws_instance.router[0] (remote-exec):   strongswan-libcharon
aws_instance.router[0] (remote-exec):   strongswan-starter
aws_instance.router[0] (remote-exec): Suggested packages:
aws_instance.router[0] (remote-exec):   libstrongswan-extra-plugins
aws_instance.router[0] (remote-exec):   libcharon-extra-plugins
aws_instance.router[0] (remote-exec): The following NEW packages will be installed:
aws_instance.router[0] (remote-exec):   libcharon-extauth-plugins
aws_instance.router[0] (remote-exec):   libstrongswan
aws_instance.router[0] (remote-exec):   libstrongswan-standard-plugins
aws_instance.router[0] (remote-exec):   strongswan strongswan-charon
aws_instance.router[0] (remote-exec):   strongswan-libcharon
aws_instance.router[0] (remote-exec):   strongswan-starter
aws_instance.router[0] (remote-exec): 0 upgraded, 7 newly installed, 0 to remove and 16 not upgraded.
aws_instance.router[0] (remote-exec): Need to get 876 kB of archives.
aws_instance.router[0] (remote-exec): After this operation, 4163 kB of additional disk space will be used.
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [Working]
aws_instance.router[0] (remote-exec): Get:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libstrongswan amd64 5.8.2-1ubuntu3.1 [357 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 0% [1 libstrongswan 0 B/357 kB 0%]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 35% [Working]
aws_instance.router[0] (remote-exec): Get:2 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-libcharon amd64 5.8.2-1ubuntu3.1 [241 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 35% [2 strongswan-libcharon 0 B/241 kB
aws_instance.router[0] (remote-exec): 60% [Working]
aws_instance.router[0] (remote-exec): Get:3 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-charon amd64 5.8.2-1ubuntu3.1 [22.2 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 60% [3 strongswan-charon 0 B/22.2 kB 0%
aws_instance.router[0] (remote-exec): 65% [Working]
aws_instance.router[0] (remote-exec): Get:4 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan-starter amd64 5.8.2-1ubuntu3.1 [148 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 65% [4 strongswan-starter 0 B/148 kB 0%
aws_instance.router[0] (remote-exec): 81% [Working]
aws_instance.router[0] (remote-exec): Get:5 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libcharon-extauth-plugins amd64 5.8.2-1ubuntu3.1 [23.0 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 81% [5 libcharon-extauth-plugins 0 B/23
aws_instance.router[0] (remote-exec): 86% [Working]
aws_instance.router[0] (remote-exec): Get:6 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libstrongswan-standard-plugins amd64 5.8.2-1ubuntu3.1 [67.6 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 86% [6 libstrongswan-standard-plugins 0
aws_instance.router[0] (remote-exec): 95% [Working]
aws_instance.router[0] (remote-exec): Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 strongswan all 5.8.2-1ubuntu3.1 [18.2 kB]
aws_instance.router[0] (remote-exec):
aws_instance.router[0] (remote-exec): 95% [7 strongswan 0 B/18.2 kB 0%]
aws_instance.router[0] (remote-exec): 100% [Working]
aws_instance.router[0] (remote-exec): Fetched 876 kB in 0s (2846 kB/s)
Progress: [ 90%] [################..] Setting up strongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 97%] [#################.] Processing triggers for man-db (2.9.1-1) ...
aws_instance.router[1] (remote-exec): Processing triggers for systemd (245.4-4ubuntu3.2) ...
aws_instance.router[0] (remote-exec): Preconfiguring packages ...

aws_instance.router[0] (remote-exec): Selecting previously unselected package libstrongswan.
aws_instance.router[0] (remote-exec): (Reading database ...
aws_instance.router[0] (remote-exec): (Reading database ... 5%
aws_instance.router[0] (remote-exec): (Reading database ... 10%
aws_instance.router[0] (remote-exec): (Reading database ... 15%
aws_instance.router[0] (remote-exec): (Reading database ... 20%
aws_instance.router[0] (remote-exec): (Reading database ... 25%
aws_instance.router[0] (remote-exec): (Reading database ... 30%
aws_instance.router[0] (remote-exec): (Reading database ... 35%
aws_instance.router[0] (remote-exec): (Reading database ... 40%
aws_instance.router[0] (remote-exec): (Reading database ... 45%
aws_instance.router[0] (remote-exec): (Reading database ... 50%
aws_instance.router[0] (remote-exec): (Reading database ... 55%
aws_instance.router[0] (remote-exec): (Reading database ... 60%
aws_instance.router[0] (remote-exec): (Reading database ... 65%
aws_instance.router[0] (remote-exec): (Reading database ... 70%
aws_instance.router[0] (remote-exec): (Reading database ... 75%
aws_instance.router[0] (remote-exec): (Reading database ... 80%
aws_instance.router[0] (remote-exec): (Reading database ... 85%
aws_instance.router[0] (remote-exec): (Reading database ... 90%
aws_instance.router[0] (remote-exec): (Reading database ... 95%
aws_instance.router[0] (remote-exec): (Reading database ... 100%
aws_instance.router[0] (remote-exec): (Reading database ... 59625 files and directories currently installed.)
aws_instance.router[0] (remote-exec): Preparing to unpack .../0-libstrongswan_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [  3%] [..................] Unpacking libstrongswan (5.8.2-1ubuntu3.1) ...
Progress: [  7%] [#.................] Selecting previously unselected package strongswan-libcharon.
aws_instance.router[0] (remote-exec): Preparing to unpack .../1-strongswan-libcharon_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 10%] [#.................] Unpacking strongswan-libcharon (5.8.2-1ubuntu3.1) ...
Progress: [ 14%] [##................] Selecting previously unselected package strongswan-charon.
aws_instance.router[0] (remote-exec): Preparing to unpack .../2-strongswan-charon_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 17%] [###...............] Unpacking strongswan-charon (5.8.2-1ubuntu3.1) ...
Progress: [ 21%] [###...............] Selecting previously unselected package strongswan-starter.
aws_instance.router[0] (remote-exec): Preparing to unpack .../3-strongswan-starter_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 24%] [####..............] Unpacking strongswan-starter (5.8.2-1ubuntu3.1) ...
Progress: [ 28%] [####..............] Selecting previously unselected package libcharon-extauth-plugins.
aws_instance.router[0] (remote-exec): Preparing to unpack .../4-libcharon-extauth-plugins_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 31%] [#####.............] Unpacking libcharon-extauth-plugins (5.8.2-1ubuntu3.1) ...

Progress: [ 34%] [######............] Selecting previously unselected package libstrongswan-standard-plugins.
aws_instance.router[0] (remote-exec): Preparing to unpack .../5-libstrongswan-standard-plugins_5.8.2-1ubuntu3.1_amd64.deb ...
Progress: [ 38%] [######............]
Progress: [ 41%] [#######...........] Selecting previously unselected package strongswan.
aws_instance.router[0] (remote-exec): Preparing to unpack .../6-strongswan_5.8.2-1ubuntu3.1_all.deb ...
Progress: [ 45%] [########..........] Unpacking strongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 48%] [########..........] Setting up libstrongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 55%] [#########.........] Setting up strongswan-libcharon (5.8.2-1ubuntu3.1) ...
Progress: [ 62%] [###########.......] Setting up libcharon-extauth-plugins (5.8.2-1ubuntu3.1) ...
Progress: [ 69%] [############......] Setting up strongswan-charon (5.8.2-1ubuntu3.1) ...
Progress: [ 76%] [#############.....] Setting up libstrongswan-standard-plugins (5.8.2-1ubuntu3.1) ...
Progress: [ 83%] [##############....] Setting up strongswan-starter (5.8.2-1ubuntu3.1) ...
Progress: [ 86%] [###############...]
aws_instance.router[1] (remote-exec): --2020-08-28 08:22:53--  https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/51-eth1.yaml
aws_instance.router[1] (remote-exec): Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.112.133
aws_instance.router[1] (remote-exec): Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.112.133|:443... connected.
aws_instance.router[1] (remote-exec): HTTP request sent, awaiting response...
aws_instance.router[1] (remote-exec): 200 OK
aws_instance.router[1] (remote-exec): Length: 169 [text/plain]
aws_instance.router[1] (remote-exec): Saving to: ‘51-eth1.yaml’

aws_instance.router[1] (remote-exec): 51-eth1.yam   0%       0  --.-KB/s
aws_instance.router[1] (remote-exec): 51-eth1.yam 100%     169  --.-KB/s    in 0s

aws_instance.router[1] (remote-exec): 2020-08-28 08:22:53 (9.22 MB/s) - ‘51-eth1.yaml’ saved [169/169]

aws_instance.router[1] (remote-exec): --2020-08-28 08:22:53--  https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ffrouting-install.sh
aws_instance.router[1] (remote-exec): Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.112.133
aws_instance.router[1] (remote-exec): Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.112.133|:443... connected.
aws_instance.router[1] (remote-exec): HTTP request sent, awaiting response...
aws_instance.router[0] (remote-exec): Created symlink /etc/systemd/system/multi-user.target.wants/strongswan-starter.service → /lib/systemd/system/strongswan-starter.service.
aws_instance.router[1] (remote-exec): 200 OK
aws_instance.router[1] (remote-exec): Length: 2969 (2.9K) [text/plain]
aws_instance.router[1] (remote-exec): Saving to: ‘ffrouting-install.sh’

aws_instance.router[1] (remote-exec):       ffrou   0%       0  --.-KB/s
aws_instance.router[1] (remote-exec): ffrouting-i 100%   2.90K  --.-KB/s    in 0s

aws_instance.router[1] (remote-exec): 2020-08-28 08:22:53 (40.8 MB/s) - ‘ffrouting-install.sh’ saved [2969/2969]

aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.758: Processing input file /etc/netplan/50-cloud-init.yaml..
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.758: starting new processing pass
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.758: Processing input file /etc/netplan/51-eth1.yaml..
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: starting new processing pass
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: We have some netdefs, pass them through a final round of validation
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: ens5: setting default backend to 1
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: Configuration is valid
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: ens6: setting default backend to 1
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: Configuration is valid
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: Generating output files..
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: NetworkManager: definition ens5 is not for us (backend 1)
aws_instance.router[1] (remote-exec): ** (generate:2688): DEBUG: 08:22:53.759: NetworkManager: definition ens6 is not for us (backend 1)
aws_instance.router[1] (remote-exec): (generate:2688): GLib-DEBUG: 08:22:53.759: posix_spawn avoided (fd close requested)
aws_instance.router[1] (remote-exec): DEBUG:netplan generated networkd configuration changed, restarting networkd
Progress: [ 90%] [################..] Setting up strongswan (5.8.2-1ubuntu3.1) ...
Progress: [ 97%] [#################.] Processing triggers for man-db (2.9.1-1) ...
aws_instance.router[1] (remote-exec): DEBUG:no netplan generated NM configuration exists
aws_instance.router[1] (remote-exec): DEBUG:ens5 not found in {}
aws_instance.router[1] (remote-exec): DEBUG:ens6 not found in {'ens5': {'dhcp4': True, 'dhcp6': False, 'match': {'macaddress': '0a:de:99:0f:41:fc'}, 'set-name': 'ens5'}}
aws_instance.router[1] (remote-exec): DEBUG:Merged config:
aws_instance.router[1] (remote-exec): network:
aws_instance.router[1] (remote-exec):   bonds: {}
aws_instance.router[1] (remote-exec):   bridges: {}
aws_instance.router[1] (remote-exec):   ethernets:
aws_instance.router[1] (remote-exec):     ens5:
aws_instance.router[1] (remote-exec):       dhcp4: true
aws_instance.router[1] (remote-exec):       dhcp6: false
aws_instance.router[1] (remote-exec):       match:
aws_instance.router[1] (remote-exec):         macaddress: 0a:de:99:0f:41:fc
aws_instance.router[1] (remote-exec):       set-name: ens5
aws_instance.router[1] (remote-exec):     ens6:
aws_instance.router[1] (remote-exec):       dhcp4: true
aws_instance.router[1] (remote-exec):       dhcp4-overrides:
aws_instance.router[1] (remote-exec):         route-metric: 200
aws_instance.router[1] (remote-exec):         use-routes: false
aws_instance.router[1] (remote-exec):   vlans: {}
aws_instance.router[1] (remote-exec):   wifis: {}

aws_instance.router[1] (remote-exec): DEBUG:Skipping non-physical interface: lo
aws_instance.router[1] (remote-exec): DEBUG:device ens5 operstate is up, not changing
aws_instance.router[1] (remote-exec): DEBUG:{}
aws_instance.router[1] (remote-exec): DEBUG:netplan triggering .link rules for lo
aws_instance.router[1] (remote-exec): DEBUG:netplan triggering .link rules for ens5
aws_instance.router[1]: Creation complete after 56s [id=i-0f52e4c90c20064e1]
aws_eip.router2_eip: Creating...
aws_instance.router[0] (remote-exec): Processing triggers for systemd (245.4-4ubuntu3.2) ...
aws_eip.router2_eip: Creation complete after 1s [id=eipalloc-03b70a6287f41ba18]
aws_customer_gateway.router2: Creating...
aws_ec2_transit_gateway.tgw: Still creating... [1m0s elapsed]

aws_instance.router[0] (remote-exec): --2020-08-28 08:22:55--  https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/51-eth1.yaml
aws_instance.router[0] (remote-exec): Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.112.133
aws_instance.router[0] (remote-exec): Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.112.133|:443... connected.
aws_instance.router[0] (remote-exec): HTTP request sent, awaiting response... 200 OK
aws_instance.router[0] (remote-exec): Length: 169 [text/plain]
aws_instance.router[0] (remote-exec): Saving to: ‘51-eth1.yaml’

aws_instance.router[0] (remote-exec): 51-eth1.yam   0%       0  --.-KB/s
aws_instance.router[0] (remote-exec): 51-eth1.yam 100%     169  --.-KB/s    in 0s

aws_instance.router[0] (remote-exec): 2020-08-28 08:22:55 (8.81 MB/s) - ‘51-eth1.yaml’ saved [169/169]

aws_instance.router[0] (remote-exec): --2020-08-28 08:22:55--  https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ffrouting-install.sh
aws_instance.router[0] (remote-exec): Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.112.133
aws_instance.router[0] (remote-exec): Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.112.133|:443... connected.
aws_instance.router[0] (remote-exec): HTTP request sent, awaiting response... 200 OK
aws_instance.router[0] (remote-exec): Length: 2969 (2.9K) [text/plain]
aws_instance.router[0] (remote-exec): Saving to: ‘ffrouting-install.sh’

aws_instance.router[0] (remote-exec):       ffrou   0%       0  --.-KB/s
aws_instance.router[0] (remote-exec): ffrouting-i 100%   2.90K  --.-KB/s    in 0s

aws_instance.router[0] (remote-exec): 2020-08-28 08:22:55 (46.4 MB/s) - ‘ffrouting-install.sh’ saved [2969/2969]

aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.526: Processing input file /etc/netplan/50-cloud-init.yaml..
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.526: starting new processing pass
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.526: Processing input file /etc/netplan/51-eth1.yaml..
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: starting new processing pass
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: We have some netdefs, pass them through a final round of validation
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: ens5: setting default backend to 1
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: Configuration is valid
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: ens6: setting default backend to 1
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: Configuration is valid
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: Generating output files..
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: NetworkManager: definition ens5 is not for us (backend 1)
aws_instance.router[0] (remote-exec): ** (generate:2712): DEBUG: 08:22:55.527: NetworkManager: definition ens6 is not for us (backend 1)
aws_instance.router[0] (remote-exec): (generate:2712): GLib-DEBUG: 08:22:55.527: posix_spawn avoided (fd close requested)
aws_instance.router[0] (remote-exec): DEBUG:netplan generated networkd configuration changed, restarting networkd
aws_instance.router[0] (remote-exec): DEBUG:no netplan generated NM configuration exists
aws_instance.router[0] (remote-exec): DEBUG:ens5 not found in {}
aws_instance.router[0] (remote-exec): DEBUG:ens6 not found in {'ens5': {'dhcp4': True, 'dhcp6': False, 'match': {'macaddress': '0a:a0:2b:a8:31:ba'}, 'set-name': 'ens5'}}
aws_instance.router[0] (remote-exec): DEBUG:Merged config:
aws_instance.router[0] (remote-exec): network:
aws_instance.router[0] (remote-exec):   bonds: {}
aws_instance.router[0] (remote-exec):   bridges: {}
aws_instance.router[0] (remote-exec):   ethernets:
aws_instance.router[0] (remote-exec):     ens5:
aws_instance.router[0] (remote-exec):       dhcp4: true
aws_instance.router[0] (remote-exec):       dhcp6: false
aws_instance.router[0] (remote-exec):       match:
aws_instance.router[0] (remote-exec):         macaddress: 0a:a0:2b:a8:31:ba
aws_instance.router[0] (remote-exec):       set-name: ens5
aws_instance.router[0] (remote-exec):     ens6:
aws_instance.router[0] (remote-exec):       dhcp4: true
aws_instance.router[0] (remote-exec):       dhcp4-overrides:
aws_instance.router[0] (remote-exec):         route-metric: 200
aws_instance.router[0] (remote-exec):         use-routes: false
aws_instance.router[0] (remote-exec):   vlans: {}
aws_instance.router[0] (remote-exec):   wifis: {}

aws_instance.router[0] (remote-exec): DEBUG:Skipping non-physical interface: lo
aws_instance.router[0] (remote-exec): DEBUG:device ens5 operstate is up, not changing
aws_instance.router[0] (remote-exec): DEBUG:{}
aws_instance.router[0] (remote-exec): DEBUG:netplan triggering .link rules for lo
aws_instance.router[0] (remote-exec): DEBUG:netplan triggering .link rules for ens5
aws_instance.router[0]: Creation complete after 59s [id=i-03e0144929540d7a9]
aws_eip.router1_eip: Creating...
aws_eip.router1_eip: Creation complete after 0s [id=eipalloc-066b8bbb5a2c7c62b]
aws_customer_gateway.router1: Creating...
aws_customer_gateway.router2: Still creating... [10s elapsed]
aws_ec2_transit_gateway.tgw: Still creating... [1m10s elapsed]
aws_customer_gateway.router2: Creation complete after 10s [id=cgw-0e904408dd60a3f79]
aws_customer_gateway.router1: Still creating... [10s elapsed]
aws_customer_gateway.router1: Creation complete after 11s [id=cgw-06d3486ca0d0ae7b6]
aws_ec2_transit_gateway.tgw: Creation complete after 1m14s [id=tgw-0f80fbcb27941fe90]
aws_vpn_connection.A4LTGW_R2: Creating...
aws_vpn_connection.A4LTGW_R1: Creating...
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Creating...
aws_vpn_connection.A4LTGW_R2: Still creating... [10s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [10s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [10s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [20s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [20s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [20s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [30s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [30s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [30s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [40s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [40s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [40s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [50s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [50s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [50s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m0s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m0s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still creating... [1m0s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Creation complete after 1m5s [id=tgw-attach-00e3e72b97eb4d699]
aws_route_table.aws-rt: Creating...
aws_route_table.aws-rt: Creation complete after 0s [id=rtb-0aa4954cd6228c9a7]
aws_route_table_association.aws-subnet-B: Creating...
aws_route_table_association.aws-subnet-A: Creating...
aws_route_table_association.aws-subnet-B: Creation complete after 1s [id=rtbassoc-08d32bb1f1fc09410]
aws_route_table_association.aws-subnet-A: Creation complete after 1s [id=rtbassoc-00fe169880e3b9222]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m10s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m10s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m20s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m20s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m30s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m30s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m40s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m40s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [1m50s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [1m50s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m0s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m0s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m10s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m10s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m20s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m20s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m30s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m30s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m40s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m40s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [2m50s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [2m50s elapsed]
aws_vpn_connection.A4LTGW_R2: Still creating... [3m0s elapsed]
aws_vpn_connection.A4LTGW_R1: Still creating... [3m0s elapsed]
aws_vpn_connection.A4LTGW_R1: Creation complete after 3m3s [id=vpn-05ed0a1248d1d9215]
aws_vpn_connection.A4LTGW_R2: Creation complete after 3m4s [id=vpn-08aa1f20e84bcdaef]

Apply complete! Resources: 35 added, 0 changed, 0 destroyed.

Outputs:

router1_private_ip = 192.168.12.9
router1_public_ip = 18.159.248.21
router2_private_ip = 192.168.12.37
router2_public_ip = 3.123.227.33
tunnel1_address = 35.156.250.211
tunnel1_cgw_inside_address = 169.254.118.42/30
tunnel1_preshared_key = KtipQLW8PYw6cY9ezP3h6dn4KU3pw6kz
tunnel1_vgw_inside_address = 169.254.118.41/30
tunnel2_address = 52.57.15.139
tunnel2_cgw_inside_address = 169.254.78.2/30
tunnel2_preshared_key = adhiq74GjDztQ71vdh8yu3A2TBenIGHJ
tunnel2_vgw_inside_address = 169.254.78.1/30
```

## Save output
```
root@v22019078674692622:~/terraform-aws-vpn-bgp-demo# terraform output -json > outputs.json
```

## Generate ipsec-files
```
root@v22019078674692622:~/terraform-aws-vpn-bgp-demo# python generate_ipsec_credentials.py
scp -i my_keys router1_ipsec-vti.sh ubuntu@18.159.248.21:~/demo_assets/ipsec-vti.sh
scp -i my_keys router2_ipsec-vti.sh ubuntu@3.123.227.33:~/demo_assets/ipsec-vti.sh
scp -i my_keys router1_ipsec.conf ubuntu@18.159.248.21:~/demo_assets/ipsec.conf
scp -i my_keys router2_ipsec.conf ubuntu@3.123.227.33:~/demo_assets/ipsec.conf
scp -i my_keys router1_ipsec.secrets ubuntu@18.159.248.21:~/demo_assets/ipsec.secrets
scp -i my_keys router2_ipsec.secrets ubuntu@3.123.227.33:~/demo_assets/ipsec.secrets
ssh -i my_keys ubuntu@18.159.248.21 'sudo cp ~/demo_assets/ipsec* /etc/'
ssh -i my_keys ubuntu@18.159.248.21 'sudo chmod +x /etc/ipsec-vti.sh'
ssh -i my_keys ubuntu@18.159.248.21 'sudo service ipsec restart'
ssh -i my_keys ubuntu@3.123.227.33 'sudo cp ~/demo_assets/ipsec* /etc/'
ssh -i my_keys ubuntu@3.123.227.33 'sudo chmod +x /etc/ipsec-vti.sh'
ssh -i my_keys ubuntu@3.123.227.33 'sudo service ipsec restart'
```

## Execute commands
```
root@v22019078674692622:~/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@3.126.48.242 'sudo ipsec status'
Security Associations (2 up, 0 connecting):
 AWS-VPC-GW2[2]: ESTABLISHED 23 seconds ago, 192.168.12.9[3.126.48.242]...52.57.15.139[52.57.15.139]
 AWS-VPC-GW2{2}:  INSTALLED, TUNNEL, reqid 2, ESP in UDP SPIs: ce232799_i c2022198_o
 AWS-VPC-GW2{2}:   0.0.0.0/0 === 0.0.0.0/0
 AWS-VPC-GW1[1]: ESTABLISHED 23 seconds ago, 192.168.12.9[3.126.48.242]...35.156.250.211[35.156.250.211]
 AWS-VPC-GW1{1}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: c23086b6_i cbe1f206_o
 AWS-VPC-GW1{1}:   0.0.0.0/0 === 0.0.0.0/0
```
