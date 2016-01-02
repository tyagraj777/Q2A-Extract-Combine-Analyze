=comment
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# This script is developed & maintained by Tyagraj Keer . In case of any queries, issues please contact tyagraj@gmail.com
@@@@@@@@@@@@@Strictly avoid any edits to any of the script files -->> this might break any funtionality & DEBUG/ ISSUE support will not be provided in such cases@@@@@@@@@
#--------------------------------------------------------------------Thanks for using our script------------------------------------------------------------------------#
=cut

use strict;
use warnings;
use 5.6.1;
use autodie; # don't need to check the output of opendir now
# my $zipname = "";
my $rarname = "";
my $dir = ".";
my $iszip="";
my $count=0;
my $dircount=0;


$SIG{INT} = 'handleit';
sub handleit {
  print "Abnormal Exit attempted, consider deleting newly created folders and try again....!!";
  exit(1);
}


#setting Winrar variable
 {
# $zip7 ='set path="C:\Program Files\7-Zip\";%path%';
 
my $cmd1='set path\=\"C\:\\Program Files\\7\-Zip\\\"\;\%path\%\"\;';
 
 system("$cmd1");
  }
  
 print "***************************************************************************\n"; 
 print "Make sure the formats supported by 7z like \.zip or \.rar files for logset\n";
 print "Need to set 7zip  Environment-path , make sure you have it installed in PC\n";
 print "You can download 7zip software form \\sun\\dist_softwares\\7-Zip\\ locaion\n";
 print "***************************************************************************\n";
 

 {
		opendir my($dirhandle), $dir;
		for( readdir $dirhandle ){ # sets $_
	#when (/^[.]/){ next } # skip dot-files

		if ((/(.+)[.]rar/)||(/(.+)[.]zip/)) {$dircount++}
	
		if((/(.+)[.]rar/)||(/(.+)[.]zip/)){$rarname=$_} 
 
		{
			#Creating directory from rar files
			my $new_dir = "$rarname";
			$new_dir =~ s{.[^.]+$}{};
			{$count++}
			{
			if ($count > $dircount) 
			{die "\n All $dircount files Extracted..!!!\n"} 
	
			}
			unless(mkdir($new_dir, 0755)) {
			die "Unable to create $new_dir\n"
			}
	 
			{
			{ system("7z e $rarname -o$new_dir")}

			}

		}
 
	}
 
 }
