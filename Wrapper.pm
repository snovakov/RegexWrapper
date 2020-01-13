package Wrapper;
our $VERSION = 1.10;
use strict;
use warnings;
use Data::Dumper;
use Match;

sub new
{
	my ($class, $pattern) = @_;
	
	eval
		{	bless
				{
					_regex => qr/$pattern/,
					_pattern => $pattern
				} , ref($class) || $class;
		}
}

sub get_pattern{ return $_[0]->{_pattern} };
sub get_regex  { return $_[0]->{_regex} };

sub match
{
	my ($self, $str) = @_;
	my @subpatterns = ($self->get_pattern =~ /$str/) or return;
	# arguments 2 - 5 = 'pre', 'match', 'post', 'result'
	# (see Match->new() method)
	return Match->new(@subpatterns,$`,$&,$',$str);
}

sub substitute
{
	my ($self, $str, $subs) = @_;
	my $pattern = $self->get_pattern();
	$pattern =~ s/$str/$subs/ or return;
	# arguments 1 - 4 = 'pre', 'match', 'post', 'result'
	# (see Match->new() method)
	return Match->new($`,$&,$',$pattern);
}

sub substitute_all
{
	my ($self, $str, $subs) = @_;
	my $pattern = $self->get_pattern();
	$str =~ s/$pattern/$subs/g or return;
	# arguments 1 - 4 = 'pre', 'match', 'post', 'result'
	# (see Match->new() method)
	return Match->new($`,$&,$',$str);
}

__END__

=pod

=head1 NAME
Wrapper 

=head1 VERSION
This document refers to version 1.10 of Wrapper, released December 30, 2019.

=head1 SYNOPSIS
Alternative object-oriented utility for using Perl Regex functionality.

=head1 DESCRIPTION
Alternative object-oriented utility for using Perl Regex functionality.

=head2 Overview
data members : _regex, _pattern
You can access the _regex and _pattern members using the get_regex()
and get_pattern() methods provided.

methods : new get_pattern get_regex match substitute substitute_all

Look at each method header to surmise what the methods take as parameters and what is returned.

=head2 Constructor and initialization
my $regex = Wrapper->new($pattern)
The above line will create an Wrapper object.
'$pattern' must be a scalar reference to a valid Perl regular expression pattern.

=head2 Class and object methods
Look at each method header to surmise what the methods take as parameters and what is returned.

=head1 ENVIRONMENT
Unix/Linux, Windows

=head1 DIAGNOSTICS

=over 1

=back

=head1 BUGS
None.

=head1 FILES
None, other than this package file itself.

=head1 AUTHOR
Steven Novakovich
snovakov@cpan.org

=head1 COPYRIGHT
It is free software; you can redistribute it and/or modify it under the terms of either:

a) the GNU General Public License as published by the Free Software Foundation; either version 1, or (at your option) any later version, or

b) the "Artistic License". 
