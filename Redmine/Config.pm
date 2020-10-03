package Config;

sub new {
    my $class = shift;

    my $self = {
        url => shift,
        token => shift,
        username => shift,
    };

    bless $self, $class;

    return $self;
}

1;