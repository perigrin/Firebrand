package Firebrand::Model::Contact;
use 5.10.1;
use Moose;
use namespace::autoclean;
use MooseX::Aliases;

# ABSTRACT: A Model Contact

has id => (
    is      => 'ro',
    isa     => 'Str',
    alias   => 'kiokudb_object_id',
    default => sub {state $i = 0; $i++}
);

with qw(KiokuDB::Role::ID);

has [qw(first_name last_name)] => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;
__END__
