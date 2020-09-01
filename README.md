# terraform-aws-vpn-bgp-demo

**Please be aware, even with the AWS free tier, this will cost you something for the VPN connections!**

based on Adrians advanced demos:
https://www.reddit.com/r/AmazonWebServices/comments/hzbj9e/series_of_mini_projectsadvanced_demos_for_aws/
https://github.com/acantril/learn-cantrill-io-labs

## Mini Project : Implement a BGP Based, HA, Dynamic Site-to-Site VPN with no hardware
https://www.reddit.com/r/aws/comments/hjtq23/mini_project_implement_a_bgp_based_ha_dynamic/

### Differences to Adrians demo:

**Disclaimer: This is just a proof of concept, there are a lot of things which can be improved!**

  - Terraform (very basic, at lot of room for improvements) instead of Cloudformation
  - works in every region
  - no manual configuration (at least not much). A python script is used to convert the Terraform output into usable files.
  - no SSM yet, no VPCEs yet
  - use of latest Ubuntu (20.04) ami for the OnPrem routers
  - use of t2.miro for the OnPrem routers (because it is free)
  - installing frr using snap instead of compiling
  - most important point, this setup currently does not work (IPSEC and BGP connections are fine, looks like there is an issue between server and router onprem).
  
**I have no idea about what might be wrong and no more time to further investigate**

## How To

### Clone repository
```
root@v22019078674692622:/srv# git clone git@github.com:pgastinger/terraform-aws-vpn-bgp-demo.git
Cloning into 'terraform-aws-vpn-bgp-demo'...
remote: Enumerating objects: 115, done.
remote: Counting objects: 100% (115/115), done.
remote: Compressing objects: 100% (86/86), done.
remote: Total 115 (delta 60), reused 79 (delta 27), pack-reused 0
Receiving objects: 100% (115/115), 35.13 KiB | 413.00 KiB/s, done.
Resolving deltas: 100% (60/60), done.
root@v22019078674692622:/srv# cd terraform-aws-vpn-bgp-demo/
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ls -ltr
total 60
drwxr-xr-x 4 root root 4096 Aug 31 21:27 ressources
-rw-r--r-- 1 root root 5065 Aug 31 21:27 README.md
-rw-r--r-- 1 root root 5378 Aug 31 21:27 generate_ipsec_credentials.py
-rw-r--r-- 1 root root 2142 Aug 31 21:27 90_outputs.tf
-rw-r--r-- 1 root root  970 Aug 31 21:27 40_gateways.tf
-rw-r--r-- 1 root root 4174 Aug 31 21:27 30_ec2.tf
-rw-r--r-- 1 root root  910 Aug 31 21:27 22_securitygroups.tf
-rw-r--r-- 1 root root 2234 Aug 31 21:27 21_routetables.tf
-rw-r--r-- 1 root root 2108 Aug 31 21:27 20_vpc.tf
-rw-r--r-- 1 root root  824 Aug 31 21:27 15_iam_roles.tf
-rw-r--r-- 1 root root  119 Aug 31 21:27 10_ssh_keys.tf
-rw-r--r-- 1 root root   45 Aug 31 21:27 00_provider.tf
```

### Generate SSH keys
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo#  ssh-keygen -f my_keys
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in my_keys.
Your public key has been saved in my_keys.pub.
The key fingerprint is:
SHA256:VSnu/rUk9jjw7UBYDmfe2aZ9sIEG+KG4oPQ0N60jNaY root@v22019078674692622
The key's randomart image is:
+---[RSA 2048]----+
|            ..   |
|         ....    |
|        ..=.+    |
|       o +.@ o o |
|  . + B S.o * = o|
| . + B =  oo   B |
|  . E +  . o+.= o|
|     . .  ..oB...|
|           .oo+  |
+----[SHA256]-----+
```
### Set AWS credentials
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# aws configure
AWS Access Key ID [****************HD5J]: access_key_from_aws_console
AWS Secret Access Key [****************Tmrw]: very_secure_access_key
Default region name [eu-central-1]:
Default output format [None]:
```
### Terraform init
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.4.0...
- Installed hashicorp/aws v3.4.0 (signed by HashiCorp)

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/aws: version = "~> 3.4.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Terraform apply

