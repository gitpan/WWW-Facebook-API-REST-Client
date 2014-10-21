#######################################################################
# $Date: 2006-09-16T21:02:53.635514Z $
# $Revision: 32510 $
# $Author: unobe $
# ex: set ts=8 sw=4 et
#########################################################################
package WWW::Facebook::API::REST::Client::Auth;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.2');

use Moose;

extends 'Moose::Object';

has 'base' => (is => 'ro', isa => 'WWW::Facebook::API::REST::Client::Base');

sub create_token {
    my $self = shift;
    return $self->base->call(
        method => 'facebook.auth.createToken',
        params => { api_key => $self->base->api_key },
        secret => $self->base->secret,
    );
}

sub get_session {
    if (!$_[1]) {
        confess 'auth token required';
    }
    my $self = shift;

    if ($self->base->desktop) {
        # swap to using https for the sake of getting the session secret
        $self->base->server_uri(_make_secure($self->base->server_uri))
    }

    my $xml = $self->base->call(
        method => 'facebook.auth.getSession',
        params => { auth_token => shift },
        secret => $self->base->secret,
    );

    $self->base->session_key($xml->{result}->[0]->{session_key}->[0]);
    if ($self->base->desktop) {
        $self->base->session_secret($xml->{result}->[0]->{secret}->[0]);
        $self->base->server_uri(_make_insecure($self->base->server_uri));
    }
    return $xml;
}

sub _make_secure {
    my $uri = shift; $uri =~ s{http://}{https://}mx; return $uri;
}

sub _make_insecure {
    my $uri = shift; $uri =~ s{https://}{http://}mx; return $uri;
}

1;
__END__

=head1 NAME

WWW::Facebook::API::REST::Client::Auth - Authentication utilities for Client


=head1 VERSION

This document describes WWW::Facebook::API::REST::Client::Auth version 0.0.2


=head1 SYNOPSIS

    use WWW::Facebook::API::REST::Client::Auth;


=head1 DESCRIPTION

Methods for accessing auth with L<WWW::Facebook::API::REST::Client>

=head1 SUBROUTINES/METHODS 

=over

=item create_token

auth.createToken of the Facebook API 

=item get_session

auth.getSession of the Facebook API 

=back


=head1 INTERNAL METHODS AND FUNCTIONS

=over

=item base

The L<WWW::Facebook::API::REST::Client::Base> object to use to make calls to
the REST server

=item _make_secure

Changes the server_uri to https for C<get_session>.

=item _make_insecure

Changes the server_uri back to http at the end of C<get_session>.

=back


=head1 DIAGNOSTICS

=over

=item C< auth token required >

No auth token was passed to get_session. Pass the token that was created from
create_token.

=back


=head1 CONFIGURATION AND ENVIRONMENT

WWW::Facebook::API::REST::Client::Auth requires no configuration files or
environment variables.


=head1 DEPENDENCIES

L<Moose>
L<WWW::Mechanize>
L<XML::Simple>
L<Digest::MD5>
L<Time::HiRes>
L<URI::Escape>


=head1 INCOMPATIBILITIES

None.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-www-facebook-api-rest-client@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

David Romano  C<< <unobe@cpan.org> >>


=head1 LICENSE AND COPYRIGHT

Copyright (c) 2006, David Romano C<< <unobe@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
