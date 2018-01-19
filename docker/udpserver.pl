#!/usr/bin/perl

use IO::Socket::INET;
use Getopt::Long;
use JSON;
use Time::Local;

my $port = 5000;
GetOptions ('port=i' => \$port);

my $sock = new IO::Socket::INET (
               LocalPort => $port,
               Proto     => 'udp',
             ) or die "ERROR: Could not create socket at port $port: $!\n";

print "Listening on $port/udp\n";

my $container = $ENV{CONTAINER};
my $hostname  = $ENV{HOSTNAME};

$| = 1;

while ($sock->recv($newmsg, 2048)) {

  my ($day, $month, $year, $hour, $minute, $msg);
  if ($newmsg =~ m,^\[(\d{2})/(\d{2})/(\d{4})\s(\d{2}):(\d{2})\]\s+(.*),) {
    ($mday, $mon, $year, $hour, $min, $msg) = ($1, $2, $3, $4, $5, $6);
  }

  my ($port, $ipaddr) = sockaddr_in($sock->peername);
  $rhost = gethostbyaddr($ipaddr, AF_INET);

  print "Received $newmsg from $rhost:$port\n";

  my $epoch = timelocal('00', $min, $hour, $mday, $mon, $year);

  my %hash = (
              'timestamp' => $epoch,
              'hostname'  => $hostname,
              'container' => $container,
              'message'   => $msg
             );

  my $json = encode_json(\%hash);

  print "Sending $json\n";

  $sock->send($json);

} 

die "recv: $!";

__END__
