use strict;
use warnings;
 
my @emails = (
    'foo@bar.com',
    'foo at bar.com',
    'foo.bar42@c.com',
    '42@c.com',
    'f@42.co',
    'foo@4-2.team',
    '-------------------------------------------------',
    '.x@c.com',
    'x.@c.com',
    'foo_bar@bar.com',
    '_bar@bar.com',
    'foo_@bar.com',
    'foo+bar@bar.com',
    '+bar@bar.com',
    'foo+@bar.com',
    '-----------------------wiki valid--------------------------',
    'simple@example.com',
    'very.common@example.com',
    'disposable.style.email.with+symbol@example.com',
    'other.email-with-hyphen@example.com',
    'fully-qualified-domain@example.com',
    'user.name+tag+sorting@example.com',
    'x@example.com',
    '"very.(),:;<>[]\".VERY.\"very@\\ \"very\".unusual"@strange.example.com',
    'example-indeed@strange-example.com',
    'admin@mailserver1',
    '#!$%&\'*+-/=?^_`{}|~@example.org',
    '"()<>[]:,;@\\\"!#$%&\'-/=?^_`{}| ~.a"@example.org',
    'example@s.example',
    'user@[2001:DB8::1]',
    '" "@example.org',
    '-----------------------wiki invalid--------------------------',
    'Abc.example.com',
    'A@b@c@example.com',
    'a"b(c)d,e:f;g<h>i[j\k]l@example.com',
    'just"not"right@example.com',
    'this is"not\allowed@example.com',
    'this\ still\"not\\allowed@example.com',
    '1234567890123456789012345678901234567890123456789012345678901234+ x@example.com',
    'john..doe@example.com',
    'john.doe@example..com',
);
 
 
#foreach my $email (@emails) {
#    my $username = qr/[a-zA-Z]+([a-zA-Z0-9_+\.]*[a-zA-Z0-9_+])?/;
#    my $domain   = qr/[a-zA-Z0-9\.-]+/;
#    my $regex = $email =~ /($username\@$domain)/;
 
#    if (not $regex) {
#        printf "%-60s Invalid\n", $email;
#    } elsif ($regex) {
#        printf "%-60s Valid\n", $email;
#    }
#}

foreach my $email (@emails) {
    my $username = '(^[a-zA-Z]+([a-zA-Z0-9_+\.]*[a-zA-Z0-9_+])?';
    my $domain   = '[a-zA-Z0-9\.-]+$)';
    #my $regex = $username.'@'.$domain;
    #my $regex = '\b([A-Za-z](\w|[\(\)\<\>\[\]\:\,\;\@\\\"\!\#\$\%\&\'\-/\=\?\^\_\`\{\}\|\~\.\+\*]|\"\ \"|\\\ \\\)*@[A-Za-z\-]+\.[A-Za-z]+)\b';
    #my $regex = '\b([A-Za-z](\w|\"|\|(|\)|\<|\>|\[|\]|\:|\,|\;|\@|\\|\"|\!|\#|\$|\%|\&|\'|\-|\/|\=|\?|\^|\_|\`|\{|\}|\||\~|\.|\*|\+)*@[A-Za-z\-]+\.[A-Za-z]+)\b';
    my $regex = '\b(\w+[\w\.\-\+\"]*\@[a-z]+([\.\-][a-z]+)+)\b';
    #print("$email");
    if ($email =~ /$regex/i) {
        printf "%-60s Valid [$1]\n", $email;
    } else {
        printf "%-60s Invalid\n", $email;
    }

}