#! perl

use strict;
use warnings;

use Getopt::Long;

my $blitzmaxPath = $ENV{BLITZMAX};

my $binPath;
my $modulePath;

sub compileAndRunTests($) {
	my $module = shift;

	my $testsDirectory = "$modulePath/$module/Tests";
	my $testBinary;

	# Check that the module actually has some tests
	if ( -e "$testsDirectory/Main.bmx" ) {
		my $prefix = "test-$module";

		print "Building and running single-threaded tests for module: $module\n";

		# Build/run unit tests in single-threaded mode
		$testBinary = "$prefix.debug.exe";
		runCommand("$binPath/bmk makeapp -t console -o $testsDirectory/$testBinary $testsDirectory/Main.bmx");
		runCommand("$testsDirectory/$testBinary");

		print "\nBuilding and running multi-threaded tests for module: $module\n";

		# Build/run unit tests in multi-threaded mode
		$testBinary = "$prefix.mt.debug.exe";
		runCommand("$binPath/bmk makeapp -h -t console -o $testsDirectory/$testBinary $testsDirectory/Main.bmx");
		runCommand("$testsDirectory/$testBinary");

		print "\n";
	}
	else {
		print "No tests defined for module: $module\n";
	}
}

sub findAllModules($) {
	my $modulePath = shift;

	my @modules = ();

	if ( -d $modulePath ) {
		opendir( my $dir, $modulePath ) or die "Cannot open directory $modulePath: $!";

		my @allFiles = readdir($dir);

		closedir($dir);
		for my $testFile (@allFiles) {
			next if ( $testFile eq '.' || $testFile eq '..' );
			if ( -d "$modulePath/$testFile" ) {
				push @modules, $testFile;
			}
		}
	}

	return \@modules;
}

sub main() {
	GetOptions(
		'blitzmax=s'   => \$blitzmaxPath,
		'help|?|usage' => sub { showUsage() },
	);

	if ( defined $blitzmaxPath && -d $blitzmaxPath ) {
		$binPath    = "$blitzmaxPath/bin";
		$modulePath = "$blitzmaxPath/mod/retroremakes.mod";

		print "Using BlitzMax directory: $blitzmaxPath\n";
		print "\nBuilding modules...\n\n";

		# Build single-threaded debug and release versions of the modules
		runCommand("$binPath/bmk makemods retroremakes");

		# Now build mutli-threaded versions
		runCommand("$binPath/bmk makemods -h retroremakes");

		print "\nBuilding and running all tests...\n\n";

		for my $module ( @{ findAllModules($modulePath) } ) {
			compileAndRunTests($module);
		}
		print "\nAll tests ran successfully.\n";
		exit 0;
	}
	else {
		print "BlitzMax path not specified and BLITZMAX environment variable not set.\n";
		showUsage();
	}
}

sub runCommand($) {
	my $cmd = shift;

	my $returnCode = system($cmd);

	if ($returnCode) {
		$returnCode = $returnCode >> 8;
		print "$cmd exited with code: $returnCode\n";
		exit $returnCode;
	}
}

sub showUsage {
	print <<EOF;
	
    build-and-test: RetroRemakes Framework Build/Test Tool

    This tool builds all framework modules and then runs all unit tests that
    have been created for each module.
    
    usage:

        build-and-test --blitzmax C:\\Tools\\BlitzMax
  
    options:

	    --blitzmax      BlitzMax installation directory
	    --usage|help|?  This information

    Setting the BLITZMAX environment variable negates the need to use the
    --blitzmax option.
    
    If both the BLITZMAX environemnt variable and the --blitzmax command
    line option are used, the value specified on the command line takes
    precedence.  

EOF

	exit 1;
}

main();
