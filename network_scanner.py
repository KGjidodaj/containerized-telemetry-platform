# importing the libraries needed and datetime from datetime for readability
import socket
from datetime import datetime

# The active_threats list is a dynamic structure with info about IPs with open ports for security reasons.
# The CRITICAL_ADDRESSES tuple is a mock-set that I can not change with the IPs and the ports.
active_threats = []
CRITICAL_ADDRESSES = (("8.8.8.8",53),("127.0.0.1",22),("1.1.1.1",80))

# Initiating Port Scanning sequence over critical nodes.
for ip,port in CRITICAL_ADDRESSES :

    ## Connecting (IPV4 TCP) with the IP and port specified above.
    scanner_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    scanner_socket.settimeout(4) ### Adding a timeout after 4 seconds to avoid errors.
    result_code = scanner_socket.connect_ex((ip,port))

    if result_code == 0:

        ## Trying to receive a message-banner_data (in utf-8 decoding) else just set banner_data blank.
        try :
            banner_data = scanner_socket.recv(1024).decode('utf-8')
        except:
            banner_data = ""
        now = datetime.now()
        active_threats.append([ now.isoformat(timespec='seconds'),ip,port,f"Message: {banner_data}"]) ### Log identified threat payload alongside timestamp and banner output.
        scanner_socket.close()

    else:

        print("Could not connect with the server")
        scanner_socket.close()

print(active_threats)
