package XBRL::Item;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Class::Accessor);

XBRL::Item->mk_accessors( qw( decimal unit id context name value localname prefix namespace type subGroup abstract nillable period balance adjValue ) );




sub new() {
	my ($class, $instance_xml) = @_;
	my $self = { decimal => undef,
								unit => undef,
								id => undef,
								context => undef,
								name => undef,
								value => undef,
								label => undef };
	bless $self, $class;

	if ($instance_xml) {
		&parse($self, $instance_xml);
	}

	return $self;
}

sub parse() {
	my ($self, $instance_xml) = @_;

	$self->{'decimal'} 	= $instance_xml->getAttribute('decimals');
	$self->{'unit'} 		= $instance_xml->getAttribute('unitRef');
	$self->{'id'} 			= $instance_xml->getAttribute('id');
	$self->{'context'} 	= $instance_xml->getAttribute('contextRef');
	$self->{'name'} 		= $instance_xml->nodeName();
	$self->{'localname'} = $instance_xml->localname();
	$self->{'prefix'} = $instance_xml->prefix();
	$self->{'namespace'} = $instance_xml->namespaceURI();
	$self->{'value'} 		= $instance_xml->textContent();
	$self->{'label'} = $instance_xml->localname();
	if ($self->{'decimal'}) {	
		$self->{'adjValue'} = &adjust($self);
	}
	else {
		$self->{'adjValue'} = $self->{'value'};
	}
}




sub adjust() {
	my ($self) = @_;
	my $number = $self->{'value'};
	my $changer = $self->{'decimal'}; 
	$changer = $changer * -1;
	my $divsor = "10";
	for (my $i = 0; $i < $changer; $i++) {
		$divsor = $divsor . '0';
	}
	my $adj_number = $number / $divsor;
	return($adj_number); 
}

=head1 XBRL::Item 

XBRL::Item - OO Module for Encapsulating XBRL Items 

=head1 SYNOPSIS

  use XBRL::Item;

	my $item = XBRL::Item->new($item_xml);	
	
=head1 DESCRIPTION

This module is part of the XBRL modules group and is intended for use with XBRL.

new() Object contstructor.  Optionally takes the item XML from the instance document. 

decimal() Get or set the number of decimals to adjust the value by. 

unit() Get or set the unitRef for the item. 

id() Get or set the item's ID.

context() Get or set the item's contextRef value. 

name() Get or set the item's name.  

value() Get or set the item's value. 

localname() Get or set the localname for the item  

prefix() Get or set the prefeix for the item  

namespace() Get or set the prefix for the item  

type() Get or set the item's type  

subGroup() Get or set the item's subGroup.

abstract() Get or set the true or false state of abstractedness  

nillable() Get or set the nillable state (true or false) 

period() Get or set whether the item covers a period  

balance() Get or set the item's balance  

adjValue() Get or set the item's adjusted value (actuall value with the 
						decimals adjusted based on the decimals attribute. 


=head1 AUTHOR

Mark Gannon <mark@truenorth.nu>

=head1 SEE ALSO

Modules: XBRL XBRL::Schema XBRL::Element XBRL::Label 

Source code, documentation, and bug tracking is hosted 
at: https://github.com/MarkGannon/XBRL . 

=head1 AUTHOR

Mark Gannon <mark@truenorth.nu>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Mark Gannon 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.


=cut

1;


