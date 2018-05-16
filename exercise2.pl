#!/usr/bin/perl -w
# exercise2.sh
# Print the full path or Zest catalog with catalog.cfg is greater than 2114 bytes

use warnings;
use strict;
use Data::Dumper;

my $root = "/srv/ic-catalogs";
$root = "/var/log";

opendir my $dh, $root
  or die "$0: opendir: $_";

my $dir = <$root/*>;
# print "DIR:" . Dumper(\$dir);
print $dir . "\n";

# print "$_\n" foreach grep {-d "$root/$_" && ! /^\.{1,2}$/} readdir($dh);

# foreach my $dir grep {-d "$root/$_" && ! /^\.{1,2}$/} readdir($dh) {
# 	print "$_\n";
# }