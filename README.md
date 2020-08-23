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
