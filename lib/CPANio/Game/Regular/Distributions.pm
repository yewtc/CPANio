package CPANio::Game::Regular::Distributions;

use strict;
use warnings;

use CPANio;
use CPANio::Game::Regular;
our @ISA = qw( CPANio::Game::Regular );

# PRIVATE FUNCTIONS

sub compute_author_bins {
    my ( $class, $since ) = @_;
    my %bins;
    my $latest_release;
    my $releases = $class->get_releases;
    my %seen;
    while ( my $release = $releases->next ) {
        my $author = $release->cpanid;
        $latest_release = $release->date;
        next if $seen{$author}{ $release->dist }++;
        my $dt = DateTime->from_epoch( epoch => $latest_release );
        my $i;
        $bins{$_}{$author}++
            for grep $i++ % 2, CPANio::Bins->datetime_to_bins($dt);
    }

    return ( \%bins, $latest_release );
}

# CLASS METHODS
sub game_name { 'distributions' }

sub resultclass_name { 'DistributionBins' }

sub periods {qw( month )}

1;

__END__

=head1 NAME

CPANio::Game::Regular::Distributions - Compute the boards for regular distributions

=head1 SYNPOPSIS

    use CPANio::Game::Regular::Distributions;

    CPANio::Game::Regular::Distributions->update;

=head1 DESCRIPTION

This board computes the chains for "regular distributions" game, i.e. authors
who publish a new CPAN distribution (for them) at least once every period.

=head2 Periods

The boards for this game are computed for the following periods:
month.

=head1 AUTHOR

Philippe Bruhat (BOOK), based on the work of Christopher J. Madsen (CJM)
and Neil Bowers (NEILB).

=cut
