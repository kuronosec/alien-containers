use strict;
use warnings;
use Kumon;

my $containerName = $ARGV[0];
my $monitor       = new Kumon("iri03.iri.uni-frankfurt.de",
                              "/host/var/run/docker.sock",
                              $containerName
                             );

for (my $i=0; $i <= 10; $i++) 
{
   my $json = $monitor->getData();
   $monitor->sendData($json);
   sleep(30);
}
