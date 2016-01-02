=comment
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# This script is developed & maintained by Tyagraj Keer. In case of any queries, issues please contact tyagraj@gmail.com
@@@@@@@@@@@@@Strictly avoid any edits to any of the script files -->> this might break any funtionality & DEBUS/ ISSUE support will not be provided in such cases@@@@@@@@@
#--------------------------------------------------------------------Thanks for using our script------------------------------------------------------------------------#
=cut

use strict;
use warnings;
use 5.10.1;
use autodie; # don't need to check the output of opendir now
use Cwd qw();
use Path::Class qw( file );
use File::chdir;
my $dir = ".";
my $new_dir="qlat_combined";
my $count =0;
my $isfcount =0;
my $folderpath_qlat_combined= "";
my $xmlcount =0;
my $xmlfile="";
my $num=0;
my $os =0;
my $file = "";
my $cdir = "";
my $qlatcfgfile = "";
my $command = "";
my $xml = "";

$SIG{INT} = 'handleit';

sub handleit {
  print "\n\n";
  print "Abnormal Exit attempted, Consider deleting Temp folder under qlat\_combined and ignore other error messages....";
  exit(1);
}


 print "Welcome to QLAT Analysis Program.....This will RUN QLAT on combine logs.\n";
 
 	if (-d "C:/Program Files (x86)/") {
    # OS is win7 
	$os =7;
	$qlatcfgfile = 'C:/Program Files (x86)/Qualcomm/QChat/QLAT/config/qlat.cfg';
	$cdir = 'C:\Program Files (x86)\Qualcomm\QChat\QLAT\config';
		}
		else 
		{
	$cdir = 'C:\Program Files\Qualcomm\QChat\QLAT\config';
	$qlatcfgfile = 'C:/Program Files/Qualcomm/QChat/QLAT/config/qlat.cfg';
		}
	
 
 my $folderpath = Cwd::cwd();
 print "Folder path is $folderpath\n";
 
 
		{
		opendir my($dirhandle), $dir;
		for( readdir $dirhandle ){ # sets $_
		when (/^[.]/){ next } # skip dot-file 
	
		when((/(.+)[.]rar/)||(/(.+)[.]zip/)){$count++}
			}
			print " No of compressed files \>\> $count\n";
		}
 
 
		{
		chdir ("$folderpath/qlat_combined") || die "Error in opening directory please check QLAT installation & folders ..!!\n";
		$folderpath_qlat_combined = Cwd::cwd();
		print "Folder path is $folderpath_qlat_combined\n";

			{ 
			  opendir my($dirhandle), $dir;
				for( readdir $dirhandle ){ # sets $_
				when (/^[.]/){ next } # skip dot-file 
				when(/(.+)[.]isf/){$isfcount++}
				}
			}
			print " No of qlat input \.isf files \>\> $isfcount\n";
		}
		print "******************************************************************\n";
		print " $_\n" for grep{ -f } glob("{*,}.isf");	
		print "******************************************************************\n";
		
=comment		
		{
		if($isfcount != 2*$count)
			{ die "Please check No of ISF files in $folderpath_qlat_combined";
			}	
		}
