package IssuePrinter;

use strict;
use warnings;
use Term::ANSIColor;
use Term::ReadKey;

sub new {
    my $class = shift;

    my $self = {
        issues => [ @_ ],
        selected => 0
    };

    bless $self, $class;

    return $self;
}

sub clear {
    my ( $self ) = @_;

    print "\033[2J";
    print "\033[0;0H";

    return $self;
}

sub selectNext {
    my ( $self ) = @_;

    if ($self->{selected} + 1 >= scalar(@{ $self->{issues} })) {
        $self->{selected} = -1;    
    }

    $self->{selected} = $self->{selected} + 1;

    return $self;
}

sub selectPrevious {
    my ( $self ) = @_;

    if ($self->{selected} -1 < 0) {
        $self->{selected} = scalar(@{ $self->{issues} }) - 1; 
    } else {
        $self->{selected} = $self->{selected} - 1;
    }

    return $self;
}

sub printLine {
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    print "┌";
    for( $a = 0; $a < $wchar - 2; $a = $a + 1 ) {
        print "─";
    }
    print "┐";

    print "\n";
}

sub printEndLine {
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    print "└";
    for( $a = 0; $a < $wchar - 2; $a = $a + 1 ) {
        print "─";
    }
    print "┘";

    print "\n";
}

sub printBorder {
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    print "│";
    for( $a = 0; $a < $wchar - 2; $a = $a + 1 ) {
        print " ";
    }
    print "│";
    print "\n";
}

sub printMan {
    print 'COMMANDS', "\n";
    print ' q : to exit ', "\n";
    print ' s : to navigate to bottom ', "\n";
    print ' z : to navigate to top ', "\n";
    print ' r : to refresh issues list ', "\n";
    print ' o : open issues on your browser ', "\n";
    print ' c : copy url issue to clipboard ', "\n";
}

sub getCurrentIssue {
    my ( $self ) = @_;

    return @{ $self->{issues} }[$self->{selected}];
}

sub dynamic {
    my ( $self ) = @_;
    my @issues = @{ $self->{issues} };

    my %priorities = (
        'Urgent' => 'bold magenta',
        'High' => 'bold cyan',
        'Immediate' => 'bold red'
    );

    $self->printLine();
    
    my $index = 0;

    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    foreach (@issues) {
        $self->printBorder();
        my $priority = $_->{priority}->{name};
        my $cl = $priorities{$priority};

        print "| ";

        my $bg = "";

        if ($index == $self->{selected}) {
            $bg = "on_black";
        } 
        
        if (defined $cl) {
            $cl = "$cl $bg";
        } else {
            $cl = $bg;
        }

        $index = $index + 1;

        if (not $cl eq "") {
            print color($cl);
        }

        print sprintf "%-7s", '#' . $_->{id};

        print sprintf "%-10s", $priority;

        if (length($_->{subject}) > ($wchar - 17) ) {
            print substr($_->{subject}, 0, $wchar - 24);
            print "...";
        } else {
            print sprintf ("%-" . ($wchar - 21). "s", $_->{subject});
        }

        print color('reset');
        print " │";
        print "\n";
        
    }

    $self->printBorder();
    $self->printEndLine();

    print "\n";

    $self->printMan()
}

1;