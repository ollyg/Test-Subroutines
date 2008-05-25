#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

#use lib '../lib';
use Test::GlassBox::Heavy qw(load_subs get_subref);

my $i = 5;

load_subs('./src.pl', 'Bar::Baz', {system => sub { print "system! @_\n" }});

#my $sub = get_subref('doit');
#$sub->();
&Bar::Baz::doit;

