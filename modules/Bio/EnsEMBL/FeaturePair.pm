
#
# BioPerl module for Bio::EnsEMBL::FeaturePair
#
# Cared for by Ewan Birney <birney@sanger.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

Bio::EnsEMBL::FeaturePair - Stores sequence features which are
                            themselves hits to other sequence features.

=head1 SYNOPSIS

    my $feat  = new Bio::EnsEMBL::FeaturePair(-feature1 => $f1,
					      -feature2 => $f2,
					      );

    # Bio::SeqFeatureI methods can be used
    my $start = $feat->start;
    my $end   = $feat->end;

    # Bio::EnsEMBL::SeqFeatureI methods can be used
    my $analysis = $feat->analysis;
    
    $feat->validate  || $feat->throw("Invalid data in $feat");

    # Bio::FeaturePair methods can be used
    my $hstart = $feat->hstart;
    my $hend   = $feat->hend;

=head1 DESCRIPTION

A sequence feature object where the feature is itself a feature on another 
sequence - e.g. a blast hit where residues 1-40 of a  protein sequence SW:HBA_HUMAN  
has hit to bases 100 - 220 on a genomic sequence HS120G22.  The genomic sequence 
coordinates are used to create one sequence feature $f1 and the protein coordinates
are used to create feature $f2.  A FeaturePair object can then be made

    my $fp = new Bio::EnsEMBL::FeaturePair(-feature1 => $f1,   # genomic
					   -feature2 => $f2,   # protein
					   );

This object can be used as a standard Bio::SeqFeatureI in which case

    my $gstart = $fp->start  # returns start coord on feature1 - genomic seq.
    my $gend   = $fp->end    # returns end coord on feature1.

In general standard Bio::SeqFeatureI method calls return information
in feature1.

Data in the feature 2 object are generally obtained using the standard
methods prefixed by h (for hit!)

    my $pstart = $fp->hstart # returns start coord on feature2 = protein seq.
    my $pend   = $fp->hend   # returns end coord on feature2.


If you wish to swap feature1 and feature2 around :

    $feat->invert

    $feat->start # etc. returns data in $feature2 object


=head1 CONTACT

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut


# Let the code begin...


package Bio::EnsEMBL::FeaturePair;

use vars qw(@ISA $ENSEMBL_EXT_LOADED $ENSEMBL_EXT_USED );
use strict;

# Object preamble - inherits from Bio::Root::Object


use Bio::EnsEMBL::FeaturePairI;
use Bio::Root::RootI;


@ISA = qw(Bio::EnsEMBL::FeaturePairI Bio::Root::RootI );


sub new {
  my($class,@args) = @_;
  my $self = {};

  bless ($self,$class);

  my ($feature1,$feature2) = 
      $self->_rearrange([qw(FEATURE1
			    FEATURE2
			    )],@args);

  # Store the features in the object

  $feature1 && $self->feature1($feature1);
  $feature2 && $self->feature2($feature2);

  # set stuff in self from @args
  return $self; # success - we hope!
}


=head2 feature1

 Title   : feature1
 Usage   : $f = $featpair->feature1
           $featpair->feature1($feature)
 Function: Get/set for the query feature
 Returns : Bio::SeqFeatureI
 Args    : none


=cut


sub feature1 {
    my ($self,$arg) = @_;

    if (defined($arg)) {
	$self->throw("Argument [$arg] must be a Bio::SeqFeatureI") unless (ref($arg) ne "" && $arg->isa("Bio::SeqFeatureI"));
	$self->{_feature1} = $arg;
    } 

    return $self->{_feature1};
}

=head2 feature2

 Title   : feature2
 Usage   : $f = $featpair->feature2
           $featpair->feature2($feature)
 Function: Get/set for the hit feature
 Returns : Bio::SeqFeatureI
 Args    : none


=cut

sub feature2 {
    my ($self,$arg) = @_;

    if (defined($arg)) {
	$self->throw("Argument [$arg] must be a Bio::SeqFeatureI") unless (ref($arg) ne "" && $arg->isa("Bio::SeqFeatureI"));
	$self->{_feature2} = $arg;
    } 
    return $self->{_feature2};
}

