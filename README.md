# cloudshark-capture

Wrapper script for dumpcap to upload to
[CloudShark](https://www.cloudshark.org)

This script is a wrapper for the dumpcap program used by
[Wireshark](https://www.wireshark.org/) to perform network captures. To run
this script you will need to change the `api_token` variable to an API token on
the CloudShark server that you are using.

By default this script will use https://www.cloudshark.org/ as the CloudShark
server to upload captures to but this can also be modified by changing the
`cloudshark_url` variable to a different URL.

This script will prompt the user before uploading a capture file to
[CloudShark](https://www.cloudshark.org). Changing the `prompt` variable to `n`
will disable this and automatically upload the capture.

The script will run `dumpcap` with the same arguments provided to the script
such as `-i eth0 -c 10` to capture 10 packets on the eth0 interface.
