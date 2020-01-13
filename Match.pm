package Match;
our $VERSION = 1.10;
use strict;
use warnings;
use vars '$AUTOLOAD', '$DESTROY';

sub new {
	my $class = shift;
	my ($pre, $match, $post, $result) = splice @_, -4;
	bless {
			_pre		=> $pre,
			_match			=> $match,
			_post			=> $post,
			_result			=> $result,
			_subpatterns		=> [@_]
		  }, ref($class) || $class;
	sub _accessible() { exists $_[0]->{$1} }
}

sub AUTOLOAD
{
	no strict "refs";
	my ($self) = @_;

	#	was it a 'get()' call?	is the attribute accessible?
	if ($AUTOLOAD =~ /.*::get(_\w+)/ and $self->_accessible($1) )
	{
		# get locally scoped, scalar copy ($attr_name) of $1
		my $attr_name = $1;
		# can't use '$self' in 'sub' return call, since
		# it's outside the scope of subsequent 'get' calls;
		# the first 'get' call would work as expected, but
		# subsequent 'get' calls use the changed symbol table's
		# anonymous sub-routine
		#
		# cram the anonymous sub-routine into the symbol
		# table, use symbol table reference after the first
		# call to a 'get_xxx()' method
		*$AUTOLOAD = sub { return $_[0]->{$attr_name} };
		return $self->{$attr_name};
	} 
	return "Match::AUTOLOAD : Not a 'get' call or attribute doesn't exist.";
}

sub DESTROY {}

sub from
{
	my ($self) = @_;
	# example of Perl 'memoization'...
	# cramming a new value into $self,
	# on the fly and as it is requested.
	$self->{_from} = length($_[0]->{_pre})
		unless defined $self->{_from};
	return $self->{_from};
}

sub to
{
	my ($self) = @_;
	# example of Perl 'memoization'...
	# cramming a new value into $self,
	# on the fly and as it is requested.
	$self->{_to} = $self->from + length($self->{_match}) - 1
		unless defined $self->{_to};
	return $self->{_to};
}

sub subpatterns
{
	my ($self, $index) = @_;
	return $self->{_subpatterns}[$index] if defined $index;
	return @{$self->{_subpatterns}};
}

__END__

=pod

=head1 NAME
Match

=head1 VERSION
This document refers to version 1.10 of Match, released December 30, 2019.

=head1 SYNOPSIS
Helper module for alternative object-oriented utility for using Perl Regex functionality.

=head1 DESCRIPTION
Helper module for alternative object-oriented utility for using Perl Regex functionality.

=head2 Overview
data members : _pre, _match, _post, _result
You can access the above data members using get_pre(), get_match(),
get_post() and get_result() calls that AUTOLOAD takes care of.

methods : new AUTOLOAD (for get_pre, get_match, get_post, get_result) DESTROY

Look at each method header to surmise what the methods take as parameters and what is returned.

=head2 Constructor and initialization
my $matcher = Match->new(@subpatterns,$`,$&,$',$str)
The above line will create a Match object.
'@subpatterns' is an (optional) array usually containing a '1' or the empty array [].
$` (dollar-sign backtick) contains the character just prior to a match done in a method
of the AltRegex class.
$& (dollar-sign ampersand) contains the match itself.
$' (dollar-sign apostrophe) contains the character just after the match.
$str is a scalar reference to the regular expression result.

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