=head2 start

 Title   : start
 Usage   : $start = $featpair->start
           $featpair->start(20)
 Function: Get/set on the start coordinate of feature1
 Returns : integer
 Args    : none

=cut

sub start {
    my ($self,$value) = @_;
    
    if (defined($value)) {
	return $self->feature1->start($value);
    } else {
	return $self->feature1->start;
    }

}

=head2 end

 Title   : end
 Usage   : $end = $featpair->end
           $featpair->end($end)
 Function: get/set on the end coordinate of feature1
 Returns : integer
 Args    : none


=cut

sub end{
    my ($self,$value) = @_;

    if (defined($value)) {
	return $self->feature1->end($value);
    } else {
	return $self->feature1->end;
    }
}

=head2 length

 Title   : length
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub length {
   my ($self) = @_;

   return $self->end - $self->start +1;
}


=head2 strand

 Title   : strand
 Usage   : $strand = $feat->strand()
           $feat->strand($strand)
 Function: get/set on strand information, being 1,-1 or 0
 Returns : -1,1 or 0
 Args    : none


=cut

sub strand{
    my ($self,$arg) = @_;

    if (defined($arg)) {
	return $self->feature1->strand($arg);
    } else {
	return $self->feature1->strand;
    }
}

=head2 score

 Title   : score
 Usage   : $score = $feat->score()
           $feat->score($score)
 Function: get/set on score information
 Returns : float
 Args    : none if get, the new value if set


=cut

sub score {
    my ($self,$arg) = @_;
  
    if (defined($arg)) {
	return $self->feature1->score($arg);
    } else {
	return $self->feature1->score;
    }
}

=head2 frame

 Title   : frame
 Usage   : $frame = $feat->frame()
           $feat->frame($frame)
 Function: get/set on frame information
 Returns : 0,1,2
 Args    : none if get, the new value if set


=cut

sub frame {
    my ($self,$arg) = @_;
    
    if (defined($arg)) {
	return $self->feature1->frame($arg);
    } else {
	return $self->feature1->frame;
    }
}

=head2 primary_tag

 Title   : primary_tag
 Usage   : $ptag = $featpair->primary_tag
 Function: get/set on the primary_tag of feature1
 Returns : 0,1,2
 Args    : none if get, the new value if set


=cut

sub primary_tag{
    my ($self,$arg) = @_;
    
    if (defined($arg)) {
	return $self->feature1->primary_tag($arg);
    } else {
	return $self->feature1->primary_tag;
    }
}

=head2 source_tag

 Title   : source_tag
 Usage   : $tag = $feat->source_tag()
           $feat->source_tag('genscan');
 Function: Returns the source tag for a feature,
           eg, 'genscan' 
 Returns : a string 
 Args    : none


=cut

sub source_tag{
    my ($self,$arg) = @_;

    if (defined($arg)) {
	return $self->feature1->source_tag($arg);
    } else {
	return $self->feature1->source_tag;
    }
}

=head2 seqname

 Title   : seqname
 Usage   : $obj->seqname($newval)
 Function: There are many cases when you make a feature that you
           do know the sequence name, but do not know its actual
           sequence. This is an attribute such that you can store 
           the seqname.

           This attribute should *not* be used in GFF dumping, as
           that should come from the collection in which the seq
           feature was found.
 Returns : value of seqname
 Args    : newvalue (optional)


=cut

sub seqname{
    my ($self,$arg) = @_;
    
    if (defined($arg)) {
	return $self->feature1->seqname($arg);
    } else {
	return $self->feature1->seqname;
    }
}

=head2 hseqname

 Title   : hseqname
 Usage   : $featpair->hseqname($newval)
 Function: Get/set method for the name of
           feature2.
 Returns : value of $feature2->seqname
 Args    : newvalue (optional)


=cut

sub hseqname {
    my ($self,$arg) = @_;

    if (defined($arg)) {
	$self->feature2->seqname($arg);
    }

    return $self->feature2->seqname;
}


