package Api;

use HTTP::Request;
use LWP::UserAgent;
use JSON;

sub new {
    my $class = shift;

    my $self = {
        config => shift,
    };

    bless $self, $class;

    return $self;
}

sub load {
    my ( $self, $endpoint ) = @_;
    my $url = $self->{config}->{url} . '/' . $endpoint;

    my $header = [ 'X-Redmine-API-Key' => $self->{config}->{token} ];
    my $r = HTTP::Request->new('GET', $url, $header);

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($r);

    if ($response->is_success) {
        return decode_json $response->decoded_content;
    } else {
        die $response->status_line;
    }
}

1;