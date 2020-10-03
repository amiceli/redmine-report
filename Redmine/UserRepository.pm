package UserRepository;

sub new {
    my $class = shift;

    my $self = {
        api => shift,
        username => shift,
    };

    bless $self, $class;

    return $self;
}

sub getUserId {
    my ( $self ) = @_;
    my $endpoint = '/users.json?name=' . $self->{username};

    my $response = $self->{api}->load($endpoint);
    my $userId = $response->{users}[0]->{id};

    if (not defined $userId) {
        die "Sorry user not found."
    }
    
    return $userId;
}

1;