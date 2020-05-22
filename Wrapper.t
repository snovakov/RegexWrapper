#!/usr/bin/perl -w

use strict;

use Test::More tests => 20;

BEGIN {
  use_ok('Wrapper', 'use_Wrapper');
}

can_ok('Wrapper', ('new'));

BEGIN {
  use_ok('Match', 'use_Match');
}

can_ok('Match', ('new'));

my $original = "cie";
my $regex = Wrapper->new($original)
	or die("Error creating Wrapper object!");

isa_ok($regex, 'Wrapper');

can_ok('Wrapper', ('get_pattern'));

# Wrapper object check
my $expected = bless( {
                 '_regex' => qr/cie/,
                 '_pattern' => 'cie'
               }, 'Wrapper' );
is_deeply($regex, $expected, 'wrapper_object_check');

# regex match
$expected = qr/cie/;
ok($regex->get_regex() eq $expected, 'object_ok');

# full match
$expected = "cie";
ok($regex->match("cie")->get_match eq $expected, 'full_match');

# from
$expected = 0;
ok($regex->match("cie")->from() eq $expected, 'from');

# to
$expected = 2;
ok($regex->match("cie")->to() eq $expected, 'to');

# partial match
$expected = "ci";
ok($regex->match("ci")->get_match() eq $expected, 'partial_match');

# from
$expected = 0;
ok($regex->match("ci")->from() eq $expected, 'from');

# to
$expected = 1;
ok($regex->match("ci")->to() eq $expected, 'to');

# no match
unless($regex->match("xyz")) {
	ok(1 eq 1, 'no_match');
}else{
	fail('no_match');
}

# substitute (match)
$expected = "me";
ok($regex->substitute("ci","m")->get_result() eq $expected, 'substitute_match');

# substitute (no match)
unless($regex->substitute("ty","w")) {
	ok(1 eq 1, 'substitute_no_match');	
}else{
	fail('substitute_no_match');
}

# substitute (match)
$expected = "xe";
ok($regex->substitute("ci","x")->get_result() eq $expected, 'substitute_match');

# substitute all (match)
my $last = "I batted 4 for 4!";
$expected = "I batted four for four!";
my $new_regex = Wrapper->new("4")
	or die("Error creating Wrapper object!");
ok($new_regex->substitute_all($last,"four")->get_result() eq $expected, 'substitute_all');

# substitute all (no match, attribute doesn't exist)
unless($new_regex->substitute_all($last,"four")->get_hemans() eq '') {
	ok(1 eq 1, "substitute_all_attribute_doesn't_exist")
}else{
	fail("substitute_all_attribute_doesn't_exist")
}

