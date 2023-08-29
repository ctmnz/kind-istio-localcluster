import sys
import socket
import os

#in_hostname = sys.argv[1]
#in_port = int(sys.argv[2])
#in_timeout = 1

#def netcat(host, port, timeout):
#    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#    sock.settimeout(in_timeout)
#    try:
#        sock.connect((host, port))
#        print("All good!")
#    except Exception as e:
#        print("Error: Something went wrong while trying to connect to host: %s:%d. The exception is %s !" % (host, port, e))
#        sys.exit(os.EX_SOFTWARE)
#    finally:
#        sock.close()


def netcat(host, port, timeout):
    emptyvalues = ["", "''", " ", "' '", None, '""', '" "']
    if host in emptyvalues or port in emptyvalues or timeout in emptyvalues:
        return {'response':'error', 'error':'Function arguments are missing'}
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(int(timeout))
    try:
        sock.connect((str(host), int(port)))
        return {'response':'ok'}
    except Exception as e:
        return {'response':'error', 'error': repr(e)}
    finally:
        sock.close()



#netcat(in_hostname, in_port, in_timeout)

#print(api_netcat(in_hostname, in_port, in_timeout))
