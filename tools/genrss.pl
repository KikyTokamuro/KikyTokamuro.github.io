#!/usr/bin/perl

use strict;
use warnings;

use XML::RSS::FromHTML::Simple;

my $proc = XML::RSS::FromHTML::Simple->new({
    title    => "Kiky Page RSS",
    url      => "https://kikytokamuro.github.io/",
    rss_file => "../rss.xml",
});

$proc->link_filter( sub {
    my($link, $text) = @_;

    if( $link =~ m#notes#) {
        return 1;
    } else {
        return 0;
    }
});

$proc->make_rss() or die $proc->error();
