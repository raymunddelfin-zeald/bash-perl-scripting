use strict;
use warnings;
use 5.010;
use Data::Dumper;

use Getopt::Long;

my ($hide_archived);
GetOptions( 'hide-archived' => \$hide_archived );

my $path = shift || "/mnt/d/Projects/src/ic-catalogs";
my $path_len = length($path) + 1;
my %customize;

my @sites = ('site3', 'site2', 'site1');
my @zest_folders = ('components', 'pages', 'logic');

foreach my $site (@sites) {
    traverse($path, $site);
}

sub traverse {
    my ($root, $site) = @_;

    # say "$site ~ $root";

    return if not -d $root;
    opendir my $dh, $root or die;
    while (my $dir = readdir $dh) {
        next if $dir eq '.' or $dir eq '..';

        # holds current directory
        my $current = "$root/$dir";

        $current =~ /$site\/(.+)/;
        if ($1) {
            print "folder: $1 ~ $current \n";

            my @custom = split /\//, $1;

            # add seen custom component to list
            if (scalar @custom > 1 && $custom[0] eq 'components') {

                # Count files in current directory
                # Note: might slow down process
                my $countFiles = 0;
                $countFiles = `tree -L 1 "$current" | tail -n 1 | cut -d " " -f 3`;

                my $component = $1;
                $component =~ /components\/(.+)/;

                # only add list if folder contain(s) a file
                if ($countFiles >= 1) {
                    $customize{$1} += 1;
                }
            } elsif ( grep(/$custom[0]/, q|logic pages|) ) {
                # only add files
                $customize{$1} += 1 unless (-d "$root/$dir");
            }
        }

        if (-d "$root/$dir") {
            # travese only to current site
            if ( $current =~ /ic-catalogs\/$site/ ) {
                # call traverse if current item is directory
                traverse("$root/$dir", $site);
            }
        }
    }
    close $dh;
    return;
}

print "\nCustomize: " . Dumper(\%customize);