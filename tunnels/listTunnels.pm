#!/usr/bin/perl

package listTunnels;

use strict;
use warnings;

use Data::Dumper;

sub listTunnels
{
    my $config  = shift;
    my $host    = shift;

    my $hostname = $host || `hostname`;
    chomp $hostname;
    !$hostname and return {
        type    => "CONTEXT_ISSUE",
        value   => "Unable to resolve hostname",
    };

    my $configFile = "/root/data/config/$hostname/tunnels/config";

    open(my $configHandle, '<', $configFile)
        or return { 
            type    => "IO_ERROR",
            value   => $configFile,
        };

    my ($server, $nbline);
    while(my $line = <$configHandle>)
    {
        $nbline++;

        chomp $line;
        !$line and next;

        !$server and $line =~ /^\s+/
            and return {
                type    => 'INVALID_CONFIGURATION',
                value   => $nbline,
            };

        if(my ($srv) = $line =~ m/^Host\s+(.+)/)
        {
            $server = $srv;
            $config->{$server} = {};
            next;
        }

        if(my ($key, $value) = $line =~ 
            m/(LocalInt|LocalIp|RemoteInt|RemoteIp)\s+(.*)/)
        {
            $config->{$server}->{$key} = $value;
            next;
        }

        return {
            type    => 'INVALID_CONFIGURATION',
            value   => $nbline,
        };
    }

    return 0;
}

1;
