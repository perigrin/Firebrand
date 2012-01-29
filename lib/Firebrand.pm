package Firebrand;
use Moose;

# ABSTRACT: An amazing new application!

use FindBin;
use Bread::Board;
use Plack::Builder;
use Plack::Middleware::Magpie;
use Plack::Middleware::Static;
use Plack::Middleware::Session;
use Plack::Middleware::MethodOverride;

has assets => (
    is      => 'ro',
    isa     => 'Bread::Board::Container',
    lazy    => 1,
    builder => '_build_assets',
);

sub _build_assets {
    my $self = shift;
    return container '' => as {};
}

sub app {
    my $self = shift;
    builder {
        enable 'MethodOverride';
        enable 'Session';
        enable "Static",
            path => qr{(?:^/(?:images|js|css)/|\.(?:txt|html|xml|ico)$)},
            root => 'root/static';
        enable "Magpie",
            assets => $self->assets,
            conf   => 'conf/magpie.xml';
    };
}

1;
__END__
