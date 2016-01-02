=comment
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# This script is developed & maintained by Tyagraj Keer.  In case of any queries, issues please contact tyagraj@gmail.com
@@@@@@@@@@@@@Strictly avoid any edits to any of the script files -->> this might break any funtionality & DEBUS/ ISSUE support will not be provided in such cases@@@@@@@@@
#--------------------------------------------------------------------Thanks for using our script------------------------------------------------------------------------#
=cut

use strict;
use warnings;
use 5.14.2;
use autodie; # don't need to check the output of opendir now
use Term::ReadKey;
use Cwd 'abs_path';
use Cwd qw();
use Path::Class qw( file );
use File::chdir;
use File::Copy;
use Win32::Sound;
use Win32::OLE qw(in);
my $dir = ".";
my $file ="";
my $key;
my $oisf="";
my $odlf="";
my $tisf="";
my $tdlf="";
my $cmd="";
my $part1 = "";
my $part2 = "";
my $part3 = "";
my $part4 = "";
my $part5 = "";
my $part6 = "";
my $part7 = "";
my $part8 = "";
my $part9 = "";
my $part10 = "";
my $new_dir="qlat_combined";
my $folderpath_qlat_combined ="";
my $folderpath ="";
# my $sleept ;
my $pname = "";
my $default = 450;
my $max = 1201;
my $i = 0;

print "***********************************************************************************************\n";
print "This Program will combine .dlf & .isf files from Originator & Target in qlat_combined folder \n";
print "#######DO NOT manually COPY/MOVE/DELETE/RENAME any files folder during this operation########\n";
print "***********************************************************************************************\n\n";
sleep 5;

$SIG{INT} = 'handleit';

sub handleit {
  print "\n\n";
  print "Abnormal Exit attempted, consider deleting newly created folders\/sub-olders qlat\_combined and qlat\_input and try again....";
  exit(1);
}


sub qcct_qlat {

{
		opendir my($dirhandle), $dir;
		for( readdir $dirhandle ){ # sets $_
			when(-d $_ ){ next } # skip directories
			when(/^[.]/){ next } # skip dot-files

			when((/(.+)[.]isf/)&&((/orig/)||(/ORIG/)||(/Orig/))){$oisf=$_} 	
	
			when((/(.+)[.]isf/)&&((/targ/)||(/TARG/)||(/Targ/))){$tisf=$_}
	 
			when((/(.+)[.]dlf/)&&((/orig/)||(/ORIG/)||(/Orig/))){$odlf=$_}

			when((/(.+)[.]dlf/)&&((/targ/)||(/TARG/)||(/Targ/))){$tdlf=$_}

				}
		}
 
 print "Originator_isf -($oisf)\n";	
 print "Target_isf -($tisf)\n";
 print "Originator_dlf -($odlf)\n";	
 print "Target_dlf -($tdlf)\n";

 my $oisf_path = abs_path($oisf);
 #print "current working - $oisf_path ";
 my $tisf_path = abs_path($tisf);
 #print "current working - $tisf_path ";
 my $odlf_path = abs_path($odlf);
 #print "current working - $odlf_path ";
 my $tdlf_path = abs_path($tdlf);
 #print "current working - $tdlf_path ";
 
 print "\n";
 
 my $folderpath = Cwd::cwd();
 print "Folder path is $folderpath\n";

		{
		#Creating directory for QLAT input

		my $qlat_dir = "qlat_input";
		unless(mkdir($qlat_dir, 0755)) {
		die "Unable to create $qlat_dir\n";
			}
		} 

 
 chdir ('qlat_input')|| die "Error in opening directory, please check QCCT installation...!!\n";
 my $folderpath_qlat = Cwd::cwd();
 print "Folder path for QLAT is $folderpath_qlat\n";
 
 print "\n";
 print "initiating QCCT for Originator & Target combining..!!\n";

  
	{ 
		{
			if (-d "C:/Program Files (x86)/") {
			# OS is win7
			chdir ('C:/Program Files (x86)/Qualcomm/QChat/QCCT/bin') || die "Error in opening directory, please check QCCT installation...!!\n";
				}
			else {
			# OS is Winxp
			chdir ('C:/Program Files/Qualcomm/QChat/QCCT/bin') || die "Error in opening directory, please check QCCT installation...!!\n";
				}	
		}
		
		
		{
  
		#initiating QCCT for originator
		my $cmd1="QCCT.exe -i $oisf_path $odlf_path -o $folderpath_qlat";
		system("start cmd.exe /c $cmd1")
		}
   
		{
		#initiating QCCT for Target
		my $cmd2="QCCT.exe -i $tisf_path $tdlf_path -o $folderpath_qlat";
		system("start cmd.exe /c $cmd2")
		}
			
		sleep 5;

			qcct_check:
			sub matching_processes {
			my	$pattern = "QCCT.exe";

		#	print "pattern is $pattern \n";
			
			my $objWMI = Win32::OLE->GetObject('winmgmts://./root/cimv2');
			my $procs = $objWMI->InstancesOf('Win32_Process');

			my @hits;
			foreach my $p (in $procs) {
				push @hits => [ $p->Name, $p->ProcessID ]
				if $p->Name =~ /$pattern/;				
					}

				wantarray ? @hits : \@hits;
				}

			#print $_->[0], "\n" for matching_processes qr/^/;
			 ($pname = $_->[0]), for matching_processes qr/^/;

			#print " pname is $pname\n";
		if (($pname ne "")&&($pname eq "QCCT.exe"))
			{#print "QCCT is running....!!!\n";
			$pname = "";
			goto qcct_check;
			}
		else 
			{#print "free to start QCCT for next logset...!!!\n";
			}
		
	}
	
	

print "Combining Originator & Target logs ...\n";
print "***************************************************************\n";
sleep 2;

	{
		chdir ("$folderpath_qlat");
 
	print "Output file >>>> $_\n" for grep{ -f } glob("{*,}.isf");
	print "***************************************************************\n\n\n";

	sleep 2;
 
	system("cd ../../");
#	print "Press any key to EXIT\n";
		}
 
#	{use Term::ReadKey; 
#	ReadMode('cbreak'); 
#	$key = ReadKey(0); 
#	ReadMode('normal');
#	}
  
}

