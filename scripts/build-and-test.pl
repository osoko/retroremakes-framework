use strict;
use warnings;

use Getopt::Long;

our $blitzmaxPath;
our $binPath;
our $modulePath;

sub compileAndRunTests
{
	my ($module) = @_;
	
	my $testsDirectory = "$modulePath/$module/Tests";
	
	# Check that the module actually has some tests
	if (-e "$testsDirectory/Main.bmx")
	{
		my $prefix = "test-$module";
		
		print "Building tests for module: $module\n";
		
		runCommand ("$binPath/bmk makeapp -t gui -o $testsDirectory/$prefix.debug.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -r -t gui -o $testsDirectory/$prefix.release.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -h -t gui -o $testsDirectory/$prefix.debug.mt.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -h -r -t gui -o $testsDirectory/$prefix.release.mt.exe $testsDirectory/Main.bmx");		
		
		print "Running tests for module: $module\n";
		
		print "Singled-threaded debug build\n";
		runCommand ("$testsDirectory/$prefix.debug.exe");
	}
	else
	{
		print "Module $module has no tests defined.\n";
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
	
	print "Running command: $cmd\n";

	my $returnCode = system ($cmd);
	
	if ($returnCode)
	{
		$returnCode = $returnCode >> 8;
		print "$cmd exited with code: $returnCode";
		exit $returnCode;
	}
}



if (@ARGV > 0)
{
    GetOptions ('blitzmax=s' => \$blitzmaxPath);
}

unless ($blitzmaxPath)
{
	$blitzmaxPath = $ENV{BLITZMAX};
}

if (-d $blitzmaxPath)
{
	$binPath = $blitzmaxPath . "/bin";
	$modulePath = $blitzmaxPath . "/mod/retroremakes.mod";
	
	print "Using BlitzMax directory: $blitzmaxPath\n";
    
	print "\nBuilding modules...\n\n";
    
	# Build single-threaded debug and release versions of the modules
	runCommand ("$binPath/bmk makemods -a retroremakes");
    
	print "\nCompiling and running unit tests...\n\n";
    
	my @modules = findAllModules ($modulePath);
    
	foreach my $module (@modules)
	{
		compileAndRunTests ($module);
	}

	exit 1
}
else
{
	print "No BlitzMax path.";
	exit 1;
}

