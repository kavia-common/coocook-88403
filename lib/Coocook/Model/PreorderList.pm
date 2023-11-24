package Coocook::Model::PreorderList;

use strict;
use warnings;
use experimental qw(signatures);

sub from_project ( $class, $project ) {
    my $lists = $project->purchase_lists;

    my $items =
      $lists->search_related('items')
      ->to_preorder->search( undef, { prefetch => [ 'article', 'unit' ] } );

    my %lists = map { $_->id => $_ } $lists->all;

    my %days;
    my @items;

    while ( my $item = $items->next ) {
        my $article = $item->article;
        my $unit    = $item->unit;

        my $list = $lists{ $item->purchase_list_id };

        my $date = $list->date->clone->subtract( days => $article->preorder_workdays );
        push @items,
          $item->as_hashref(
            article                   => $article,
            purchase_list             => $list,
            unit                      => $unit,
            date                      => $date,
            article_preorder_servings => $article->preorder_servings,
          );
    }

    my $self = \@items;

    return bless $self, ref $class || $class;
}

1;
