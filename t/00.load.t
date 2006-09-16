use Test::More tests => 12;

BEGIN {
use_ok( 'WWW::Facebook::API::REST::Client' );
use_ok( 'WWW::Facebook::API::REST::Client::Base' );
use_ok( 'WWW::Facebook::API::REST::Client::Errors' );
use_ok( 'WWW::Facebook::API::REST::Client::Events' );
use_ok( 'WWW::Facebook::API::REST::Client::Auth' );
use_ok( 'WWW::Facebook::API::REST::Client::Login' );
use_ok( 'WWW::Facebook::API::REST::Client::Messages' );
use_ok( 'WWW::Facebook::API::REST::Client::Photos' );
use_ok( 'WWW::Facebook::API::REST::Client::Pokes' );
use_ok( 'WWW::Facebook::API::REST::Client::Users' );
use_ok( 'WWW::Facebook::API::REST::Client::Wall' );
use_ok( 'WWW::Facebook::API::REST::Client::Friends' );
}

diag( "Testing WWW::Facebook::API::REST::Client $WWW::Facebook::API::REST::Client::VERSION" );
