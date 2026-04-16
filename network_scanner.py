# importing the libraries needed and datetime from datetime for readability
import sys
import socket
from datetime import datetime

info = sys.argv[1]
addresses = info.split(" ") ## to save the string into two pairs of strings

final_list = [] ## setting up the list to append the two parts

# Adding a try statement in case the user input error
try:
    for pair in addresses: ## two loops with index 0 being 8.8.8.8:53 and index 1.1.1.1:80

        ip_port = pair.split(":") ## do a second split between the two iterations between the two strings making it 4 seperate strings

        final_list.append([ip_port[0], int(ip_port[1])]) ## the index 0 and 1 is in the first pair of two strings the first ip and first port with port being int same for the second iteration.


    crit_add = final_list

    # The active_threats list is a dynamic structure with info about IPs with open ports for security reasons.
    active_threats = []


    # Initiating Port Scanning sequence over critical nodes.
    for ip,port in crit_add :

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
            active_threats.append([ now.isoformat(timespec='seconds'),ip,f"Port: {port}",f"Message: {banner_data}"]) ### Log identified threat payload alongside timestamp and banner output.
            scanner_socket.close()

        else:

            scanner_socket.close()

    print(active_threats)
except:
    print("Error (press 4 and try again)")
