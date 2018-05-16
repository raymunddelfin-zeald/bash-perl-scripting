#!/usr/bin/perl -w

use warnings;
use strict;
use Data::Dumper;
use experimental 'smartmatch';

my $root = "/mnt/d/Projects/src/ic-catalogs";
my $root_len = length($root) + 1;
my %seen;
my %customize;

my @sites = ('site1', 'site2', 'site3');
my @zest_folders = ('components', 'pages', 'logic');

foreach my $site (@sites) {
    my $pwd = "$root/$site";
    opendir(DIR,"$pwd") or die "Cannot open $pwd\n";

    my @files = readdir(DIR);
    closedir(DIR);
    foreach my $file (@files) {
        next if $file =~ /^\.\.?$/;
        my $path = "$pwd/$file";

        # check if item is directory
        if (-d $path) {
            next if $seen{$path};
            $seen{$path} += 1;

            # add directory to costomize
            if ($file ~~ @zest_folders) {
                traverse($path, $site);
            }
        }
    }
}

sub traverse {
    my ($root, $site) = @_;
    my $site_len = length($site) + 1;

    opendir(DIR, "$root") or die "Cannot open $root\n";
    
    my @files = readdir(DIR);
    closedir(DIR);
    foreach my $file (@files) {
        next if $file =~ /^\.\.?$/;
        my $path = "$root/$file";

        # check if item is directory
        if (-d $path) {
            next if $seen{$path};
            $seen{$path} += 1;

            my $custom_path = substr($path, $root_len);
            $custom_path = substr($custom_path, $site_len);

            $customize{$custom_path} += 1;
            print "traverse $site: $path ~ " . $custom_path . "\n";
        }
    }
}

print "\nCustomize: " . Dumper(\%customize);