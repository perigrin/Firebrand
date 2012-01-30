package Firebrand::Resource::Contacts;
use 5.10.1;
use Moose;
use namespace::autoclean;

use Magpie::Constants;
use Digest::SHA qw(sha256_hex);

extends qw(Magpie::Resource);

has contacts => (
    isa     => 'ArrayRef',
    traits  => ['Array'],
    default => sub {
        [   {   first_name => 'Alligator',
                last_name  => 'Descarts',
            },
            {   first_name => 'Harold',
                last_name  => 'McBoingBoing',
            }
        ];
    },
    handles => {
        contacts       => 'elements',
        add_contact    => 'push',
        get_contact    => 'get',
        delete_contact => 'delete',
        count_contacts => 'count',
    },
);

sub GET {
    my $self = shift;
    $self->parent_handler->resource($self);
    my $id = $self->get_entity_id;
    $id = undef unless $id =~ /\d+/;
    my $i = 0;
    my $data
        = defined($id)
        ? $self->get_contact($id)
        : [ map { $_->{id} = $i++; $_ } $self->contacts ];

    $self->data($data);
    return OK;
}

sub POST {
    my $self = shift;
    $self->parent_handler->resource($self);

    my $req = $self->request;
    my %args;
    if ( $self->has_data ) {
        %args = %{ $self->data };
        $self->clear_data;
    }
    else {
        $args{$_} = $req->param($_) for $req->param;
    }
    $self->add_contact( \%args );

    my $path = $req->path_info;
    $path =~ s|^/||;
    $path =~ s|/$||;
    $self->state('created');
    $self->response->status(201);
    $self->response->header(
        'Location' => $req->base . $path . "/" . $self->count_contacts );
    $self->data( { id => $self->count_contacts, %args } );
    return OK;
}

sub PUT {
    my $self = shift;
    $self->parent_handler->resource($self);
    my $req  = $self->request;
    my $path = $req->path_info;
    my $id   = $self->get_entity_id;
    my %args;
    if ( $self->has_data ) {
        %args = %{ $self->data };
        $self->clear_data;
    }
    else {
        $args{$_} = $req->param($_) for $req->param;
    }
    $self->set_contact( $id => \%args );
    $self->response->status(200);
    return OK;
}

sub DELETE {
    my $self = shift;
    $self->parent_handler->resource($self);

    my $id = $self->get_entity_id;
    $self->delete_contact($id);
    $self->state('deleted');
    $self->response->status(204);
    return OK;
}

1;
__END__
