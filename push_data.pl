#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use Term::ANSIColor qw/:constants/;

### Get Client ###
use MongoDB;
my $client     = MongoDB->connect('mongodb://docker');
my $collection = $client->ns('foo.bar'); # database foo, collection bar

### Output the current count ###
my $count = $collection->count({ timestamp => { '$gte' => time - 10 } });
printf STDERR <<EOF, RED . $count . RESET;
Got connection to database. 

In the past 10 seconds, 
%s records were inserted.

Inserting a new record...
EOF

### Insert Data ###
$collection->insert_one({ some => 'data', timestamp => time, _id => MongoDB::OID->new });

### Read the count again
$count = $collection->count({ timestamp => { '$gte' => time - 10 } });
printf STDERR <<EOF, GREEN . $count . RESET;

...done! In the past 10 seconds, 
%s records were inserted.


EOF
