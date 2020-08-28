#!/usr/bin/env python

import requests
import json

files_to_download = {
        'ipsec-vti.sh':'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec-vti.sh',
        'ipsec.conf':'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec.conf',
        'ipsec.secrets':'https://raw.githubusercontent.com/acantril/learn-cantrill-io-labs/master/AWS_HYBRID_AdvancedVPN/OnPremRouter1/ipsec.secrets'
        }


terraform_output_file = "outputs.json"
terraform_output = json.load(open(terraform_output_file))


def replace_values(string, router):
    if router == "router1":
        pass
    if router == "router2":
        pass
    string = string.replace("ROUTER1_PRIVATE_IP",terraform_output["router1_private_ip"]["value"])
    string = string.replace("ROUTER2_PRIVATE_IP",terraform_output["router2_private_ip"]["value"])

    string = string.replace("CONN1_TUNNEL1_ONPREM_OUTSIDE_IP",terraform_output["router1_public_ip"]["value"])
    string = string.replace("CONN1_TUNNEL2_ONPREM_OUTSIDE_IP",terraform_output["router1_public_ip"]["value"])
    string = string.replace("CONN2_TUNNEL1_ONPREM_OUTSIDE_IP",terraform_output["router2_public_ip"]["value"])
    string = string.replace("CONN2_TUNNEL2_ONPREM_OUTSIDE_IP",terraform_output["router2_public_ip"]["value"])
    string = string.replace("CONN1_TUNNEL1_AWS_OUTSIDE_IP",terraform_output["tunnel1_address"]["value"])
    string = string.replace("CONN1_TUNNEL2_AWS_OUTSIDE_IP",terraform_output["tunnel2_address"]["value"])
    string = string.replace("CONN1_TUNNEL1_PresharedKey",terraform_output["tunnel1_preshared_key"]["value"])
    string = string.replace("CONN1_TUNNEL2_PresharedKey",terraform_output["tunnel2_preshared_key"]["value"])
    return string


for key,value in files_to_download.items():
    res = requests.get(value)
    res.raise_for_status()
    output_router1 = replace_values(res.text, "router1")
    output_router2 = replace_values(res.text, "router2")
    print(output_router1)
    print(output_router2)
