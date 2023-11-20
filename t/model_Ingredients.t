use Test2::V0;

use Coocook::Model::Ingredients;

use lib 't/lib/';
use TestDB;

plan(8);

my $schema = TestDB->new();

ok my $ingredients =
  Coocook::Model::Ingredients->new( recipe => $schema->resultset('Recipe')->find(1) ),
  "ingredients from recipe";

is $ingredients->as_arrayref => array {
    item hash {
        field value    => 0.5;
        field unit     => object { call short_name => 'l' };
        field article  => object { call name       => 'water' };
        field preorder => F();
        etc();
    };
    item hash {
        field value    => 1;
        field unit     => object { call short_name => 'kg' };
        field article  => object { call name       => 'flour' };
        field preorder => T();
        etc();
    };
    item hash {
        field value    => 15;
        field unit     => object { call short_name => 'g' };
        field article  => object { call name       => 'salt' };
        field preorder => F();
        etc();
    };
    item hash {
        field value    => 10;
        field unit     => object { call short_name => 'g' };
        field article  => object { call name       => 'salt' };
        field preorder => F();
        field comment  => 'if you like salty';
        etc();
    };
},
  "as_arrayref()";

is $ingredients->as_arrayref( servings => 8 ) => array {
    item hash { field value => 1;  etc };
    item hash { field value => 2;  etc };
    item hash { field value => 30; etc };
    item hash { field value => 20; etc };
},
  "as_arrayref() with servings";

like dies { $ingredients->as_arrayref( foo => 42 ) } => qr/argument/,
  "as_arrayref() with unsupported arguments dies";

is my $articles = $ingredients->all_articles => array {
    item object {
        call name => 'cheese';
        call_list units => array {
            item object { call short_name => 'g' };
            item object { call short_name => 'kg' };
        };
    };
    item object {
        call name => 'flour';
        call_list units => array {
            item object { call short_name => 'g' };
            item object { call short_name => 'kg' };
        };
    };
    item object {
        call name => 'love';
        call_list units => [];
    };
    item object {
        call name => 'salt';
        call_list units => array {
            item object { call short_name => 'g' };
        };
    };
    item object {
        call name => 'water';
        call_list units => array {
            item object { call short_name => 'l' };
        };
    };
},
  "all_articles";

is(
    ( $articles->[0]->units )[1] => exact_ref( ( $articles->[1]->units )[1] ),
    "kg of cheese and kg of flour are the same Result object"
);

is(
    ( $ingredients->all_articles->[0]->units )[0] => exact_ref( ( $articles->[0]->units )[0] ),
    "calling all_articles() twice returns the same Result objects"
);

is my $units = $ingredients->all_units => array {
    item object { call short_name => 'g';  call long_name => 'grams' };
    item object { call short_name => 'kg'; call long_name => 'kilograms' };
    item object { call short_name => 'l';  call long_name => 'liters' };
    item object { call short_name => 'p';  call long_name => 'pinch' };
    item object { call short_name => 't';  call long_name => 'tons' };
},
  "all_units";
