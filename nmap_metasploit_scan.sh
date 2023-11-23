import nmap
from metasploit.msfrpc import MsfRpcClient

# Read target IP addresses from a local file
with open('target_ips.txt', 'r') as file:
    target_ips = file.readlines()
    target_ips = [ip.strip() for ip in target_ips]

# Initialize Nmap scanner
nm = nmap.PortScanner()

# Establish a connection to the Metasploit RPC interface
client = MsfRpcClient('YourUsername', 'YourPassword', 'localhost', 55552)  # Replace with your actual credentials

# Iterate through each target IP address
for target_ip in target_ips:
    # Perform an Nmap scan to identify open ports and services
    nm.scan(target_ip, arguments='-sS -sV -A -O')

    # Extract open ports and services
    open_ports = nm[target_ip]['tcp'].keys()
    services = [nm[target_ip]['tcp'][port]['name'] for port in open_ports]

    # Use Metasploit to search for associated vulnerabilities for each service
    for service in services:
        # Search for associated vulnerabilities using the Metasploit RPC interface
        search_results = client.modules.use('search', type='exploit').execute(payload=service)
        print(f"Vulnerabilities for {service} on {target_ip}:")
        for result in search_results['modules']:
            print(result['Name'])