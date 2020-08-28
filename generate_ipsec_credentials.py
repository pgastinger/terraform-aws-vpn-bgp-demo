#!/usr/bin/env python

import requests
import json
import subprocess

files_to_download = {
    'ipsec-vti.sh': {
        'router1': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec-vti.sh',
        'router2': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter2/ipsec-vti.sh',
    },
    'ipsec.conf': {
        'router1': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec.conf',
        'router2': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter2/ipsec.conf',
    },
    'ipsec.secrets': {
        'router1': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec.secrets',
        'router2': 'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter2/ipsec.secrets',
    },
}

# terraform_output_file = "outputs.json"
# terraform_output = json.load(open(terraform_output_file))

# get terraform output
terraform_output = json.loads(subprocess.check_output(["terraform", "output", "-json"]).decode("utf-8"))


def replace_values(string):
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
    return string


cmds = ""
for filename, values in files_to_download.items():
    for router, path in values.items():
        res = requests.get(path)
        res.raise_for_status()
        output = replace_values(res.text)
        with open(f"{router}_{filename}", "w") as wf:
            wf.write(output)
            wf.write("\n")

        public_ip = terraform_output[f"{router}_public_ip"]["value"]
        cmds += f"scp -i my_keys {router}_{filename} ubuntu@{public_ip}:~/demo_assets/{filename}\n"

for router in ["router1", "router2"]:
    public_ip = terraform_output[f"{router}_public_ip"]["value"]
    print(f"ssh -i my_keys ubuntu@{public_ip} 'uname -a'")
    cmds += f"ssh -i my_keys ubuntu@{public_ip} 'sudo cp ~/demo_assets/ipsec* /etc/'\n"
    cmds += f"ssh -i my_keys ubuntu@{public_ip} 'sudo chmod +x /etc/ipsec-vti.sh'\n"
    cmds += f"ssh -i my_keys ubuntu@{public_ip} 'sudo service ipsec restart'\n"
    cmds += f"ssh -i my_keys ubuntu@{public_ip} 'sudo ipsec status'\n"

print(cmds)
