use Test2::V0;

use Coocook::Model::PreorderList;

use lib 't/lib';
use TestDB;

my $db = TestDB->new;

my $project = $db->resultset('Project')->find(1);

is my $list = Coocook::Model::PreorderList->from_project($project) => array {
    item hash {
        field date  => object { call ymd => '1999-12-26' };
        field lists => array {
            item hash {
                field purchase_list => check_isa 'Coocook::Schema::Result::PurchaseList';
                field items         => array {
                    item hash {
                        field id               => 1;
                        field purchase_list_id => 1;

                        field value      => 1000;
                        field offset     => 0;
                        field unit_id    => 1;
                        field unit       => hash { field id => 1; field short_name => 'g'; etc };
                        field article_id => 1;
                        field article    => hash { field id => 1; field name => 'flour'; etc };
                        check_isa 'Coocook::Schema::Result::Article';
                        field comment => '';

                        field servings_sum => 6;
                        field purchased    => E();    # idea for future
                        end();
                    };
                    end();
                };
            }
        };
    };
};

done_testing;
