package Coocook::Model::PreorderList;

use strict;
use warnings;
use experimental qw(signatures);

sub from_project ( $class, $project ) {
    my $lists = $project->purchase_lists;

    return $class->for_lists($lists);
}

sub for_lists ( $class, $purchase_lists_rs ) {
    my $items_rs = $purchase_lists_rs->search_related('items')->to_preorder;

    my %articles = map { $_->{id} => $_ } $items_rs->search_related('article')->hri->all;
    my %units    = map { $_->{id} => $_ } $items_rs->search_related('unit')->hri->all;

    my %purchase_lists = map { $_->id => $_ } $purchase_lists_rs->all;

    my %days;

    my $items = $items_rs->hri;

    while ( my $item = $items->next ) {
        my $article       = $articles{ $item->{article_id} }             || die $item->{id};
        my $unit          = $units{ $item->{unit_id} }                   || die $item->{id};
        my $purchase_list = $purchase_lists{ $item->{purchase_list_id} } || die $item->{id};

        my $date = $purchase_list->date->clone->subtract( days => $article->{preorder_workdays} );

        my $day = $days{ $date->ymd } ||= { date => $date };

        my $list = $day->{lists}{ $item->{purchase_list_id} } ||= {
            purchase_list => $purchase_list,
            items         => [],
        };

        $item->{article} = $article;
        $item->{unit}    = $unit;

        push $list->{items}->@*, $item;
    }

    for my $day ( values %days ) {
        $day->{lists} = [
            sort {
                     $a->{purchase_list}->date <=> $b->{purchase_list}->date
                  or $a->{purchase_list}->name cmp $b->{purchase_list}->name
            } values $day->{lists}->%*
        ];
    }

    my @days = map { $days{$_} } sort keys %days;

    return \@days;
}

1;
