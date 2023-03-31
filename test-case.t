use Test::Simple tests => 1;
use LWP::Simple;
use JSON qw/decode_json/;

my $url = 'http://localhost:8501/v1/models/mymodel:predict';
my $json = '{"instances": [[0.1, 0.2, 0.3, 0.4, 0.5]]}';

my $response = get($url);
my $decoded = decode_json($response);

ok($decoded->{predictions}->[0]->[0] == 0.2, 'prediction is correct');
