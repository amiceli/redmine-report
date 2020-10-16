package IssuePrinter;

use strict;
use warnings;
use Term::ANSIColor;
use Term::ReadKey;
use feature 'state';

state $SIZE = 30;

sub new {
    my $class = shift;

    my $self = { issues => [@_], };

    bless $self, $class;

    return $self;
}

sub printPadding {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();
    my $padding = ( $wchar - ( $wchar - $SIZE ) ) / 2;

    for ( $a = 0 ; $a < $padding ; $a = $a + 1 ) {
        print " ";
    }
}

sub printLine {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    $self->printPadding();

    print "┌";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        print "─";
    }
    print "┐";

    print "\n";
}

sub printEndLine {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    $self->printPadding();

    print "└";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        print "─";
    }
    print "┘";

    print "\n";
}

sub printBorder {
    my $self    = shift;
    my $minimal = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    $self->printPadding();

    print "│";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        print " ";
    }
    print "│";
    print "\n";
}

sub display {
    my $self   = shift;
    my @issues = @{ $self->{issues} };

    my %priorities = (
        'Urgent'    => 'bold magenta',
        'High'      => 'bold cyan',
        'Immediate' => 'bold red',
        'Normal' => 'bold magenta',
    );

    $self->printLine();

    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    foreach (@issues) {
        $self->printBorder();

        my $priority = $_->{priority}->{name};
        my $cl       = $priorities{$priority};

        $self->printPadding();
        print "| ";

        if ( defined $cl) {
            print color($cl);
        }

        print sprintf "%-7s", '#' . $_->{id};

        print sprintf "%-10s", $priority;

        print (printf "%.*s", ($wchar - $SIZE - 20), $_->{subject});

        print color('reset');
        print " │";
        print "\n";
    }

    $self->printBorder();
    $self->printEndLine();

    print "\n";
}

1;
