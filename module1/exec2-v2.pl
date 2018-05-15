#!/usr/bin/perl -w
# Usage: perl exec2.pl /srv/ic-catalogs

use strict;
use warnings;
use 5.010;

my $max_size = 2114;
my $path = shift || '.';
 
traverse($path);
 
sub traverse {
    my ($root) = @_;
 
    return if not -d $root;
    opendir my $dh, $root or die;

    # Read the directories
    while (my $sub = readdir $dh) {

    	# exclude dots and on pass the catalog.cfg
        next if $sub eq '.' or $sub eq '..' or $sub ne 'catalog.cfg';

        my $catalog = "$root/$sub";
        
		# Get file size
		my $size = -s $catalog;
		if ($size > $max_size) {
			# print only the files are more than $max_size
			say $catalog . " ~ " . $size;
		}
    }

    # close directory
    close $dh;
    return;
}