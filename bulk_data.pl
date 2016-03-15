#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use Time::HiRes qw/gettimeofday tv_interval/;
use Term::ANSIColor qw/:constants/;
$Term::ANSIColor::AUTORESET = 1;

use MongoDB;

my $client     = MongoDB->connect('mongodb://docker');
my $collection = $client->ns('foo.bar'); # database foo, collection bar

printf STDERR <<EOF, $collection->count();
Got connection to database. Collection currently has: %d records.

Dropping collection and generating it new.
EOF

$collection->drop;

printf STDERR GREEN . <<EOF,$collection->count(), RESET;

Now the collection has: %d records.

Inserting records as fast as we can now. Printing a log line every 10,000 records.
%s
EOF

my $count = 0;
my $start = [gettimeofday];

eval {
    while ( 1 ) {
        $collection->insert_one({ some => 'data', timestamp => time, _id => MongoDB::OID->new });
        $count += 1;
        if ( $count % 10_000 == 0 ) {
            printf STDERR "processed %d records, %.2f per second\n", $count, $count / tv_interval($start, [gettimeofday]);
        }
    }
};
if ($@) {
    printf STDERR <<EOF, YELLOW . $@ .RESET, BOLD . RED .$count .RESET;
Uups. something went wrong: %s

We should have inserted %s records.


EOF
}