=head2 hstart

 Title   : hstart
 Usage   : $start = $featpair->hstart
           $featpair->hstart(20)
 Function: Get/set on the start coordinate of feature2
 Returns : integer
 Args    : none

=cut

sub hstart {
    my ($self,$value) = @_;
    
    if (defined($value)) {
	return $self->feature2->start($value);
    } else {
	return $self->feature2->start;
    }

}

=head2 hend

 Title   : hend
 Usage   : $end = $featpair->hend
           $featpair->hend($end)
 Function: get/set on the end coordinate of feature2
 Returns : integer
 Args    : none


=cut

sub hend{
    my ($self,$value) = @_;

    if (defined($value)) {
	return $self->feature2->end($value);
    } else {
	return $self->feature2->end;
    }
}



=head2 hstrand

 Title   : hstrand
 Usage   : $strand = $feat->strand()
           $feat->strand($strand)
 Function: get/set on strand information, being 1,-1 or 0
 Returns : -1,1 or 0
 Args    : none


=cut

sub hstrand{
    my ($self,$arg) = @_;

    if (defined($arg)) {
	return $self->feature2->strand($arg);
    } else {
	return $self->feature2->strand;
    }
}

=head2 hscore

 Title   : hscore
 Usage   : $score = $feat->score()
           $feat->score($score)
 Function: get/set on score information
 Returns : float
 Args    : none if get, the new value if set


=cut

sub hscore {
    my ($self,$arg) = @_;
  
    if (defined($arg)) {
	return $self->feature2->score($arg);
    } else {
	return $self->feature2->score;
    }
}

=head2 hframe

 Title   : hframe
 Usage   : $frame = $feat->frame()
           $feat->frame($frame)
 Function: get/set on frame information
 Returns : 0,1,2
 Args    : none if get, the new value if set


=cut

sub hframe {
    my ($self,$arg) = @_;
    
    if (defined($arg)) {
	return $self->feature2->frame($arg);
    } else { 
	return $self->feature2->frame;
    }
}

=head2 hprimary_tag

 Title   : hprimary_tag
 Usage   : $ptag = $featpair->hprimary_tag
 Function: Get/set on the primary_tag of feature2
 Returns : 0,1,2
 Args    : none if get, the new value if set


=cut

sub hprimary_tag{
    my ($self,$arg) = @_;

    if (defined($arg)) {
	return $self->feature2->primary_tag($arg);
    } else {
	return $self->feature2->primary_tag;
    }
}

=head2 hsource_tag

 Title   : hsource_tag
 Usage   : $tag = $feat->hsource_tag()
           $feat->source_tag('genscan');
 Function: Returns the source tag for a feature,
           eg, 'genscan' 
 Returns : a string 
 Args    : none


=cut

sub hsource_tag{
    my ($self,$arg) = @_;

    if (defined($arg)) {
	return $self->feature2->source_tag($arg);
    } else {
	return $self->feature2->source_tag;
    }
}

=head2 invert

 Title   : invert
 Usage   : $tag = $feat->invert
 Function: Swaps feature1 and feature2 around
 Returns : Nothing
 Args    : none


=cut

sub invert {
    my ($self) = @_;

    my $tmp = $self->feature1;
    
    $self->feature1($self->feature2);
    $self->feature2($tmp);

}

=head2 sub_SeqFeature

 Title   : sub_SeqFeature
 Usage   : Function just for complying with SeqFeatureI
 Function:
 Example :
 Returns : an empty list
 Args    :


=cut

sub sub_SeqFeature{
   my ($self,@args) = @_;

   return ();
}

=head2 all_tags

 Title   : all_tags
 Usage   : Function just for complying with SeqFeatureI
 Function:
 Example :
 Returns : an empty list
 Args    :


=cut

sub all_tags{
   my ($self,@args) = @_;
   return ();

}


