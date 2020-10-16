package IssueRepository;

sub new {
    my $class = shift;

    my $self = {
        api => shift,
        userId => shift,
        limit => shift,
    };

    bless $self, $class;

    return $self;
}

sub getIssues {
    my ( $self ) = @_;

    my $endpoint = '/issues.json?assigned_to_id=' . $self->{userId} . '&sort=priority:desc&limit=' . $self->{limit};
    my $response = $self->{api}->load($endpoint);

    my @issues = @{ $response->{issues} };

    return @issues;
}

1;