=cut
 
		if ($os != 7){
		print "Operating System is WinXP\n";
		print "******************************************************************\n";
		goto xpnext;
			}
		print "Operating System is Win$os\n";
		print "******************************************************************\n";
		xpnext:
		
			{
		print "Available Analysis files are ...\n";
		print "******************************************************************\n";
		sleep 0;
			}
		
		{
			

#		my $cdir = 'C:\Program Files (x86)\Qualcomm\QChat\QLAT\config';

	{
	
			{
		if (-e $qlatcfgfile) {
		goto FileExists;
			} 	
		else {
		#copy("qlat.cfg.win","qlat.cfg") or die "Copy qlat.cfg failed form qlat.cfg.win check qlat cfg folder: $!";
		chdir ("$cdir");
		system("copy qlat.cfg.win  qlat.cfg");
				}
			}
	}
	
		{
		chdir ("$cdir");
		#delete the line with DIR_SEARCH_DEPTH *
		system("perl -ni.bak -e \"print unless\/DIR\_SEARCH\_DEPTH\/\" qlat.cfg");
		#insert line with DIR_SEARCH_DEPTH = 8
			{
			open (MYFILE , '>>qlat.cfg');
			print MYFILE  "DIR_SEARCH_DEPTH = 8\n";
			close (MYFILE ); 
			}
		}
		
		FileExists:
		{
		chdir ("$cdir");
		#delete the line with DIR_SEARCH_DEPTH * it may be DIR_SEARCH_DEPTH =1
		system("perl -ni.bak -e \"print unless\/DIR\_SEARCH\_DEPTH\/\" qlat.cfg");
		#insert line with DIR_SEARCH_DEPTH = 8
			{
			open (MYFILE , '>>qlat.cfg');
			print MYFILE  "DIR_SEARCH_DEPTH = 8\n";
			close (MYFILE ); 
			}
		}
	
	sleep 3;
#	print "perl -pi.bak -e \'s\/DIR\_SEARCH\_DEPTH \=\/\(\.\+\)\/\/DIR\_SEARCH\_DEPTH \= 8\/\' qlat\.cfg";


    opendir(DIR, $cdir) or die $!;
	
    while ($file = readdir(DIR)) {

        # We only want files
        next unless (-f "$cdir/$file");

        # Use a regular expression to find files ending in .xml
        next unless ($file =~ m/\.xml$/);
		{$xmlcount++} {$num++}
		
        print "Sr no. $xmlcount $file \n";
	#	print "$num \n"
	
			}
	closedir(DIR);
		
			
	my @files =
   grep { -f }
   glob("*.xml");

# print "@files\n\n\n";
 
 reenter:
 print "############################################################\n";
 print "Select xml file you need to use, Enter no. for the file\n";
 print "############################################################\n";
 print "For Example for  file "; #For example
 print $files[0]; 
 print "  input 1 \n\n";
 #\@files\[0\] input 1 \n\n";
 

	{
	$xml =  <STDIN>;
	chomp ($xml);
				{
		if (($xml =~ /^[1-9]+$/) && ($xml <= $xmlcount)){
		goto ok;
			}
		else {goto nok;
			}
		}
#	$xml=$xml-1;
	$xml =~ s/[\n\r\f\t]//g;
	}
	
	
nok:
print "\n Invalid Input Entered...please Reenter!!\n";
goto reenter;

ok:
 print "############################################################\n";
 print "Using Analysis file  ";
 print $files[$xml-1]; 
 print "\n";
 print "############################################################\n";
 $xmlfile = $files[$xml-1];
		}
	
#going to start QLAT with selected analysis file

		{
		if (-d "C:/Program Files (x86)/") {
		# OS is win7
		chdir ('C:\Program Files (x86)\Qualcomm\QChat\QLAT\bin') || die "Error in opening directory please check QLAT installation ..!!\n";
		$command = my $cmd4="perl qlat.pl -c \"C\:\\Program Files \(x86\)\\Qualcomm\\QChat\\QLAT\\config\\qlat\.cfg\" -i $folderpath_qlat_combined -o $folderpath_qlat_combined  -a \"C\:\\Program Files \(x86\)\\Qualcomm\\QChat\\QLAT\\config\\$xmlfile\"";
		}
	else {
		# OS is Winxp
		chdir ('C:\Program Files\Qualcomm\QChat\QLAT\bin') || die "Error in opening directory please check QLAT installation ..!!\n";
		$command = my $cmd3="perl qlat.pl -c \"C\:\\Program Files\\Qualcomm\\QChat\\QLAT\\config\\qlat\.cfg\" -i $folderpath_qlat_combined -o $folderpath_qlat_combined  -a \"C\:\\Program Files\\Qualcomm\\QChat\\QLAT\\config\\$xmlfile\"";
			}	
		system("start cmd.exe /k $command")
		
		}
				
