#######################################################################
# $Date: 2006-09-16T21:35:57.648648Z $
# $Revision: 32521 $
# $Author: unobe $
# ex: set ts=8 sw=4 et
#########################################################################
package WWW::Facebook::API::REST::Client::Login;

use warnings;
use strict;
use Carp;

use version; our $VERSION = qv('0.0.3');

use Moose;

extends 'Moose::Object';

has 'base' => (is => 'ro', isa => 'WWW::Facebook::API::REST::Client::Base',);

has 'login_uri' => (is => 'ro', isa => 'Str', required => 1,
    default => sub { 'http://api.facebook.com/login.php' },
);

sub _login_form {
    my $self = shift;
    $self->base->mech->submit_form(
        form_number => 1,
        fields  => {
            email => sub {
                print 'Email address: ';
                chomp(my $email = <STDIN>);
                return $email;
            }->(),
            pass  => sub {
                print 'Password: ';
                chomp(my $email = <STDIN>);
                return $email;
            }->(),
        },
        button => 'login',
    );
    return;
}

sub login {
    my $self = shift;
    my $token = shift;
    my $agent = $self->base->mech->agent_alias('Mac Mozilla');
    $self->base->mech->get(
        $self->login_uri .'?api_key='.$self->base->api_key
            . "&auth_token=$token"
    );
    if (not $self->base->mech->forms) {
        confess 'No form to submit!';
    }
    $self->_login_form;
    if ($self->base->mech->content !~ m{logout</a>}mx) {
        confess 'Unable to login';
    }
    $self->base->mech->agent($agent);
    return $token;
}

1;
__END__

=head1 NAME

WWW::Facebook::API::REST::Client::Login - Ask for user login info


=head1 VERSION

This document describes WWW::Facebook::API::REST::Client::Login
version 0.0.3


=head1 SYNOPSIS

    use WWW::Facebook::API::REST::Client::Login;


=head1 DESCRIPTION

This uses the L<WWW::Mechanize> object to login a user to the Facebook. Useful
for quick testing, by replacing L<WWW::Facebook::API::REST::Client::Auth> in
Client.pm with this module since this module subclasses that one.


=head1 SUBROUTINES/METHODS 

=over

=item base

The L<WWW::Facebook::API::REST::Client::Base> object to use to make calls to
the REST server

=item login_uri

The login uri for having the user login. If you want, there are internal
methods available (using L<WWW::Mechanize>) to login the user automatically so
they don't have to open a browser window to do so.

=item login

Given a token, logs in a user using C<_login_form>.

=back


=head1 INTERNAL METHODS AND FUNCTIONS

=over

=item _login_form

Generates the actual form submission for the login process. Ask for the user
name and password of a person from STDIN. Their username and password is not
masked presently, and it is not stored (the latter of which is a B<BIG> no-no).

=back


=head1 DIAGNOSTICS

No errors are currently thrown by this module particularly. However, there can
be errors thrown with the other modules this module uses. See L<DEPENDENCIES>


=head1 CONFIGURATION AND ENVIRONMENT

WWW::Facebook::API::REST::Client::Login requires no configuration
files or environment variables.


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
