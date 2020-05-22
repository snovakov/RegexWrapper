#!/usr/bin/perl
use strict;
use warnings;
use Wrapper;
use Data::Dumper;

my $original = "cie";
my $regex = Wrapper->new($original)
	or die("Error creating Wrapper object!");
print "'regex' object :\n";
print Dumper($regex);
print Dumper($regex->get_regex());
print "---------------------------\n";
print "regex->match (full):\n";
print Dumper($regex->match("cie")->get_match);
print "regex->match('cie')->from:\n";
print $regex->match("cie")->from()."\n";
print "regex->match('cie')->to:\n";
print $regex->match("cie")->to()."\n";
print "---------------------------\n";
print "regex->match (partial):\n";
print Dumper($regex->match("ci")->get_match);
print "---------------------------\n";
print "regex->match('ci')->from:\n";
print $regex->match("ci")->from()."\n";
print "regex->match('ci')->to:\n";
print $regex->match("ci")->to()."\n";
print "regex->match('ci')->subpatterns(): \n";
print Dumper($regex->match("ci")->subpatterns(0));
print "---------------------------\n";
print "regex->match (no match):\n";
defined ($regex->match("xyz")) ? () : goto SKIP;
print Dumper($regex->match("xyz")->get_match);
print "regex->match('xyz')->from:\n";
print $regex->match("xyz")->from()."\n";
print "regex->match('xyz')->to:\n";
print $regex->match("xyz")->to()."\n";
print "---------------------------\n";
SKIP:
print "no match\n";
print "---------------------------\n";
print "regex->substitute: (match)\n";
print "regex->substitute() result = ";
print $regex->substitute("ci","m")->get_result()."\n";
print "---------------------------\n";
print "regex->substitute (no match):\n";
defined ($regex->substitute("ty","w")) ? () : goto SKIPPED;
print "---------------------------\n";
SKIPPED:
print "no match for substitution\n";
print "---------------------------\n";
print "regex->substitute (match):\n";
print "regex->substitute() _result = ";
print $regex->substitute("ci","x")->get_result()."\n";
print "---------------------------\n";
print "new_regex->substitute_all():\n";
my $last = "I batted 4 for 4!";
my $new_regex = Wrapper->new("4")	# pass-in the symbol(s) to substitute_all()
	or die("Error creating Wrapper object!");
print "new_regex->substitute_all() _result = ";
print $new_regex->substitute_all($last,"four")->get_result()."\n";
print "---------------------------\n";
print "regex->substitute_all() (attribute doesn't exist):\n";
print "new_regex->substitute_all() _hemans = ";
print $new_regex->substitute_all($last,"four")->get_hemans()."\n";
