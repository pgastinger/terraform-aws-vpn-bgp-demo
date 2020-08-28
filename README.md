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

router1_private_ip = 192.168.12.96
router1_public_ip = 18.192.9.148
router1_tunnel1_address = 18.197.24.112
router1_tunnel1_cgw_inside_address = 169.254.184.34/30
router1_tunnel1_preshared_key = 4p0ikKczA.U.FCvod3dC7fTQ_JBgCMK3
router1_tunnel1_vgw_inside_address = 169.254.184.33/30
router1_tunnel2_address = 52.29.189.203
router1_tunnel2_cgw_inside_address = 169.254.30.14/30
router1_tunnel2_preshared_key = RUaK_m2YsRAzqrEIySqxtOgYZl1cyxVG
router1_tunnel2_vgw_inside_address = 169.254.30.13/30
router2_private_ip = 192.168.12.196
router2_public_ip = 52.29.243.174
router2_tunnel1_address = 18.194.56.153
router2_tunnel1_cgw_inside_address = 169.254.211.122/30
router2_tunnel1_preshared_key = TngSUNlaQIzpEo6_1ht.L3pS9UPeAECE
router2_tunnel1_vgw_inside_address = 169.254.211.121/30
router2_tunnel2_address = 52.57.15.111
router2_tunnel2_cgw_inside_address = 169.254.112.154/30
router2_tunnel2_preshared_key = ng3OidiWqx.4IWmwe_pAU0WfD6fe6lvH
router2_tunnel2_vgw_inside_address = 169.254.112.153/30
```

## Generate ipsec-files
```
python generate_ipsec_credentials.py  
ssh -i my_keys ubuntu@18.192.9.148 'uname -a'
ssh -i my_keys ubuntu@52.29.243.174 'uname -a'
scp -i my_keys router1_ipsec-vti.sh ubuntu@18.192.9.148:~/demo_assets/ipsec-vti.sh
scp -i my_keys router2_ipsec-vti.sh ubuntu@52.29.243.174:~/demo_assets/ipsec-vti.sh
scp -i my_keys router1_ipsec.conf ubuntu@18.192.9.148:~/demo_assets/ipsec.conf
scp -i my_keys router2_ipsec.conf ubuntu@52.29.243.174:~/demo_assets/ipsec.conf
scp -i my_keys router1_ipsec.secrets ubuntu@18.192.9.148:~/demo_assets/ipsec.secrets
scp -i my_keys router2_ipsec.secrets ubuntu@52.29.243.174:~/demo_assets/ipsec.secrets
ssh -i my_keys ubuntu@18.192.9.148 'sudo cp ~/demo_assets/ipsec* /etc/'
ssh -i my_keys ubuntu@18.192.9.148 'sudo chmod +x /etc/ipsec-vti.sh'
ssh -i my_keys ubuntu@18.192.9.148 'sudo service ipsec restart'
ssh -i my_keys ubuntu@18.192.9.148 'sudo ipsec status'
ssh -i my_keys ubuntu@52.29.243.174 'sudo cp ~/demo_assets/ipsec* /etc/'
ssh -i my_keys ubuntu@52.29.243.174 'sudo chmod +x /etc/ipsec-vti.sh'
ssh -i my_keys ubuntu@52.29.243.174 'sudo service ipsec restart'
ssh -i my_keys ubuntu@52.29.243.174 'sudo ipsec status'
```

## Execute commands
```
ssh -i my_keys ubuntu@3.126.48.242 'sudo ipsec status'
Security Associations (2 up, 0 connecting):
 AWS-VPC-GW2[2]: ESTABLISHED 23 seconds ago, 192.168.12.9[3.126.48.242]...52.57.15.139[52.57.15.139]
 AWS-VPC-GW2{2}:  INSTALLED, TUNNEL, reqid 2, ESP in UDP SPIs: ce232799_i c2022198_o
 AWS-VPC-GW2{2}:   0.0.0.0/0 === 0.0.0.0/0
 AWS-VPC-GW1[1]: ESTABLISHED 23 seconds ago, 192.168.12.9[3.126.48.242]...35.156.250.211[35.156.250.211]
 AWS-VPC-GW1{1}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: c23086b6_i cbe1f206_o
 AWS-VPC-GW1{1}:   0.0.0.0/0 === 0.0.0.0/0
```
