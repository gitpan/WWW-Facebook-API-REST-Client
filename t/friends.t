use Test::More tests => 19;
use Test::MockObject::Extends;
use WWW::Mechanize;
use WWW::Facebook::API::REST::Client::Base;
use strict;
use warnings;


BEGIN { use_ok('WWW::Facebook::API::REST::Client::Friends'); }

my $base = WWW::Facebook::API::REST::Client::Base->new(
    api_key => 1,
    secret  => 1,
    mech    => Test::MockObject::Extends->new(WWW::Mechanize->new()),
);
$/ = "\n\n";
$base->mech->set_series('content', <DATA>);

my $friends = WWW::Facebook::API::REST::Client::Friends->new(
    base => $base, api_key => 1, secret => 1
);

{
    is eval {$friends->get_typed->{result}->[0]}, undef,
        "argument needed: link type";
    like $@, '/^link type required/', "link type error message correct";

    my $result = $friends->get_typed('LIVED')->{result}->[0];
    is $result->{method}, 'facebook.friends.getTyped', 'method correct';

    my @friends_ids = @{$result->{result_elt}};
    is @friends_ids, 2, 'num of elements correct for get_typed';
    is $friends_ids[0], 'i9MrePeIUZxk.', 'first friend id correct';
    is $friends_ids[1], 'iEbreE8U_f5E.', 'second friend id correct';

}

{
    my $result = $friends->get->{result}->[0];
    is $result->{method}, 'facebook.friends.get', 'method correct';
    
    my @friends_ids = @{$result->{result_elt}};
    is @friends_ids, 2, 'num of elements correct for get';
    is $friends_ids[0], 'iPF_ahrjO4z3fpYh8-ySIMA..', 'first friend id correct';
    is $friends_ids[1], 'iNKaODV1u8Aq1HNcGvfk27w..', 'second friend id correct';
    
}

{
    is eval {$friends->are_friends->{result}->[0]}, undef,
        "argument needed: id1";
    like $@, '/^id1 array ref required/', "id1 error message correct";

    is eval {$friends->are_friends([12,13])->{result}->[0]}, undef,
        "argument needed: id2";
    like $@, '/^id2 array ref required/', "id2 error message correct";

    my $result = $friends->are_friends([12, 13], [13, 15])->{result}->[0];
    is $result->{method}, 'facebook.friends.areFriends', 'method correct';
    
    my @are_friends = @{$result->{result_elt}};
    is @are_friends, 2, 'num of elements correct for are_friends';
    is $are_friends[0], 1, 'first pair of id1 and id2 are friends';
    is $are_friends[1], 0, 'second pair of id1 and id2 are not';
}

__DATA__
<?xml version="1.0" encoding="UTF-8"?>
<result method="facebook.friends.getTyped">
  <result_elt>i9MrePeIUZxk.</result_elt>
  <result_elt>iEbreE8U_f5E.</result_elt>
</result>

<?xml version="1.0" encoding="UTF-8"?>
<result method="facebook.friends.get">
  <result_elt>iPF_ahrjO4z3fpYh8-ySIMA..</result_elt>
  <result_elt>iNKaODV1u8Aq1HNcGvfk27w..</result_elt>
</result>

<?xml version="1.0" encoding="UTF-8"?>
<result method="facebook.friends.areFriends">
  <result_elt>1</result_elt>
  <result_elt>0</result_elt>
</result>
