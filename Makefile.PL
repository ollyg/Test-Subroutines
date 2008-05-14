use 5.008004;
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile(
    NAME              => 'Test::GlassBox::Heavy',
    VERSION_FROM      => 'lib/Test/GlassBox/Heavy.pm', # finds $VERSION
    PREREQ_PM         => {
        Devel::LexAlias => 0,
        PadWalker => 0,
        Devel::Symdump => 0,
        File::Slurp => 0,
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT       => 'Non-invasive testing of subroutines within Perl programs',
       AUTHOR         => 'Oliver Gorwits <oliver.gorwits@oucs.ox.ac.uk>') : ()),
);
