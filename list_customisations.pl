#!/usr/bin/perl -w
use strict;
use lib '/opt/platform/interchange_hosting';
use ZealdCluster;
use ZealdUtil;
use Catalog;
use Data::Dumper;
use Getopt::Long;

my ($hide_archived);
GetOptions( 'hide-archived' => \$hide_archived );

my ($server, $arg) = @ARGV;

my $cluster = new ZealdCluster;

$cluster->{cluster_id} = $arg if $arg;
@catalogs = @{ $cluster->get_catalog_config() };

foreach (@catalogs) {
	next if ($hide_archived && $_->{archived});
	print "$_->{catalog_name}\t$_->{zes_server_name}" ;
	print " (disabled)" if $_->{disabled};
	print " (archived)" if $_->{archived};
	print "\n";
}