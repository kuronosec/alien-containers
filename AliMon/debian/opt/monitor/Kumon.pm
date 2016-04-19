# This example shows how ApMon can be used to send information about a given job 
# to the MonALISA service
use strict;
use warnings;
use lib "/usr/share/perl5/";
use JSON;
use IO::Socket::UNIX qw( SOCK_STREAM );
use ApMon;
use Data::Dumper;

package Kumon;

sub new
{
    my $class = shift;
    my $self  = {
        _monalisaServer => shift,
        _socketPath     => shift,
        _containerName  => shift,
        _apm            => undef,
    };
    if ( ! $self->{_containerName} =~ m/^\w+$/ ) {
        die("Error: wrong container name. Only alphanumeric accepted. $!\n");
    }
    $self->{_apm} = new ApMon({$self->{_monalisaServer} => 
                        {"sys_monitoring" => 1, 
                         "general_info" => 1}});
    bless $self, $class;
    return $self;
}

sub getData
{
    my ( $self ) = @_;
    my $EOL = "\015\012";
    my $BLANK = $EOL x 2;

    my $json = JSON->new->allow_nonref;

    my $socket = IO::Socket::UNIX->new(
        Type => IO::Socket::UNIX->SOCK_STREAM,
            Peer => $self->{_socketPath},
    )
      or die("Can't connect to server: $!\n");

    $socket->autoflush(1);

    print $socket "GET /containers/$self->{_containerName}/stats?stream=false HTTP/1.0" . $BLANK;
    my @input = <$socket>;
    my $text = JSON::decode_json($input[4]);
    close $socket;

    return $text;
}

sub sendData
{
    my ( $self, $json ) = @_;

    # print Data::Dumper::Dumper($json);
    # you can put as many pairs of parameter_name, parameter_value as you want
    # but be careful not to create packets longer than 8K
    # TODO: really replace "job1" for 
    my @metricNames = $self->getMetricNames();
    my $value = undef;
    foreach $value ( @metricNames )
    {
        $self->{_apm}->sendParameters("ALICE::UF::KUBERNETES_Jobs", 
                                      "$self->{_containerName}",
                                      $value, 
                                      eval("\$json->${value}")
                                  );
    }
}

sub getMetricNames
{
    my @metricNames = (
        "{precpu_stats}->{system_cpu_usage}",
        "{precpu_stats}->{cpu_usage}->{total_usage}",
        "{precpu_stats}->{cpu_usage}->{usage_in_kernelmode}",
        "{precpu_stats}->{cpu_usage}->{usage_in_usermode}",
        "{network}->{rx_dropped}",
        "{network}->{rx_packets}",
        "{network}->{tx_packets}",
        "{network}->{tx_dropped}",
        "{network}->{rx_bytes}",
        "{network}->{rx_errors}",
        "{network}->{tx_bytes}",
        "{network}->{tx_errors}",
        "{read}",
        "{memory_stats}->{max_usage}",
        "{memory_stats}->{usage}",
        "{memory_stats}->{stats}->{total_pgmajfault}",
        "{memory_stats}->{stats}->{inactive_file}",
        "{memory_stats}->{stats}->{pgpgin}",
        "{memory_stats}->{stats}->{total_writeback}",
        "{memory_stats}->{stats}->{pgmajfault}",
        "{memory_stats}->{stats}->{total_active_file}",
        "{memory_stats}->{stats}->{mapped_file}",
        "{memory_stats}->{stats}->{total_pgpgout}",
        "{memory_stats}->{stats}->{total_active_anon}",
        "{memory_stats}->{stats}->{total_pgfault}",
        "{memory_stats}->{stats}->{total_rss}",
        "{memory_stats}->{stats}->{writeback}",
        "{memory_stats}->{stats}->{total_pgpgin}",
        "{memory_stats}->{stats}->{hierarchical_memory_limit}",
        "{memory_stats}->{stats}->{inactive_anon}",
        "{memory_stats}->{stats}->{total_inactive_file}",
        "{memory_stats}->{stats}->{active_file}",
        "{memory_stats}->{stats}->{unevictable}",
        "{memory_stats}->{stats}->{total_mapped_file}",
        "{memory_stats}->{stats}->{active_anon}",
        "{memory_stats}->{stats}->{pgfault}",
        "{memory_stats}->{stats}->{total_cache}",
        "{memory_stats}->{stats}->{rss_huge}",
        "{memory_stats}->{stats}->{total_inactive_anon}",
        "{memory_stats}->{stats}->{pgpgout}",
        "{memory_stats}->{stats}->{total_unevictable}",
        "{memory_stats}->{stats}->{total_rss_huge}",
        "{memory_stats}->{stats}->{rss}",
        "{memory_stats}->{stats}->{cache}",
        "{memory_stats}->{limit}",
        "{memory_stats}->{failcnt}",
    );
    return @metricNames;
}
1;
