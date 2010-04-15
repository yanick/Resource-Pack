#!/usr/bin/env perl
use lib 't/lib';
use Test::Resource::Pack;

use Resource::Pack::FromFile;

{
    my $resource = Resource::Pack::FromFile->new(
        name          => 'my_app',
        resource_file => file(data_dir, 'resources'),
        install_to    => 'app',
    );
    test_install(
        $resource,
        sub {
            like(file('app', 'jquery.min.js')->slurp,
                 qr/jQuery JavaScript Library/,
                 "got correct jquery");
        },
        map { $_->isa('Path::Class::Dir') ? dir('app', $_) : file('app', $_) }
            (file('app.js'), file('css', 'app.css'), dir('css'),
             file('images', 'logo.png'), dir('images'), file('jquery.min.js')),
    );
}

{
    package My::App::Resources;
    use Moose;
    extends 'Resource::Pack::FromFile';

    has '+name'          => (default => 'my_app');
    has '+resource_file' => (
        default => sub { ::file(::data_dir, 'resources') }
    );
}

{
    my $resource = My::App::Resources->new(install_to => 'app');
    test_install(
        $resource,
        sub {
            like(file('app', 'jquery.min.js')->slurp,
                 qr/jQuery JavaScript Library/,
                 "got correct jquery");
        },
        map { $_->isa('Path::Class::Dir') ? dir('app', $_) : file('app', $_) }
            (file('app.js'), file('css', 'app.css'), dir('css'),
             file('images', 'logo.png'), dir('images'), file('jquery.min.js')),
    );
}

done_testing;