=head2 analysis

 Title   : analysis
 Usage   : $sf->analysis();
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub analysis{
   my ($self,$value) = @_;

   if( defined $value ) {
       $self->throw("Trying to add a non analysis object $value!") unless (ref $value && $value->isa('Bio::EnsEMBL::AnalysisI'));
       $self->{_analysis} = $value;
   }

   if (defined($self->feature1)) { $self->feature1->analysis($value);}
   if (defined($self->feature2)) { $self->feature2->analysis($value);}

   if (defined($self->{_analysis})) {
       return $self->{_analysis};
   } else {
       return $self->feature1->analysis;
   }
   return $self->{_analysis};
}



=head2 seq

 Title   : seq
 Usage   : $tseq = $sf->seq()
 Function: returns the truncated sequence (if there) for this
 Example :
 Returns : 
 Args    :


=cut

sub seq{
   my ($self,$arg) = @_;

   if( defined $arg ) {
       $self->throw("Calling SeqFeature::Generic->seq with an argument. You probably want attach_seq");
   }

   if( ! exists $self->{'_gsf_seq'} ) {
       return undef;
   }

   # assumming our seq object is sensible, it should not have to yank
   # the entire sequence out here.

   my $seq = $self->{'_gsf_seq'}->trunc($self->start(),$self->end());


   if( $self->strand == -1 ) {

       # ok. this does not work well (?)
       #print STDERR "Before revcom", $seq->str, "\n";
       $seq = $seq->revcom;
       #print STDERR "After  revcom", $seq->str, "\n";
   }

   return $seq;
}


=head2 attach_seq

 Title   : attach_seq
 Usage   : $sf->attach_seq($seq)
 Function: Attaches a Bio::PrimarySeqI object to this feature. This
           Bio::PrimarySeqI object is for the *entire* sequence: ie
           from 1 to 10000
 Example :
 Returns : 
 Args    :


=cut

sub attach_seq{
   my ($self,$seq) = @_;

   if( !defined $seq  || !ref $seq || ! $seq->isa("Bio::PrimarySeqI") ) {
       $self->throw("Must attach Bio::PrimarySeqI objects to SeqFeatures");
   }

   $self->{'_gsf_seq'} = $seq;
}

=head2 entire_seq

 Title   : entire_seq
 Usage   : $whole_seq = $sf->entire_seq()
 Function: gives the entire sequence that this seqfeature is attached to
 Example :
 Returns : 
 Args    :


=cut

sub entire_seq{
   my ($self) = @_;

   return $self->{'_gsf_seq'};
}


=head2 validate

 Title   : validate
 Usage   : $sf->validate
 Function: Checks whether all data fields are filled
           in in the object and whether it is of
           the correct type.
           Throws an exception if it finds problems
 Example : $sf->validate
 Returns : nothing
 Args    : none


=cut

sub validate {
    my ($self) = @_;

    # First the features;

    $self->throw("Empty or wrong type of feature1 object") unless defined($self->feature1)   && 
	                                             ref($self->feature1) ne "" && 
						     $self->feature1->isa("Bio::EnsEMBL::SeqFeatureI");
    $self->throw("Empty or wrong type of feature1 object ") unless defined($self->feature2) &&
	                                             ref($self->feature2) ne "" && 
						     $self->feature2->isa("Bio::EnsEMBL::SeqFeatureI");

    $self->feature1->validate();
    $self->feature2->validate();

    # Now the analysis object
    if (defined($self->analysis)) {
	$self->throw("Wrong type of analysis object") unless $self->analysis->isa("Bio::EnsEMBL::AnalysisI");
    } else {
	$self->throw("No analysis object defined");
    }
}

=head2 validate_prot_feature

 Title   : validate_prot_feature
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub validate_prot_feature{
   my ($self) = @_;
 # First the features;

    $self->throw("Empty or wrong type of feature1 object") unless defined($self->feature1)   && 
	                                             ref($self->feature1) ne "" && 
						     $self->feature1->isa("Bio::EnsEMBL::SeqFeatureI");
    $self->throw("Empty or wrong type of feature1 object ") unless defined($self->feature2) &&
	                                             ref($self->feature2) ne "" && 
						     $self->feature2->isa("Bio::EnsEMBL::SeqFeatureI");

    $self->feature1->validate_prot_feature(1);
    $self->feature2->validate_prot_feature(2);

    # Now the analysis object
    if (defined($self->analysis)) {
	$self->throw("Wrong type of analysis object") unless $self->analysis->isa("Bio::EnsEMBL::AnalysisI");
    } else {
	$self->throw("No analysis object defined");
    }

}

