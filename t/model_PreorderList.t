use Test2::V0;

use Coocook::Model::PreorderList;

use lib 't/lib';
use TestDB;

my $db = TestDB->new;

my $project = $db->resultset('Project')->find(1);

ok my $list = Coocook::Model::PreorderList->from_project($project);

use Data::Dumper;
$Data::Dumper::Maxdepth = 2;
$Data::Dumper::Sortkeys = 1;
diag Dumper($list);

done_testing;
