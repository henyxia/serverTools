#!/usr/bin/perl

package common;

use strict;
use warnings;

sub checkParameters
{
    my $params      = shift;
    my @paramList   = @_;

    foreach my $param (@paramList)
    {
        if(!$param)
        {
            return {
                type    => "MISSING PARAMETER",
                value   => $param,
            };
        }
    }

    return 0;
}

1;
