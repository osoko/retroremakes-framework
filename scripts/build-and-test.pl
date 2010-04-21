use Getopt::Long;

our $blitzmaxPath;
our $binPath;
our $modulePath;

open (our $logFile, ">build-and-test.log");



sub compileAndRunTests
{
	my ($module) = @_;
	
	my $testsDirectory = "$modulePath/$module/Tests";
	
	# Check that the module actually has some tests
	if (-e "$testsDirectory/Main.bmx")
	{
		my $prefix = "test-$module";
		
		logAndPrint ("Building tests for module: $module\n");
		
		runCommand ("$binPath/bmk makeapp -t gui -o $testsDirectory/$prefix.debug.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -r -t gui -o $testsDirectory/$prefix.release.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -h -t gui -o $testsDirectory/$prefix.debug.mt.exe $testsDirectory/Main.bmx");
		runCommand ("$binPath/bmk makeapp -h -r -t gui -o $testsDirectory/$prefix.release.mt.exe $testsDirectory/Main.bmx");		
		
		logAndPrint ("Running tests for module: $module\n\n");
		
		logAndPrint ("Singled-threaded debug build\n");
		runCommand ("$testsDirectory/$prefix.debug.exe", 1);
		
		logAndPrint ("Singled-threaded release build\n");
		runCommand ("$testsDirectory/$prefix.release.exe", 1);
		
		logAndPrint ("Multi-threaded debug build\n");
		runCommand ("$testsDirectory/$prefix.debug.mt.exe", 1);
		
		logAndPrint ("Multi-threaded release build\n");
		runCommand ("$testsDirectory/$prefix.release.mt.exe", 1);				
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



sub logAndPrint
{
	my ($message) = @_;
	
	print "$message";
	logToFile ($message);	
}



sub logToFile
{
	my ($message) = @_;
	
	print $logFile "$message";
}



sub runCommand
{
	my ($cmd, $printToScreen) = @_;
	
	logToFile ("\nRunning command: $cmd\n");

	my $returnCode = system ($cmd);
	print "Return code: $?\n";
	
	#open (my $output, "$cmd 2>&1 |") or die "Can't run '$cmd'\n$!\n";
    #
    #while (<$output>)
    #{
    #	print $logFile $_;
    #	
    #	if ($printToScreen)
    #	{
    #		print $_;
    #	}
    #}
	#
    #close $output or die "Command failed: $? : $!";	
}





if (@ARGV > 0)
{
    GetOptions ('blitzmax=s' => \$blitzmaxPath);
}

if (-d $blitzmaxPath)
{
	$binPath = $blitzmaxPath . "/bin";
	$modulePath = $blitzmaxPath . "/mod/retroremakes.mod";
	
	logAndPrint "Using BlitzMax directory: $blitzmaxPath\n";
    
    logAndPrint "\nBuilding modules...\n";
    
    # Build single-threaded debug and release versions of the modules
	runCommand ("$binPath/bmk makemods retroremakes");
    
    # Build multi-threaded debug and release versions of the modules
	runCommand ("$binPath/bmk makemods -h retroremakes");
    
    logAndPrint "\nCompiling and running unit tests...\n";
    
    my @modules = findAllModules ($modulePath);
    
    foreach my $module (@modules)
    {
    	compileAndRunTests ($module);
    }
}
else
{
	logAndPrint "No BlitzMax path.";
	exit 1;
}

close ($logFile);   