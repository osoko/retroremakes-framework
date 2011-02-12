use strict;
use warnings;

use Getopt::Long;

our $blitzmaxPath;
our $binPath;
our $modulePath;
our $showUsage;



sub compileAndRunTests
{
	my ($module) = @_;
	
	my $testsDirectory = "$modulePath/$module/Tests";
	
	# Check that the module actually has some tests
	if (-e "$testsDirectory/Main.bmx")
	{
		my $prefix = "test-$module";
		
		print "Building and running tests for module: $module\n";
		
		runCommand ("$binPath/bmk makeapp -t console -o $testsDirectory/$prefix.debug.exe $testsDirectory/Main.bmx");
		runCommand ("$testsDirectory/$prefix.debug.exe");
		print "\n";
	}
	else
	{
		print "No tests defined for module: $module\n";
	}
}



sub findAllModules
{
	my ($modulePath) = @_;
	
	my @modules = ();
	
	if (-d $modulePath)
	{
		opendir (my $dir, $modulePath) or die ("Cannot open directory: $modulePath");
		
		my @allFiles = readdir ($dir);
		
		closedir ($dir);
		
		foreach my $testFile (@allFiles)
		{
			unless (($testFile eq '.') || ($testFile eq '..'))
			{
				if (-d "$modulePath/$testFile")
				{
					push @modules, $testFile;
				}
			}
		}
	} 
	
	return @modules;
}



sub runCommand
{
	my ($cmd) = @_;

	my $returnCode = system ($cmd);
	
	if ($returnCode)
	{
		$returnCode = $returnCode >> 8;
		print "$cmd exited with code: $returnCode\n";
		exit $returnCode;
	}
}



sub showUsage
{
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

   exit 1
}



if (@ARGV > 0)
{
    GetOptions ('blitzmax=s' => \$blitzmaxPath,
    			'help|?|usage' => \$showUsage);
}

unless ($blitzmaxPath)
{
	$blitzmaxPath = $ENV{BLITZMAX};
}

if ($showUsage)
{
	showUsage();
}
	
if (-d $blitzmaxPath)
{
	$binPath = $blitzmaxPath . "/bin";
	$modulePath = $blitzmaxPath . "/mod/retroremakes.mod";
	
	print "Using BlitzMax directory: $blitzmaxPath\n";
    
	print "\nBuilding modules...\n\n";
    
	# Build single-threaded debug and release versions of the modules
	runCommand ("$binPath/bmk makemods retroremakes");
    
    print "\nBuilding and running all tests...\n\n";

	my @modules = findAllModules ($modulePath);
    
	foreach my $module (@modules)
	{
		compileAndRunTests ($module);
	}

	print "\nAll tests ran successfully.\n";
	exit 0
}
else
{
	print "BlitzMax path not specified and BLITZMAX environemnt variable not set.\n";
	showUsage();
}
