use inc::Module::Install 0.67;
perl_version '5.008001';
  
name        'Test-GlassBox-Heavy';
all_from    'lib/Test/GlassBox/Heavy.pm';

requires    'Devel::LexAlias' => 0;
requires    'PadWalker' => 0;
requires    'Devel::Symdump' => 0;
requires    'File::Slurp' => 0;

test_requires  'Test::More' => 0;
test_requires  'Test::Pod' => 0;
test_requires  'Test::Pod::Coverage' => 0;

WriteAll;

