package Test::GlassBox::Heavy;

require Exporter;
@ISA       = qw(Exporter);
@EXPORT_OK = qw(load_subs get_subref);

use strict;
use warnings FATAL => 'all';

use Devel::LexAlias qw(lexalias);
use PadWalker qw(closed_over peek_my);
use Symbol qw(qualify_to_ref);
use Devel::Symdump;
use File::Slurp;
use Carp;

our $VERSION = 0.01;
# $Id$

sub load_subs {
    my $text = read_file( shift );
    my $callpkg = scalar caller(0);
    my $pkg  = shift || $callpkg;
    my $key = 'jei8ohNe';

    eval "package $pkg; sub $key { no warnings; $text }; 1;"
        or die $@;

    my %globals = %{ [peek_my(1)]->[0] };

    foreach my $qsub ( Devel::Symdump->functions($pkg) ) {
        (my $sub = $qsub) =~ s/^${pkg}:://;
        next if $sub eq $key;
    
        my @vars = keys %{ [closed_over \&{$main::{"${pkg}::"}{$sub}}]->[0] };
        foreach my $v (@vars) {
            croak "Missing lexical for \"$v\" required by \"$sub\""
                if !exists $globals{$v};
            lexalias(\&{$main::{"${pkg}::"}{$sub}} , $v, $globals{$v});
        }

        *{qualify_to_ref($sub,$callpkg)} = *{qualify_to_ref($sub,$pkg)}
            if defined shift;
    }

    return 1;
}

sub get_subref {
    my $sub = shift;
    my $pkg = shift || scalar caller(0);
    return \&{$main::{"${pkg}::"}{$sub}};
}

1;

__END__

=head1 NAME

Test::GlassBox::Heavy - Non-invasive testing of subroutines within Perl programs

=head1 VERSION

This document refers to version 0.01 of Test::GlassBox::Heavy

=head1 SYNOPSIS

 use Test::GlassBox::Heavy qw(load_subs);
 
 # set up any globals to match those in your Perl program
 my $global = 'foo';
 
 load_subs( $perl_program_file );
 # subs from $perl_program are now available for calling directly
 
 # OR
 
 load_subs( $perl_program_file, $namespace );
 # subs from $perl_program are now available for calling in $namespace

=head1 PURPOSE

You have a (possibly ancient) Perl program for which you'd like to write some
unit tests. The program code cannot be modified to accommodate this, and you
want to test subroutines but not actually I<run> the program. This module
takes away the pain of setting up an environment for this, so you can run the
subroutines in (relative) safety.

=head1 DESCRIPTION

If you have a Perl program to test, one approach is to run the program with
various command line options and environment settings and observe the output.
This might be called I<black box testing> because you're treating the program
as an opaque blob.

Some time later you need to refactor a part of the program, so you want to
move on and begin unit testing the subroutines in the program. This is tricky
to do without accidentally running the program itself. At this point you're
I<glass box testing> because you can inspect the internals of the program,
although you're not actually changing them.

This module takes a rather heavyweight approach to the above using some of
Perl's deep magic, such as the C<Devel::> and C<B::> namespace modules. It
stops the Perl program from being run, but allows you to call any subroutine
defined in the program. Essentially it turns the program into a package.

You'll need to set-up any environment the subroutines may need, such as global
lexical variables, and also be aware that side effects from the subroutines
will still occur (e.g. database updates).

=head1 USAGE

Load the module like so:

 use Test::GlassBox::Heavy qw(load_subs);

Then use C<load_subs()> to inspect your program and make available the
subroutines within it. Let's say your program is C</usr/bin/myperlapp>. The
simplest call exports the program's subroutines into your own namespace so you
can call them directly:

 load_subs( '/usr/bin/myperlapp' );
 # and then...
 $retval = &myperlapp_sub($a,$b);

If the subroutines happen to use global lexicals in the program, then you do
need to set these up in your own namespace, otherwise C<load_subs()> will
croak with an error message. Note that they must be lexicals - i.e. using
C<my>.

If you don't want your own namespace polluted, then load the subroutines into
another namespace:

 load_subs( '/usr/bin/myperlapp', 'Other::Place' );
 # and then...
 $retval = &Other::Place::myperlapp_sub($a,$b);

Finally, should you want it, you can have the subroutines exported to both
another namespace and your own, by passing a true value as a third argument:

 load_subs( '/usr/bin/myperlapp', 'Other::Place', 1 );

To be honest I'm not quite sure why I put that feature in.

=head1 CAVEATS

=over 4

=item *

You have to call the subroutines with leading C<&> to placate strict mode.

=item *

Warnings are disabled when the program is loaded, although strict mode remains
on.

=item *

You have to create any required global lexicals in your own namespace.

=back

=head1 BUGS

Oh, there are probably plenty. I was asked to hack this up for a colleague's
project, and I've not tested it thoroughly. The module certainly uses other
modules which have grave warnings about treading on Perl's toes with all this
deep magic.

There's another way to do this - much simpler and without needing the deep
magic modules. C<batman> from IRC put this together, here:
L<http://trac.flodhest.net/pm/wiki/ImportSubs>. There are pros and cons to
both methods.

=head1 SEE ALSO

=over 4

=item L<Code::Splice>

=back

=head1 REQUIREMENTS

Other than the standard contents of the Perl distribution, you will need:

=over 4

=item L<Devel::LexAlias>

=item L<PadWalker>

=item L<Devel::Symdump>

=item L<File::Slurp>

=back

=head1 AUTHOR

Oliver Gorwits C<< <oliver.gorwits@oucs.ox.ac.uk> >>

=head1 ACKNOWLEDGEMENTS

Some folks on IRC were particularly helpful with suggestions: C<batman>,
C<mst> and C<tomboh>. Thanks, guys!

=head1 COPYRIGHT & LICENSE

Copyright (c) The University of Oxford 2008. All Rights Reserved.

This program is free software; you can redistribute it and/or modify it under
the terms of version 2 of the GNU General Public License as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
St, Fifth Floor, Boston, MA 02110-1301 USA

=cut

