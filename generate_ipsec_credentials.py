#!/usr/bin/env python

import sys
import json
import subprocess

files_to_download = {
    'ipsec-vti.sh': {
        'router1': 'ressources/router1/ipsec-vti.sh',
        'router2': 'ressources/router2/ipsec-vti.sh',
    },
    'ipsec.conf': {
        'router1': 'ressources/router1/ipsec.conf',
        'router2': 'ressources/router2/ipsec.conf',
    },
    'ipsec.secrets': {
        'router1': 'ressources/router1/ipsec.secrets',
        'router2': 'ressources/router2/ipsec.secrets',
    },
}

bgp_configuration = {
        'router1': """
sudo vtysh
conf t
frr defaults traditional
router bgp 65016
neighbor CONN1_TUNNEL1_AWS_INSIDE_IP remote-as 64512
neighbor CONN1_TUNNEL2_AWS_INSIDE_IP remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
ip r
        """,
        'router2':"""
sudo vtysh
conf t
frr defaults traditional
router bgp 65016
neighbor CONN2_TUNNEL1_AWS_INSIDE_IP remote-as 64512
neighbor CONN2_TUNNEL2_AWS_INSIDE_IP remote-as 64512
no bgp ebgp-requires-policy
address-family ipv4 unicast
redistribute connected
exit-address-family
exit
exit
wr
exit
ip r
        """
        }


# terraform_output_file = "outputs.json"
# terraform_output = json.load(open(terraform_output_file))

# get terraform output
terraform_output = json.loads(subprocess.check_output(["terraform", "output", "-json"]).decode("utf-8"))

if len(terraform_output) == 0:
    print("No terraform output")
    sys.exit()


def replace_values(string):
    try:
        string = string.replace("ROUTER1_PRIVATE_IP", terraform_output["router1_private_ip"]["value"])
        string = string.replace("ROUTER2_PRIVATE_IP", terraform_output["router2_private_ip"]["value"])
        string = string.replace("CONN1_TUNNEL1_ONPREM_OUTSIDE_IP", terraform_output["router1_public_ip"]["value"])
        string = string.replace("CONN1_TUNNEL2_ONPREM_OUTSIDE_IP", terraform_output["router1_public_ip"]["value"])
        string = string.replace("CONN2_TUNNEL1_ONPREM_OUTSIDE_IP", terraform_output["router2_public_ip"]["value"])
        string = string.replace("CONN2_TUNNEL2_ONPREM_OUTSIDE_IP", terraform_output["router2_public_ip"]["value"])
        string = string.replace("CONN1_TUNNEL1_AWS_OUTSIDE_IP", terraform_output["router1_tunnel1_address"]["value"])
        string = string.replace("CONN1_TUNNEL2_AWS_OUTSIDE_IP", terraform_output["router1_tunnel2_address"]["value"])
        string = string.replace("CONN1_TUNNEL1_PresharedKey", terraform_output["router1_tunnel1_preshared_key"]["value"])
        string = string.replace("CONN1_TUNNEL2_PresharedKey", terraform_output["router1_tunnel2_preshared_key"]["value"])
        string = string.replace("CONN2_TUNNEL1_AWS_OUTSIDE_IP", terraform_output["router2_tunnel1_address"]["value"])
        string = string.replace("CONN2_TUNNEL2_AWS_OUTSIDE_IP", terraform_output["router2_tunnel2_address"]["value"])
        string = string.replace("CONN2_TUNNEL1_PresharedKey", terraform_output["router2_tunnel1_preshared_key"]["value"])
        string = string.replace("CONN2_TUNNEL2_PresharedKey", terraform_output["router2_tunnel2_preshared_key"]["value"])
        string = string.replace("CONN1_TUNNEL1_ONPREM_INSIDE_IP",
                            terraform_output["router1_tunnel1_cgw_inside_address"]["value"])
        string = string.replace("CONN1_TUNNEL1_AWS_INSIDE_IP",
                            terraform_output["router1_tunnel1_vgw_inside_address"]["value"])
        string = string.replace("CONN1_TUNNEL2_ONPREM_INSIDE_IP",
                            terraform_output["router1_tunnel2_cgw_inside_address"]["value"])
        string = string.replace("CONN1_TUNNEL2_AWS_INSIDE_IP",
                            terraform_output["router1_tunnel2_vgw_inside_address"]["value"])
        string = string.replace("CONN2_TUNNEL1_ONPREM_INSIDE_IP",
                            terraform_output["router2_tunnel1_cgw_inside_address"]["value"])
        string = string.replace("CONN2_TUNNEL1_AWS_INSIDE_IP",
                            terraform_output["router2_tunnel1_vgw_inside_address"]["value"])
        string = string.replace("CONN2_TUNNEL2_ONPREM_INSIDE_IP",
                            terraform_output["router2_tunnel2_cgw_inside_address"]["value"])
        string = string.replace("CONN2_TUNNEL2_AWS_INSIDE_IP",
                            terraform_output["router2_tunnel2_vgw_inside_address"]["value"])
    except:
        print("Error replacing values")
        sys.exit()
    return string


cmds = ""
for filename, values in files_to_download.items():
    for router, path in values.items():
        res = open(path).read() 
        output = replace_values(res)
        with open(f"{router}_{filename}", "w") as wf:
            wf.write(output)
            wf.write("\n")

        public_ip = terraform_output[f"{router}_public_ip"]["value"]
        cmds += f"scp -i my_keys {router}_{filename} ubuntu@{public_ip}:~/demo_assets/{filename}\n"


bgp_config = ""
for router in ["router1", "router2"]:
    bgp_config += f"ssh -i my_keys ubuntu@{public_ip}\n"
    bgp_config += f"#{router} BGP configuration\n"+replace_values(bgp_configuration[router]).replace("/30","")+"\n"
    public_ip = terraform_output[f"{router}_public_ip"]["value"]
    print(f"ssh-keyscan -H {public_ip} >> ~/.ssh/known_hosts")
    cmds += f"ssh -i my_keys ubuntu@{public_ip} 'sudo cp ~/demo_assets/ipsec* /etc/ && sudo chmod +x /etc/ipsec-vti.sh && sudo service ipsec restart && sleep 5 && sudo ipsec status'\n"

print(cmds)
print(bgp_config)

