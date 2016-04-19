import kumon
import sys

# main function to execute the contianer monitoring
# functionality
def main(argv):
    # __init__(self, configurationPath, socketPath):
    # configurationPath = monalisa conf file
    # socketPath = where to find the docker remote API
    monitor = kumon.Kumon('dest.conf', 'unix://host/var/run/docker.sock')
    monitor.start_monitoring()

if __name__ == "__main__":
   main(sys.argv[1:])
