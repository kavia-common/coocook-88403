use Test2::V0;

use Coocook::Model::PurchaseList;
use DateTime;
use Test::Memory::Cycle;
use Test::MockObject;

use lib 't/lib';
use TestDB;

my $db = TestDB->new;

ok my $list = Coocook::Model::PurchaseList->new( list => $db->resultset('PurchaseList')->find(1) ),
  "new()";

is $list->date => object {
    prop isa => 'DateTime';
    call ymd => '1999-12-31';
},
  "->date";

is my $sections = $list->shop_sections => array {
    item hash {
        field id         => 1;
        field project_id => 1;
        field name       => "bakery products";
        field items      => array {
            item hash {
                field value             => 1000;
                field unit              => hash { field short_name => "g";     etc() };
                field article           => hash { field name       => "flour"; etc() };
                field convertible_into  => [ hash { field short_name => 'kg'; etc } ];
                field servings          => 6;        # 4 servings pancakes + 2 servings pizza
                field requires_preorder => T();
                field ingredients       => array {
                    item hash {
                        field id   => 1;
                        field dish => hash {
                            field name     => "pancakes";
                            field servings => 4;
                            field meal     => hash {
                                field id   => 1;
                                field date => object {
                                    prop isa => 'DateTime';
                                    call ymd => '2000-01-01';
                                };
                                field name => "breakfast";
                                etc();
                            };
                            etc();
                        };
                        etc();
                    };
                    item hash { field id => 4; etc() },
                };
                etc();
            };
            item hash {
                field value             => 37.5;
                field unit              => hash { field short_name => "g";    etc() };
                field article           => hash { field name       => "salt"; etc() };
                field convertible_into  => [];
                field servings          => 6;        # 2 servings pizza + 4 servings bread
                field requires_preorder => F();
                field ingredients       => array {
                    item hash { field id => 6; etc() };
                    item hash { field id => 8; etc() };
                };
                etc();
            };
        };
    };
},
  "->shop_sections()";

memory_cycle_ok $sections, "... is free of memory cycles";

is $list->preorders => array {
    item hash {
        field workdays => 5;
        field date     => object { call ymd => '1999-12-24' };
        field items    => array {
            item exact_ref( $sections->[0]{items}[0] );
        };
    };
},
  "->preorders is 1 item that is flour";

subtest "workday calculation" => sub {
    my $list    = $db->resultset('PurchaseList')->find(1) || die;
    my $article = $db->resultset('Article')->find(1)      || die;

    my @tests = (
        ## purchase list: 1999-12-31  Fri
        [ 0   => '1999-12-31', 'Fri' ],
        [ 1   => '1999-12-30', 'Thu' ],
        [ 2   => '1999-12-29', 'Wed' ],
        [ 3   => '1999-12-28', 'Tue' ],
        [ 4   => '1999-12-27', 'Mon' ],
        [ 5   => '1999-12-24', 'Fri' ],
        [ 6   => '1999-12-23', 'Thu' ],
        [ 7   => '1999-12-22', 'Wed' ],
        [ 10  => '1999-12-17', 'Fri' ],
        [ 100 => '1999-08-13', 'Fri' ],

        sub { $list->update( { date => '2000-01-03' } ); $list->discard_changes },    # Mon
        [ 0   => '2000-01-03', 'Mon' ],
        [ 1   => '1999-12-31', 'Fri' ],
        [ 2   => '1999-12-30', 'Thu' ],
        [ 3   => '1999-12-29', 'Wed' ],
        [ 4   => '1999-12-28', 'Tue' ],
        [ 5   => '1999-12-27', 'Mon' ],
        [ 6   => '1999-12-24', 'Fri' ],
        [ 7   => '1999-12-23', 'Thu' ],
        [ 10  => '1999-12-17', 'Fri' ],
        [ 100 => '1999-08-13', 'Wed' ],
    );

    for (@tests) {
        if ( ref eq 'CODE' ) {
            $_->();
            next;
        }

        my ( $workdays => $ymd, $day_abbr ) = @$_;
        $article->update( { preorder_workdays => $workdays } );
        is(
            Coocook::Model::PurchaseList->new( list => $list )->preorders->[0]{date} => object {
                call ymd      => $ymd;
                call day_abbr => $day_abbr;    # only for verifying test data
            },
            $workdays
        ) or warn $list->date;
    }
};

done_testing;
