package Firebrand::Resource::Contacts;
use 5.10.1;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use Magpie::Constants;
use Firebrand::Model::Contact;
extends qw(Magpie::Resource);

has data_source => (
    is      => 'ro',
    isa     => 'KiokuDB',
    lazy    => 1,
    builder => '_build_data_source',
);

sub _build_data_source {
    my $self = shift;
    my $k    = try {
        $self->resolve_asset( service => 'kioku_dir' );
    }
    catch {
        confess "No kioku_dir service? $_";
    };
    return $k;
}

sub GET {
    my $self = shift;
    $self->parent_handler->resource($self);
    my $id    = $self->get_entity_id;
    my $kioku = $self->data_source;
    my $scope = $kioku->new_scope;
    if ( defined $id && $id =~ /\d+/ ) {
        $self->data( $kioku->lookup($id) );
    }
    else {
        $self->data( $kioku->root_set );
    }
    return OK;
}

sub POST {
    my $self = shift;
    $self->parent_handler->resource($self);
    my $req = $self->request;
    my %args;
    if ( $self->has_data ) {
        %args = %{ $self->data };
    }
    else {
        $args{$_} = $req->param($_) for $req->param;
    }
    my $data = Firebrand::Model::Contact->new(
        {   first_name => $args{'contact[first_name]'},
            last_name  => $args{'contact[last_name]'}
        }
    );
    {
        my $kioku = $self->data_source;
        my $scope = $kioku->new_scope;
        my $id    = $kioku->store($data);
    }
    my $path = $req->path_info;
    $path =~ s|^/||;
    $path =~ s|/$||;
    my $new_uri = $req->base . $path . "/" . $data->id;
    $self->state('created');
    $self->response->status(201);
    $self->response->header( 'Location' => $new_uri );
    $self->data($data);
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
    }
    else {
        $args{$_} = $req->param($_) for $req->param;
    }
    my $kioku   = $self->data_source;
    my $scope   = $kioku->new_scope;
    my $contact = $kioku->lookup($id);
    my $data    = blessed($contact)->new(
        id         => $contact->id,
        first_name => $args{'contact[first_name]'} // $contact->first_name,
        last_name  => $args{'contact[last_name]'} // $contact->last_name,
    );
    $kioku->delete( $contact->id );
    $kioku->store($data);
    $self->response->status(200);
    $self->data($data);
    return OK;
}

sub DELETE {
    my $self = shift;
    $self->parent_handler->resource($self);

    my $id = $self->get_entity_id;
    $self->data_source->delete($id);
    $self->state('deleted');
    $self->response->status(204);
    return OK;
}

1;
__END__
