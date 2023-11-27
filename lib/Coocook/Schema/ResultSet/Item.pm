package Coocook::Schema::ResultSet::Item;

use Moose;
use namespace::autoclean;

extends 'Coocook::Schema::ResultSet';

# find item and add value or create new item with value
sub add_or_create {
    my ( $self, $args ) = @_;

    my $item = $self->find_or_new(
        {
            purchase_list_id => $args->{purchase_list_id},
            article_id       => $args->{article_id},
            unit_id          => $args->{unit_id},
        }
    );

    if ( $item->in_storage ) {
        $item->value( $item->value + $args->{value} );
    }
    else {
        $item->set_columns(
            {
                value   => $args->{value},
                comment => "",               # no argument because existing items have comments
                offset  => 0,                # instantly apply default_value
            }
        );
    }

    $item->update_or_insert and return $item;
}

sub to_preorder {
    my $self = shift;

    return $self->with_servings_sum->search(
        {
            'article.preorder_servings' => { '!=' => undef },
            'article.preorder_workdays' => { '!=' => undef },
        },
        {
            join => 'article',
        }
    )->as_subselect_rs->search(
        {
            servings_sum => { '>=' => { -ident => 'article.preorder_servings' } },
        },
        {
            join       => 'article',
            '+columns' => [ { servings_sum => 'servings_sum' } ],
        }
    );
}

sub with_servings_sum {
    my $self = shift;

    return $self->search(
        undef,
        {
            '+select' => [
                {
                    '' =>
                      $self->correlate('ingredients')->search_related('dish')->get_column('servings')->sum_rs->as_query,
                    -as => 'servings_sum',
                },
            ],
        }
    );
}

__PACKAGE__->meta->make_immutable;

1;