```
root@v22019078674692622:~/terraform-aws-vpn-bgp-demo# terraform apply
data.aws_ami.app_ami: Refreshing state...
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# terraform apply
data.aws_availability_zones.available: Refreshing state...
data.aws_ami.app_ami: Refreshing state...
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
      ~ id          = "2020-08-31 19:30:41.938084376 +0000 UTC" -> "2020-08-31 19:30:44.079783186 +0000 UTC"
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
...
Apply complete! Resources: 0 added, 2 changed, 0 destroyed.

Outputs:

router1_private_ip = 192.168.12.48
router1_public_ip = 3.126.170.37
router1_tunnel1_address = 18.158.135.75
router1_tunnel1_cgw_inside_address = 169.254.191.170/30
router1_tunnel1_preshared_key = .a_yE0L2r3Ls5V9em_M91IAsW6aTtx3T
router1_tunnel1_vgw_inside_address = 169.254.191.169/30
router1_tunnel2_address = 3.123.187.24
router1_tunnel2_cgw_inside_address = 169.254.189.242/30
router1_tunnel2_preshared_key = 6z.LRhnpG5FY93KDrgH9I4OeoEoU7xy2
router1_tunnel2_vgw_inside_address = 169.254.189.241/30
router2_private_ip = 192.168.12.243
router2_public_ip = 18.192.18.140
router2_tunnel1_address = 18.194.79.149
router2_tunnel1_cgw_inside_address = 169.254.170.6/30
router2_tunnel1_preshared_key = j.1RT9Ux7WYmdGFM_Ac8x9pXD3z4xJwf
router2_tunnel1_vgw_inside_address = 169.254.170.5/30
router2_tunnel2_address = 18.197.131.43
router2_tunnel2_cgw_inside_address = 169.254.35.66/30
router2_tunnel2_preshared_key = iMYaJUrt5yazADFTOpoa8.Rb1SudMnJQ
router2_tunnel2_vgw_inside_address = 169.254.35.65/30
```

## Generate commands to write files ...
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# python generate_ipsec_credentials.py
ssh -i my_keys ubuntu@3.126.170.37
ssh -i my_keys ubuntu@18.192.18.140
scp -i my_keys router1_ipsec-vti.sh ubuntu@3.126.170.37:~/demo_assets/ipsec-vti.sh
scp -i my_keys router2_ipsec-vti.sh ubuntu@18.192.18.140:~/demo_assets/ipsec-vti.sh
scp -i my_keys router1_ipsec.conf ubuntu@3.126.170.37:~/demo_assets/ipsec.conf
scp -i my_keys router2_ipsec.conf ubuntu@18.192.18.140:~/demo_assets/ipsec.conf
scp -i my_keys router1_ipsec.secrets ubuntu@3.126.170.37:~/demo_assets/ipsec.secrets
scp -i my_keys router2_ipsec.secrets ubuntu@18.192.18.140:~/demo_assets/ipsec.secrets
ssh -i my_keys ubuntu@3.126.170.37 'sudo cp ~/demo_assets/ipsec* /etc/ && sudo chmod +x /etc/ipsec-vti.sh && sudo service ipsec restart && sleep 5 && sudo ipsec status'
ssh -i my_keys ubuntu@3.126.170.37 'sudo snap install frr'
ssh -i my_keys ubuntu@18.192.18.140 'sudo cp ~/demo_assets/ipsec* /etc/ && sudo chmod +x /etc/ipsec-vti.sh && sudo service ipsec restart && sleep 5 && sudo ipsec status'
ssh -i my_keys ubuntu@18.192.18.140 'sudo snap install frr'

#router1 BGP configuration

sudo frr.vtysh
conf t
frr defaults traditional
router bgp 65016
neighbor 169.254.191.169 remote-as 64512
neighbor 169.254.189.241 remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
sudo reboot

#router2 BGP configuration

sudo frr.vtysh
conf t
frr defaults traditional
router bgp 65016
neighbor 169.254.170.5 remote-as 64512
neighbor 169.254.35.65 remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
sudo reboot

