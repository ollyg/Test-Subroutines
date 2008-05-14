#!perl -Tw

use Test::More tests => 1;

# Test for successful module load

BEGIN {
    use_ok( 'Test::GlassBox::Heavy' );
}

diag( "Testing Test::GlassBox::Heavy $Test::GlassBox::Heavy::VERSION, Perl $], $^X" );
