#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

use lib './lib';
use Test::GlassBox::Heavy qw(load_subs get_subref);

my $i = 5;

load_subs('/home/oliver/tmp/src.pl', 'Bar', 1);

#my $sub = get_subref('doit');
#$sub->();
&doit;