```


## Execute commands (initial SSH-connection for host keys required)
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router1_ipsec-vti.sh ubuntu@3.126.170.37:~/demo_assets/ipsec-vti.sh
scp -i my_keys router2_ipsec-vti.sh ubuntu@18.192.18.140:~/demo_assets/ipsec-vti.sh
scp -i my_keys router1_ipsec.conf ubuntu@3.126.170.37:~/demo_assets/ipsec.conf
scp -i my_keys router2_ipsec.conf ubuntu@18.192.18.140:~/demo_assets/ipsec.conf
scp -i my_keys router1_ipsec.secrets ubuntu@3.126.170.37:~/demo_assets/ipsec.secrets
scp -i my_keys router2_ipsec.secrets ubuntu@18.192.18.140:~/demo_assets/ipsec.secrets
router1_ipsec-vti.sh                                                                                                                                                                                                                         100% 1777   283.5KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router2_ipsec-vti.sh ubuntu@18.192.18.140:~/demo_assets/ipsec-vti.sh
router2_ipsec-vti.sh                                                                                                                                                                                                                         100% 1769   312.2KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router1_ipsec.conf ubuntu@3.126.170.37:~/demo_assets/ipsec.conf
router1_ipsec.conf                                                                                                                                                                                                                           100% 1727   288.9KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router2_ipsec.conf ubuntu@18.192.18.140:~/demo_assets/ipsec.conf
router2_ipsec.conf                                                                                                                                                                                                                           100% 1733   282.4KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router1_ipsec.secrets ubuntu@3.126.170.37:~/demo_assets/ipsec.secrets
router1_ipsec.secrets                                                                                                                                                                                                                        100%  335    56.4KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys router2_ipsec.secrets ubuntu@18.192.18.140:~/demo_assets/ipsec.secrets
router2_ipsec.secrets                                                                                                                                                                                                                        100%  338    56.6KB/s   00:00
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@3.126.170.37 'sudo cp ~/demo_assets/ipsec* /etc/ && sudo chmod +x /etc/ipsec-vti.sh && sudo service ipsec restart && sleep 5 && sudo ipsec status'
Security Associations (2 up, 0 connecting):
 AWS-VPC-GW2[2]: ESTABLISHED 5 seconds ago, 192.168.12.48[3.126.170.37]...3.123.187.24[3.123.187.24]
 AWS-VPC-GW2{2}:  INSTALLED, TUNNEL, reqid 2, ESP in UDP SPIs: cafe3ad0_i c219af9d_o
 AWS-VPC-GW2{2}:   0.0.0.0/0 === 0.0.0.0/0
 AWS-VPC-GW1[1]: ESTABLISHED 5 seconds ago, 192.168.12.48[3.126.170.37]...18.158.135.75[18.158.135.75]
 AWS-VPC-GW1{1}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: c079f10a_i c1010f96_o
 AWS-VPC-GW1{1}:   0.0.0.0/0 === 0.0.0.0/0
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@18.192.18.140 'sudo cp ~/demo_assets/ipsec* /etc/ && sudo chmod +x /etc/ipsec-vti.sh && sudo service ipsec restart && sleep 5 && sudo ipsec status'
Security Associations (2 up, 0 connecting):
 AWS-VPC-GW2[2]: ESTABLISHED 5 seconds ago, 192.168.12.243[18.192.18.140]...18.197.131.43[18.197.131.43]
 AWS-VPC-GW2{2}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: ca42cdb0_i c3ee6d69_o
 AWS-VPC-GW2{2}:   0.0.0.0/0 === 0.0.0.0/0
 AWS-VPC-GW1[1]: ESTABLISHED 5 seconds ago, 192.168.12.243[18.192.18.140]...18.194.79.149[18.194.79.149]
 AWS-VPC-GW1{1}:  INSTALLED, TUNNEL, reqid 2, ESP in UDP SPIs: c279a4cb_i cf168d88_o
 AWS-VPC-GW1{1}:   0.0.0.0/0 === 0.0.0.0/0
 root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@3.126.170.37 'sudo snap install frr'
frr 7.2.1 from Martin Winter (osr) installed
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@18.192.18.140 'sudo snap install frr'
frr 7.2.1 from Martin Winter (osr) installed
```

## BGP
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@3.126.170.37
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1021-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Aug 31 19:46:50 UTC 2020

  System load:  0.12              Users logged in:       0
  Usage of /:   18.9% of 7.69GB   IPv4 address for eth0: 192.168.12.48
  Memory usage: 27%               IPv4 address for eth1: 192.168.10.228
  Swap usage:   0%                IPv4 address for vti1: 169.254.191.170
  Processes:    121               IPv4 address for vti2: 169.254.189.242


23 updates can be installed immediately.
6 of these updates are security updates.
To see these additional updates run: apt list --upgradable


Last login: Mon Aug 31 19:43:17 2020 from 152.89.104.249
ubuntu@ip-192-168-12-48:~$ sudo frr.vtysh
conf t
frr defaults traditional
router bgp 65016
neighbor 169.254.191.169 remote-as 64512
neighbor 169.254.189.241 remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
sudo reboot

