#!/usr/bin/perl

use Test::GlassBox::Heavy qw(load_subs);

# set up any globals to match those in your Perl program
my $global = 'foo';

load_subs( $perl_program_file );
# subs from $perl_program_file are now available for calling directly

load_subs( $perl_program_file, $namespace );
# subs from $perl_program_file are now available for calling in $namespace