=comment
print "*************************************************************************************************\n";
print "For Avg\. 1\.2GB isf , Avg\.2kb dlf \- recommeded 600 sec \(minimum~450 & max~1200) Enter \>Default\n";
print "*************************************************************************************************\n";

sleepenter:
reenter:

print "Select proper Sleep time intervel \-\ to select Default value <450 sec>\>";
	{
	$sleept =  <STDIN>;
	chomp ($sleept);
	$sleept =~ s/[\n\r\f\t]//g;
	}
	
	
		{
		if ($sleept =~ /^[0-9]+$/) {
		goto ok;
			}
		else {goto nok;
			}
		}
	
nok:
print "\n Invalid Input Entered...!!\n";
goto reenter;

ok:	
		if ($sleept < $default) 
		{ print "\n sleept = $sleept\n";
		$sleept = 450;
		print "\n\n ....taking Default value...!!!\n\n";
		goto stepout;
		}
	 
		if ($sleept > $max)
		{goto sleepenter;
		print "\n\n entered time value too high, please enter lesser value & reconfirm !!!\n\n"; 
		} 
	
stepout:
print "\n\n default is $default max is $max sleept is $sleept\n\n";
=cut

	{
		my $folderpath = Cwd::cwd();
		print "Folder path is $folderpath\n";
		{
		#Creating directory for storing qlat input logs
		unless(mkdir($new_dir, 0755)) {
		die "Unable to create $new_dir\n"
			}
		my $folderpath = Cwd::cwd();
		}
 
		{
		chdir("$folderpath/qlat_combined") || die "Error in opening directory please check QLAT installation & folders ..!!\n";
		my $folderpath_qlat_combined = Cwd::cwd();
		print "************************************************************************\n";
		print "Created QLAT_combined folder at $folderpath_qlat_combined\n";
		print "************************************************************************\n";
		}
 

		chdir("../") || die "Error in going to Root directory ..!!\n";
		#debug#print "...Now back in Root $folderpath\n";
	}
  
	{
		my $file ="qcct_qlat.pl";
 
		opendir my($dirhandle), $dir;
		for( readdir $dirhandle ){ # sets $_
    
		when(/^[.]/){ next } # skip dot-files
		when (/(.+)[.]pl/) {next} # skip perl files
		when ((/(.+)[.]zip/)||(/(.+)[.]rar/)||(/(.+)[.]exe/)) {next} # ignore zip, rar files 
		
	#print "$_ \n";
	
		when(((/PART1/)||(/part1/)||(/Part1/))){$part1=$_}
		
		when(((/PART2/)||(/part2/)||(/Part2/))){$part2=$_} 
	 
		when(((/PART3/)||(/part3/)||(/Part3/))){$part3=$_} 

		when(((/PART4/)||(/part4/)||(/Part4/))){$part4=$_}
	
		when(((/PART5/)||(/part5/)||(/Part5/))){$part5=$_}
		
		when(((/PART6/)||(/part6/)||(/Part6/))){$part6=$_}
		
		when(((/PART7/)||(/part7/)||(/Part7/))){$part7=$_} 

		when(((/PART8/)||(/part8/)||(/Part8/))){$part8=$_}
	
		when(((/PART9/)||(/part9/)||(/Part9/))){$part9=$_}
		
		when(((/PART10/)||(/part10/)||(/Part10/))){$part10=$_}
				
			}
 
 my $folderpath = Cwd::cwd();
 #debug#print "Folder path is $folderpath\n\n";
 print "\n";

	#print "part1 is $part1\n";
		#{
		#$cmd="perl $file ";
		#}
 
		#$part1 =~ s{.[^.]+$}{};
		{copy($file, "$part1")} 
		print "Processing log bucket in $part1\n";
		{chdir ("$part1");
		#system("start cmd.exe /c $cmd");
		qcct_qlat();
		#sleep ($sleept);
		}
  
  
		system("cd ../");
		#$part2 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part2")}
		print "Processing log bucket in $folderpath/$part2\n";
		{chdir ("$folderpath/$part2");
		
			{if ($part2 ne "")
					{qcct_qlat();
		#	sleep ($sleept);
					}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
  
		system("cd ../");
		#$part3 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part3")}
		print "Processing log bucket in $folderpath/$part3\n";
		{chdir ("$folderpath/$part3");

			{if ($part3 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
  
		system("cd ../");
		#$part4 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part4")}		
		print "Processing log bucket in $folderpath/$part4\n";
		{chdir ("$folderpath/$part4");
		
			{if ($part4 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
   
		system("cd ../");
		#$part5 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part5")}
		print "Processing log bucket in $folderpath/$part5\n";
		{chdir ("$folderpath/$part5");

			{if ($part5 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
	
	   system("cd ../");
		#$part6 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part6")}
		print "Processing log bucket in $folderpath/$part6\n";
		{chdir ("$folderpath/$part6");
		
			{if ($part6 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
	
	
		   system("cd ../");
		#$part7 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part7")}
		print "Processing log bucket in $folderpath/$part7\n";
		{chdir ("$folderpath/$part7");
		
			{if ($part7 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
	
	
		   system("cd ../");
		#$part8 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part8")}
		print "Processing log bucket in $folderpath/$part8\n";
		{chdir ("$folderpath/$part8");
		
			{if ($part8 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
	
	
		   system("cd ../");
		#$part9 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part9")}
		print "Processing log bucket in $folderpath/$part9\n";
		{chdir ("$folderpath/$part9");
		
			{if ($part9 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";
	
	
		   system("cd ../");
		#$part10 =~ s{.[^.]+$}{};
		{copy($file, "$folderpath/$part10")}
		print "Processing log bucket in $folderpath/$part10\n";
		{chdir ("$folderpath/$part10");
		
			{if ($part10 ne "")
			{qcct_qlat();
		#	sleep ($sleept);
			}
			else	
				{print "...No Log Bucket.. skiping to next...!!!"; 
				}
			sleep 1;
			}
		}
		print "\n";

   }
   
   print "**************************************************************************\n";
   print "Combining logs completed, Praparing to MOVE Output files for qlat_combined\n";
   print "**************************************************************************\n";
=comment   
   system("copy $part1\\qlat_input\\*\.isf qlat_combined");
   system("copy $part2\\qlat_input\\*\.isf qlat_combined");
   system("copy $part3\\qlat_input\\*\.isf qlat_combined");
   system("copy $part4\\qlat_input\\*\.isf qlat_combined");
   system("copy $part5\\qlat_input\\*\.isf qlat_combined");
   system("copy $part6\\qlat_input\\*\.isf qlat_combined");
=cut   
   system("move $part1\\qlat_input\\*\.isf qlat_combined");
   		{if ($part2 eq "")
			{goto three;
			}
		}
   system("move $part2\\qlat_input\\*\.isf qlat_combined");
   three:
      	{if ($part3 eq "")
			{goto four;
			}
		}
   system("move $part3\\qlat_input\\*\.isf qlat_combined");
   four:
         {if ($part4 eq "")
			{goto five;
			}
		}
   system("move $part4\\qlat_input\\*\.isf qlat_combined");
    five:
         {if ($part5 eq "")
			{goto six;
			}
		}
   system("move $part5\\qlat_input\\*\.isf qlat_combined");
     six:
         {if ($part6 eq "")
			{goto seven;
			}
		}
   system("move $part6\\qlat_input\\*\.isf qlat_combined");
     seven:
         {if ($part7 eq "")
			{goto eight;
			}
		}
   system("move $part7\\qlat_input\\*\.isf qlat_combined");
     eight:
         {if ($part8 eq "")
			{goto nine;
			}
		}
	system("move $part8\\qlat_input\\*\.isf qlat_combined");
     nine:
         {if ($part9 eq "")
			{goto ten;
			}
		}
   system("move $part9\\qlat_input\\*\.isf qlat_combined");
	 ten:
         {if ($part10 eq "")
			{goto done;
			}
		}
   system("move $part10\\qlat_input\\*\.isf qlat_combined");
	done:
 #  sleep ($sleept/=2.5);
   
   print "************************************************************\n";
   print "Combining & Moving files completed, Press any key to PROCEED\n";
   print "************************************************************\n";
 	#Wake up dude the combining is done...!!!
	while($i < 20)
	{
	Win32::Sound::Volume('100%');
	Win32::Sound::Play("tada.wav");
	Win32::Sound::Stop();
	sleep 0.5; 
	$i++;
	}
 
 {use Term::ReadKey; 
	ReadMode('cbreak'); 
	my $key = ReadKey(0); 
	ReadMode('normal');
 }