=head2 set_all_fields

 Title   : set_all_fields
 Usage   : $fp->set_all_fields($start,$end,$strand,$score,$source,$primary,$seqname,$hstart,$hend,$hstrand,$hscore,$hsource,$hprimary,$hseqname)
 Function: set all the fields in the feature pair object
           (this is for performance issues when using the C layer which needs
	    this methods to cut down on Perl context switching. It is in the Perl
	    Layer to allow a pure perl implementation to work ontop of the perl)
 Example :
 Returns : nothing
 Args    : listed above


=cut

sub set_all_fields{
   my ($self,$start,$end,$strand,$score,$source,$primary,$seqname,$hstart,$hend,$hstrand,$hscore,$hsource,$hprimary,$hseqname) = @_;

   $self->start($start);
   $self->end($end);
   $self->strand($strand);
   $self->score($score);
   $self->source_tag($source);
   $self->primary_tag($primary);
   $self->seqname($seqname);
   $self->hstart($hstart);
   $self->hend($hend);
   $self->hstrand($hstrand);
   $self->hscore($hscore);
   $self->hsource_tag($hsource);
   $self->hprimary_tag($hprimary);
   $self->hseqname($hseqname);

}

=head2 to_FTHelper

 Title   : to_FTHelper
 Usage   :
 Function:
 Example :
 Returns : 
 Args    :


=cut

sub to_FTHelper{
   my ($self) = @_;

   # Make new FTHelper, and fill in the key
   my $fth = Bio::SeqIO::FTHelper->new;
   $fth->key('similarity');
   
   # Add location line
   my $g_start = $self->start;
   my $g_end   = $self->end;
   my $loc = "$g_start..$g_end";
   if ($self->strand == -1) {
        $loc = "complement($loc)";
    }
   $fth->loc($loc);
   
   # Add note describing similarity
   my $type    = $self->hseqname;
   my $r_start = $self->hstart;
   my $r_end   = $self->hend;
   $fth->add_field('note', "$type: matches $r_start to $r_end");
   $fth->add_field('note', "score=".$self->score);
   
   
   return $fth;
}

sub id {
    my ($self,$value) = @_;

    if (defined($value)) {
	return $self->feature1->id($value);
    }
    
    return $self->feature1->id;

}

sub gffstring {
   my ($self) = @_;

   my $str = $self->seqname . "\t" . $self->source_tag . "\t" . 
          $self->primary_tag . "\t" . $self->start . "\t" . $self->end . "\t" ;

   my $strand = ".";
   if ($self->strand == 1) {
       $strand = "+";
   } elsif ($self->strand == -1) {
       $strand = "-";
   }

   $str .= $self->score .    "\t" . $strand . "\t.\t" ;     
   $str .= $self->hseqname . "\t" . $self->hstart . "\t" . 
           $self->hend     . "\t" . $self->hstrand ;

   return $str;
}


sub has_tag {
    return 0;
}

=head2 percent_id

 Title   : percent_id
 Usage   : $percent_id = $featpair->percent_id
           $featpair->percent_id($pid)
 Function: Get/set on the percent_id of feature1
 Returns : integer
 Args    : none

=cut

sub percent_id {
    my ($self,$value) = @_;
    
    if (defined($value)) 
    {
	    return $self->feature1->percent_id($value);
    }     
	return $self->feature1->percent_id();

}

=head2 p_value

 Title   : p_value
 Usage   : $p_value = $featpair->p_value
           $featpair->p_value($p_value)
 Function: Get/set on the p_value of feature1
 Returns : integer
 Args    : none

=cut

sub p_value {
    my ($self,$value) = @_;
    
    if (defined($value)) 
    {
	    return $self->feature1->p_value($value);
    }     
	return $self->feature1->p_value();

}
                   
1;