Hello, this is FRRouting (version 7.2.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

ip-192-168-12-48# conf t
ip-192-168-12-48(config)# frr defaults traditional
ip-192-168-12-48(config)# router bgp 65016
ip-192-168-12-48(config-router)# neighbor 169.254.191.169 remote-as 64512
ip-192-168-12-48(config-router)# neighbor 169.254.189.241 remote-as 64512
ip-192-168-12-48(config-router)# no bgp ebgp-requires-policy
ip-192-168-12-48(config-router)# address-family ipv4 unicast
ip-192-168-12-48(config-router-af)# redistribute connected
ip-192-168-12-48(config-router-af)# exit-address-family
ip-192-168-12-48(config-router)# exit
ip-192-168-12-48(config)# exit
ip-192-168-12-48# wr
Note: this version of vtysh never writes vtysh.conf
Building Configuration...
Configuration saved to /var/snap/frr/87/zebra.conf
Configuration saved to /var/snap/frr/87/ripd.conf
Configuration saved to /var/snap/frr/87/ripngd.conf
Configuration saved to /var/snap/frr/87/ldpd.conf
Configuration saved to /var/snap/frr/87/bgpd.conf
Configuration saved to /var/snap/frr/87/isisd.conf
Configuration saved to /var/snap/frr/87/pimd.conf
Configuration saved to /var/snap/frr/87/eigrpd.conf
Configuration saved to /var/snap/frr/87/babeld.conf
Configuration saved to /var/snap/frr/87/fabricd.conf
Configuration saved to /var/snap/frr/87/pbrd.conf
Configuration saved to /var/snap/frr/87/staticd.conf
Configuration saved to /var/snap/frr/87/bfdd.conf
Configuration saved to /var/snap/frr/87/vrrpd.conf
ip-192-168-12-48# exit
ubuntu@ip-192-168-12-48:~$ sudo reboot
ubuntu@ip-192-168-12-48:~$ Connection to 3.126.170.37 closed by remote host.
Connection to 3.126.170.37 closed.

root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# ssh -i my_keys ubuntu@18.192.18.140
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1021-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Aug 31 19:47:14 UTC 2020

  System load:  0.47              Users logged in:       0
  Usage of /:   19.1% of 7.69GB   IPv4 address for eth0: 192.168.12.243
  Memory usage: 28%               IPv4 address for eth1: 192.168.11.133
  Swap usage:   0%                IPv4 address for vti1: 169.254.170.6
  Processes:    123               IPv4 address for vti2: 169.254.35.66


24 updates can be installed immediately.
6 of these updates are security updates.
To see these additional updates run: apt list --upgradable


Last login: Mon Aug 31 19:43:22 2020 from 152.89.104.249
ubuntu@ip-192-168-12-243:~$ sudo frr.vtysh
frr defaults traditional
router bgp 65016
neighbor 169.254.170.5 remote-as 64512
neighbor 169.254.35.65 remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
sudo reboot

Hello, this is FRRouting (version 7.2.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

ip-192-168-12-243# conf t
ip-192-168-12-243(config)# frr defaults traditional
ip-192-168-12-243(config)# router bgp 65016
ip-192-168-12-243(config-router)# neighbor 169.254.170.5 remote-as 64512
ip-192-168-12-243(config-router)# neighbor 169.254.35.65 remote-as 64512
ip-192-168-12-243(config-router)# no bgp ebgp-requires-policy
ip-192-168-12-243(config-router)# address-family ipv4 unicast
ip-192-168-12-243(config-router-af)# redistribute connected
ip-192-168-12-243(config-router-af)# exit-address-family
ip-192-168-12-243(config-router)# exit
ip-192-168-12-243(config)# exit
ip-192-168-12-243# wr
Note: this version of vtysh never writes vtysh.conf
Building Configuration...
Configuration saved to /var/snap/frr/87/zebra.conf
Configuration saved to /var/snap/frr/87/ripd.conf
Configuration saved to /var/snap/frr/87/ripngd.conf
Configuration saved to /var/snap/frr/87/ldpd.conf
Configuration saved to /var/snap/frr/87/bgpd.conf
Configuration saved to /var/snap/frr/87/isisd.conf
Configuration saved to /var/snap/frr/87/pimd.conf
Configuration saved to /var/snap/frr/87/eigrpd.conf
Configuration saved to /var/snap/frr/87/babeld.conf
Configuration saved to /var/snap/frr/87/fabricd.conf
Configuration saved to /var/snap/frr/87/pbrd.conf
Configuration saved to /var/snap/frr/87/staticd.conf
Configuration saved to /var/snap/frr/87/bfdd.conf
Configuration saved to /var/snap/frr/87/vrrpd.conf
ip-192-168-12-243# exit
ubuntu@ip-192-168-12-243:~$ sudo reboot
ubuntu@ip-192-168-12-243:~$ Connection to 18.192.18.140 closed by remote host.
Connection to 18.192.18.140 closed.

```
## BGP Commands
```
ip-192-168-12-48# show ip bgp
BGP table version is 3, local router ID is 192.168.12.48, vrf id 0
Default local pref 100, local AS 65016
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*= 10.16.0.0/16     169.254.191.169        100             0 64512 i
*>                  169.254.189.241        100             0 64512 i
*> 192.168.10.0/24  0.0.0.0                  0         32768 ?
*> 192.168.12.0/24  0.0.0.0                  0         32768 ?

ip-192-168-12-243# show ip bgp
BGP table version is 3, local router ID is 192.168.12.243, vrf id 0
Default local pref 100, local AS 65016
Status codes:  s suppressed, d damped, h history, * valid, > best, = multipath,
               i internal, r RIB-failure, S Stale, R Removed
Nexthop codes: @NNN nexthop's vrf id, < announce-nh-self
Origin codes:  i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*= 10.16.0.0/16     169.254.170.5          100             0 64512 i
*>                  169.254.35.65          100             0 64512 i
*> 192.168.11.0/24  0.0.0.0                  0         32768 ?
*> 192.168.12.0/24  0.0.0.0                  0         32768 ?

```


## Ping
- Connect to OnPrem servers via routers:
```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys my_keys ubuntu@3.126.170.37:
my_keys   
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# scp -i my_keys my_keys ubuntu@18.192.18.140:
my_keys   

ubuntu@ip-192-168-12-48:~$ ssh ec2-user@192.168.10.119 -i my_keys
The authenticity of host '192.168.10.119 (192.168.10.119)' can't be established.
ECDSA key fingerprint is SHA256:zyVd1Za9foeoAuq6ZH0JNpFaHwKhtoXR7a50PQTATZo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.10.119' (ECDSA) to the list of known hosts.

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
```
- Ping to Router1 internal interface:
```
[ec2-user@ip-192-168-10-119 ~]$ ping 192.168.10.228
PING 192.168.10.228 (192.168.10.228) 56(84) bytes of data.
64 bytes from 192.168.10.228: icmp_seq=1 ttl=64 time=0.313 ms
64 bytes from 192.168.10.228: icmp_seq=2 ttl=64 time=0.395 ms
^C
--- 192.168.10.228 ping statistics ---
```
- Ping to Router1 external interface:
```
[ec2-user@ip-192-168-10-119 ~]$ ping 192.168.12.243
PING 192.168.12.243 (192.168.12.243) 56(84) bytes of data.
64 bytes from 192.168.12.243: icmp_seq=1 ttl=64 time=0.350 ms
64 bytes from 192.168.12.243: icmp_seq=2 ttl=64 time=0.376 ms
```

- Ping via VPN
```
[ec2-user@ip-192-168-10-119 ~]$ ping 10.16.46.112
PING 10.16.46.112 (10.16.46.112) 56(84) bytes of data.
^C
--- 10.16.46.112 ping statistics ---
8 packets transmitted, 0 received, 100% packet loss, time 7161ms

```

- Traceroute to VPN
```
[ec2-user@ip-192-168-10-119 ~]$ traceroute 10.16.46.112
traceroute to 10.16.46.112 (10.16.46.112), 30 hops max, 60 byte packets
 1  * * *
 2  * * *
 3  * * *
 4  * * *
```

- Routing-Table for OnPrem server 1 subnet:
```


```


- IP-Forwarding on router is enabled, source/dest check disabled. Route-table looks good, any ideas? 


## AWS Console
- IPSEC and BGP are up
![image](https://user-images.githubusercontent.com/3997488/91760591-e6248000-ebd3-11ea-9647-68e1411f66c4.png)
![image](https://user-images.githubusercontent.com/3997488/91761070-9d20fb80-ebd4-11ea-8148-7b53385eeea7.png)
![image](https://user-images.githubusercontent.com/3997488/91761452-37813f00-ebd5-11ea-985e-c5db355a5260.png)


## Decommissioning

```
root@v22019078674692622:/srv/terraform-aws-vpn-bgp-demo# terraform destroy
data.aws_ami.router_ami: Refreshing state... [id=ami-0a072f8c9a7fccb6e]
data.aws_ami.app_ami: Refreshing state... [id=ami-0c115dbd34c69a004]
data.aws_availability_zones.available: Refreshing state... [id=2020-08-31 19:41:46.766816696 +0000 UTC]
aws_key_pair.my_pub_key: Refreshing state... [id=my_pub_key]
aws_ec2_transit_gateway.tgw: Refreshing state... [id=tgw-093a5a0a2ea161961]
aws_vpc.onprem: Refreshing state... [id=vpc-0c10bb031dc952ce7]
aws_vpc.a4l_aws: Refreshing state... [id=vpc-0e82ef3b15a7e2665]
aws_iam_role.ssm_role: Refreshing state... [id=ssm_role]
aws_iam_role_policy_attachment.ssm_attach: Refreshing state... [id=ssm_role-20200831193125944900000001]
aws_iam_instance_profile.ec2_profile: Refreshing state... [id=ec2_profile]
aws_internet_gateway.igw_aws: Refreshing state... [id=igw-0fd0643d0504beb7d]
aws_security_group.aws-sg: Refreshing state... [id=sg-08d1ab667dcbb3929]
aws_subnet.sn-aws-private-A: Refreshing state... [id=subnet-0b7eb9fee9074569a]
aws_subnet.sn-aws-private-B: Refreshing state... [id=subnet-064e8edf300622f07]
aws_internet_gateway.igw_onprem: Refreshing state... [id=igw-063447abbc0796918]
aws_subnet.ONPREM-PUBLIC: Refreshing state... [id=subnet-0d868193f1fb44678]
aws_subnet.ONPREM-PRIVATE-2: Refreshing state... [id=subnet-0834afbdede9c18bf]
aws_subnet.ONPREM-PRIVATE-1: Refreshing state... [id=subnet-032e81a9d9e059f34]
aws_security_group.onprem-sg: Refreshing state... [id=sg-0ac9b5b61344d6de4]
aws_route_table.onprem-public-route-table: Refreshing state... [id=rtb-0f00f0a5d386c2906]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Refreshing state... [id=tgw-attach-04c1d469132706af0]
aws_route_table_association.onprem-public-subnet: Refreshing state... [id=rtbassoc-089fa583ea1706332]
aws_instance.aws_ec2_b: Refreshing state... [id=i-072935b48c4025f9f]
aws_instance.aws_ec2_a: Refreshing state... [id=i-02dee52fd45123db2]
aws_instance.server2: Refreshing state... [id=i-0b33c4e2319234e74]
aws_instance.server1: Refreshing state... [id=i-015532e33082cbd0a]
aws_instance.router[1]: Refreshing state... [id=i-0d9e8863655c2292f]
aws_instance.router[0]: Refreshing state... [id=i-0eddac648e2f11bad]
aws_ssm_activation.ssm_activation: Refreshing state... [id=77e9e1f1-ab4f-463f-8cda-90ef3b9d4f03]
aws_route_table.aws-rt: Refreshing state... [id=rtb-035bf5de03eb227f9]
aws_route_table_association.aws-subnet-A: Refreshing state... [id=rtbassoc-05b984f2d61a9c91f]
aws_route_table_association.aws-subnet-B: Refreshing state... [id=rtbassoc-060c77d8a0377650c]
aws_eip.router2_eip: Refreshing state... [id=eipalloc-053c9b63167bf0cb6]
aws_eip.router1_eip: Refreshing state... [id=eipalloc-0088be7f21cd4d605]
aws_network_interface.router2_lan: Refreshing state... [id=eni-0f861208c13e5e606]
aws_network_interface.router1_lan: Refreshing state... [id=eni-0ba7fc249f4bd067b]
aws_customer_gateway.router1: Refreshing state... [id=cgw-06584394349acee88]
aws_customer_gateway.router2: Refreshing state... [id=cgw-04108287995c5df89]
aws_route_table.onprem-private-subnet-1-route-table: Refreshing state... [id=rtb-01355ca96056a3e77]
aws_route_table.onprem-private-subnet-2-route-table: Refreshing state... [id=rtb-0b9efac5df95c9084]
aws_vpn_connection.A4LTGW_R1: Refreshing state... [id=vpn-0804c6a21872c306b]
aws_vpn_connection.A4LTGW_R2: Refreshing state... [id=vpn-092471830f262f4c0]
aws_route_table_association.onprem-private-subnet-1-route-table-attach: Refreshing state... [id=rtbassoc-04eb72d0cb3b8a266]
aws_route_table_association.onprem-private-subnet-2-route-table-attach: Refreshing state... [id=rtbassoc-0511d1bd037d26496]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_customer_gateway.router1 will be destroyed
  - resource "aws_customer_gateway" "router1" {
      - arn        = "arn:aws:ec2:eu-central-1:321929761884:customer-gateway/cgw-06584394349acee88" -> null
      - bgp_asn    = "65016" -> null
      - id         = "cgw-06584394349acee88" -> null
      - ip_address = "3.126.170.37" -> null
      - tags       = {
          - "Name" = "ONPREM-ROUTER1"
        } -> null
      - type       = "ipsec.1" -> null
    }

...
  - router2_tunnel2_vgw_inside_address = "169.254.35.65/30" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_internet_gateway.igw_aws: Destroying... [id=igw-0fd0643d0504beb7d]
aws_instance.server1: Destroying... [id=i-015532e33082cbd0a]
aws_vpn_connection.A4LTGW_R1: Destroying... [id=vpn-0804c6a21872c306b]
aws_ssm_activation.ssm_activation: Destroying... [id=77e9e1f1-ab4f-463f-8cda-90ef3b9d4f03]
aws_route_table_association.onprem-private-subnet-1-route-table-attach: Destroying... [id=rtbassoc-04eb72d0cb3b8a266]
aws_instance.aws_ec2_a: Destroying... [id=i-02dee52fd45123db2]
aws_route_table_association.aws-subnet-A: Destroying... [id=rtbassoc-05b984f2d61a9c91f]
aws_vpn_connection.A4LTGW_R2: Destroying... [id=vpn-092471830f262f4c0]
aws_route_table_association.onprem-public-subnet: Destroying... [id=rtbassoc-089fa583ea1706332]
aws_instance.aws_ec2_b: Destroying... [id=i-072935b48c4025f9f]
aws_ssm_activation.ssm_activation: Destruction complete after 0s
aws_route_table_association.onprem-private-subnet-2-route-table-attach: Destroying... [id=rtbassoc-0511d1bd037d26496]
aws_route_table_association.aws-subnet-A: Destruction complete after 0s
aws_route_table_association.onprem-public-subnet: Destruction complete after 0s
aws_route_table_association.aws-subnet-B: Destroying... [id=rtbassoc-060c77d8a0377650c]
aws_instance.server2: Destroying... [id=i-0b33c4e2319234e74]
aws_route_table_association.onprem-private-subnet-1-route-table-attach: Destruction complete after 0s
aws_iam_role_policy_attachment.ssm_attach: Destroying... [id=ssm_role-20200831193125944900000001]
aws_route_table_association.onprem-private-subnet-2-route-table-attach: Destruction complete after 0s
aws_route_table.onprem-public-route-table: Destroying... [id=rtb-0f00f0a5d386c2906]
aws_route_table_association.aws-subnet-B: Destruction complete after 0s
aws_route_table.onprem-private-subnet-1-route-table: Destroying... [id=rtb-01355ca96056a3e77]
aws_route_table.onprem-public-route-table: Destruction complete after 0s
aws_route_table.onprem-private-subnet-2-route-table: Destroying... [id=rtb-0b9efac5df95c9084]
aws_route_table.onprem-private-subnet-1-route-table: Destruction complete after 0s
aws_route_table.aws-rt: Destroying... [id=rtb-035bf5de03eb227f9]
aws_iam_role_policy_attachment.ssm_attach: Destruction complete after 0s
aws_internet_gateway.igw_onprem: Destroying... [id=igw-063447abbc0796918]
aws_route_table.onprem-private-subnet-2-route-table: Destruction complete after 5s
aws_network_interface.router1_lan: Destroying... [id=eni-0ba7fc249f4bd067b]
aws_route_table.aws-rt: Destruction complete after 6s
aws_network_interface.router2_lan: Destroying... [id=eni-0f861208c13e5e606]
aws_internet_gateway.igw_aws: Still destroying... [id=igw-0fd0643d0504beb7d, 10s elapsed]
aws_instance.server1: Still destroying... [id=i-015532e33082cbd0a, 10s elapsed]
aws_vpn_connection.A4LTGW_R1: Still destroying... [id=vpn-0804c6a21872c306b, 10s elapsed]
aws_instance.aws_ec2_a: Still destroying... [id=i-02dee52fd45123db2, 10s elapsed]
aws_vpn_connection.A4LTGW_R2: Still destroying... [id=vpn-092471830f262f4c0, 10s elapsed]
aws_instance.aws_ec2_b: Still destroying... [id=i-072935b48c4025f9f, 10s elapsed]
aws_instance.server2: Still destroying... [id=i-0b33c4e2319234e74, 10s elapsed]
aws_internet_gateway.igw_aws: Destruction complete after 10s
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Destroying... [id=tgw-attach-04c1d469132706af0]
aws_internet_gateway.igw_onprem: Still destroying... [id=igw-063447abbc0796918, 10s elapsed]
aws_vpn_connection.A4LTGW_R1: Destruction complete after 12s
aws_vpn_connection.A4LTGW_R2: Destruction complete after 12s
aws_customer_gateway.router1: Destroying... [id=cgw-06584394349acee88]
aws_customer_gateway.router2: Destroying... [id=cgw-04108287995c5df89]
aws_customer_gateway.router1: Destruction complete after 0s
aws_customer_gateway.router2: Destruction complete after 0s
aws_eip.router1_eip: Destroying... [id=eipalloc-0088be7f21cd4d605]
aws_eip.router2_eip: Destroying... [id=eipalloc-053c9b63167bf0cb6]
aws_internet_gateway.igw_onprem: Destruction complete after 13s
aws_eip.router2_eip: Destruction complete after 1s
aws_eip.router1_eip: Destruction complete after 1s
aws_network_interface.router1_lan: Still destroying... [id=eni-0ba7fc249f4bd067b, 10s elapsed]
aws_network_interface.router2_lan: Still destroying... [id=eni-0f861208c13e5e606, 10s elapsed]
aws_instance.server1: Still destroying... [id=i-015532e33082cbd0a, 20s elapsed]
aws_instance.aws_ec2_a: Still destroying... [id=i-02dee52fd45123db2, 20s elapsed]
aws_instance.aws_ec2_b: Still destroying... [id=i-072935b48c4025f9f, 20s elapsed]
aws_instance.server2: Still destroying... [id=i-0b33c4e2319234e74, 20s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 10s elapsed]
aws_network_interface.router1_lan: Still destroying... [id=eni-0ba7fc249f4bd067b, 20s elapsed]
aws_network_interface.router2_lan: Still destroying... [id=eni-0f861208c13e5e606, 20s elapsed]
aws_instance.aws_ec2_b: Destruction complete after 29s
aws_network_interface.router1_lan: Destruction complete after 25s
aws_instance.server1: Still destroying... [id=i-015532e33082cbd0a, 30s elapsed]
aws_instance.aws_ec2_a: Still destroying... [id=i-02dee52fd45123db2, 30s elapsed]
aws_network_interface.router2_lan: Destruction complete after 24s
aws_instance.router[0]: Destroying... [id=i-0eddac648e2f11bad]
aws_instance.router[1]: Destroying... [id=i-0d9e8863655c2292f]
aws_instance.server2: Still destroying... [id=i-0b33c4e2319234e74, 30s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 20s elapsed]
aws_instance.aws_ec2_a: Destruction complete after 39s
aws_instance.server1: Destruction complete after 39s
aws_security_group.aws-sg: Destroying... [id=sg-08d1ab667dcbb3929]
aws_subnet.ONPREM-PRIVATE-1: Destroying... [id=subnet-032e81a9d9e059f34]
aws_instance.server2: Destruction complete after 39s
aws_subnet.ONPREM-PRIVATE-2: Destroying... [id=subnet-0834afbdede9c18bf]
aws_security_group.aws-sg: Destruction complete after 1s
aws_subnet.ONPREM-PRIVATE-1: Destruction complete after 1s
aws_instance.router[0]: Still destroying... [id=i-0eddac648e2f11bad, 10s elapsed]
aws_instance.router[1]: Still destroying... [id=i-0d9e8863655c2292f, 10s elapsed]
aws_subnet.ONPREM-PRIVATE-2: Destruction complete after 1s
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 30s elapsed]
aws_instance.router[0]: Still destroying... [id=i-0eddac648e2f11bad, 20s elapsed]
aws_instance.router[1]: Still destroying... [id=i-0d9e8863655c2292f, 20s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 40s elapsed]
aws_instance.router[1]: Destruction complete after 29s
aws_instance.router[0]: Destruction complete after 29s
aws_iam_instance_profile.ec2_profile: Destroying... [id=ec2_profile]
aws_security_group.onprem-sg: Destroying... [id=sg-0ac9b5b61344d6de4]
aws_key_pair.my_pub_key: Destroying... [id=my_pub_key]
aws_subnet.ONPREM-PUBLIC: Destroying... [id=subnet-0d868193f1fb44678]
aws_key_pair.my_pub_key: Destruction complete after 0s
aws_security_group.onprem-sg: Destruction complete after 1s
aws_subnet.ONPREM-PUBLIC: Destruction complete after 1s
aws_vpc.onprem: Destroying... [id=vpc-0c10bb031dc952ce7]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 50s elapsed]
aws_iam_instance_profile.ec2_profile: Destruction complete after 1s
aws_iam_role.ssm_role: Destroying... [id=ssm_role]
aws_vpc.onprem: Destruction complete after 5s
aws_iam_role.ssm_role: Destruction complete after 6s
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 1m0s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Still destroying... [id=tgw-attach-04c1d469132706af0, 1m10s elapsed]
aws_ec2_transit_gateway_vpc_attachment.tgw_attach: Destruction complete after 1m15s
aws_ec2_transit_gateway.tgw: Destroying... [id=tgw-093a5a0a2ea161961]
aws_subnet.sn-aws-private-A: Destroying... [id=subnet-0b7eb9fee9074569a]
aws_subnet.sn-aws-private-B: Destroying... [id=subnet-064e8edf300622f07]
aws_subnet.sn-aws-private-A: Destruction complete after 0s
aws_subnet.sn-aws-private-B: Destruction complete after 0s
aws_vpc.a4l_aws: Destroying... [id=vpc-0e82ef3b15a7e2665]
aws_vpc.a4l_aws: Destruction complete after 1s
aws_ec2_transit_gateway.tgw: Still destroying... [id=tgw-093a5a0a2ea161961, 10s elapsed]
aws_ec2_transit_gateway.tgw: Still destroying... [id=tgw-093a5a0a2ea161961, 20s elapsed]
aws_ec2_transit_gateway.tgw: Still destroying... [id=tgw-093a5a0a2ea161961, 30s elapsed]
aws_ec2_transit_gateway.tgw: Still destroying... [id=tgw-093a5a0a2ea161961, 40s elapsed]
aws_ec2_transit_gateway.tgw: Destruction complete after 44s

Destroy complete! Resources: 41 destroyed.

```


