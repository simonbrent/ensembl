
#
# BioPerl module for Bio::EnsEMBL::PerlDB::Contig
#
# Cared for by Ewan Birney <birney@sanger.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::EnsEMBL::PerlDB::Contig - Pure Perl implementation of contig object

=head1 SYNOPSIS

    $contig = Bio::EnsEMBL::PerlDB::Contig->new();
    
    # $sf is a Bio::SeqFeatureI type object. $seq is a Bio::Seq object

    $contig->add_SeqFeature($sf);
    $contig->seq($seq); 

=head1 DESCRIPTION

A pure perl implementation of a contig object, mainly for database loading.


=head1 CONTACT

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut


# Let the code begin...


package Bio::EnsEMBL::PerlDB::Contig;
use vars qw($AUTOLOAD @ISA);
use strict;
use Bio::EnsEMBL::DB::ContigI;


# Object preamble - inheriets from Bio::Root::Object

use Bio::Root::Object;

@ISA = qw(Bio::Root::Object Bio::EnsEMBL::DB::ContigI);
# new() is inherited from Bio::Root::Object

# _initialize is where the heavy stuff will happen when new is called

sub _initialize {
  my($self,@args) = @_;

  my $make = $self->SUPER::_initialize;

  $self->{'_repeat_array'} = [];
  $self->{'_simil_array'} = [];
  $self->{'_gene_array'} = [];
 
# set stuff in self from @args
  return $make; # success - we hope!
}


=head2 get_all_Genes

 Title   : get_all_Genes
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub get_all_Genes{
   my ($self) = @_;
   
   return @{$self->{'_gene_array'}};
}


=head2 add_Gene

 Title   : add_Gene
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub add_Gene{
   my ($self,$gene) = @_;

   if( !$gene->isa("Bio::EnsEMBL::Gene") ) {
       $self->throw("$gene is a not a Bio::EnsEMBL::Gene type");
   }

   push(@{$self->{'_gene_array'}},$gene);
}

=head2 get_all_RepeatFeatures

 Title   : get_all_RepeatFeatures
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub get_all_RepeatFeatures{
   my ($self,@args) = @_;

   return @{$self->{'_repeat_array'}};
}

=head2 add_RepeatFeature

 Title   : add_RepeatFeature
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub add_RepeatFeature{
   my ($self,$value) = @_;
   
   if( !ref $value || !$value->isa('Bio::EnsEMBL::Repeat') ) {
       $self->throw("$value is not a repeat");
   }

   push(@{$self->{'_repeat_array'}},$value);
}


=head2 get_all_SimilarityFeatures

 Title   : get_all_SimilarityFeatures
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub get_all_SimilarityFeatures{
   my ($self,@args) = @_;

   return @{$self->{'_simil_array'}};
}

=head2 add_SimilarityFeatures

 Title   : add_SimilarityFeatures
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub add_SimilarityFeatures {
   my ($self,$value) = @_;
   
   if( !ref $value || !$value->isa('Bio::EnsEMBL::FeaturePair') ) {
       $self->throw("$value is not a FeaturePair");
   }

   push(@{$self->{'_simil_array'}},$value);
}


=head2 offset

 Title   : offset
 Usage   : $obj->offset($newval)
 Function: 
 Returns : value of offset
 Args    : newvalue (optional)


=cut

sub offset{
   my $obj = shift;
   if( @_ ) {
       my $value = shift;
       $obj->{'offset'} = $value;
   }
    return $obj->{'offset'};

}

=head2 orientation

 Title   : orientation
 Usage   : $obj->orientation($newval)
 Function: 
 Returns : value of orientation
 Args    : newvalue (optional)


=cut

sub orientation{
   my $obj = shift;
   if( @_ ) {
       my $value = shift;
       $obj->{'orientation'} = $value;
   }
   return $obj->{'orientation'};
   
}

=head2 order

 Title   : order
 Usage   : $obj->order($newval)
 Function: 
 Returns : value of order
 Args    : newvalue (optional)


=cut

sub order{
   my $obj = shift;
   if( @_ ) {
      my $value = shift;
      $obj->{'order'} = $value;
    }
    return $obj->{'order'};

}



=head2 seq

 Title   : seq
 Usage   : $obj->seq($newval)
 Function: 
 Returns : value of seq
 Args    : newvalue (optional)


=cut

sub seq{
    my $obj = shift;
    if( @_ ) {
	my $value = shift;
	if(! $value->isa("Bio::Seq") ) {
	    $obj->throw("$value is not a Bio::Seq!");
	}			

	$obj->{'seq'} = $value;
    }
    return $obj->{'seq'};
    
}

=head2 id

 Title   : id
 Usage   : $obj->id($newval)
 Function: 
 Returns : value of id
 Args    : newvalue (optional)


=cut

sub id{
   my $obj = shift;
   if( @_ ) {
       my $value = shift;
       $obj->{'id'} = $value;
   }
   return $obj->{'id'};
   
}

=head2 version

 Title   : version
 Usage   : $obj->version($newval)
 Function: 
 Returns : value of version
 Args    : newvalue (optional)


=cut

sub version{
   my $obj = shift;
   if( @_ ) {
      my $value = shift;
      $obj->{'version'} = $value;
    }
    return $obj->{'version'};

}

1;
