## Bioperl Test Harness Script for Modules
##
# CVS Version
# $Id$


# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'

#-----------------------------------------------------------------------
## perl test harness expects the following output syntax only!
## 1..3
## ok 1  [not ok 1 (if test fails)]
## 2..3
## ok 2  [not ok 2 (if test fails)]
## 3..3
## ok 3  [not ok 3 (if test fails)]
##
## etc. etc. etc. (continue on for each tested function in the .t file)
#-----------------------------------------------------------------------


## We start with some black magic to print on failure.
BEGIN { $| = 1; print "1..5\n"; 
	use vars qw($loaded); }

END {print "not ok 1\n" unless $loaded;}

use lib 't';
use EnsTestDB;
use Bio::EnsEMBL::Archive::DBSQL::DBAdaptor;
use Bio::EnsEMBL::Archive::Seq;
use Bio::EnsEMBL::Archive::VersionedSeq;

$loaded = 1;
print "ok 1\n";    # 1st test passes.
    
my $ens_test = EnsTestDB->new();
    
# Load some data into the db
$ens_test->do_sql_file("../sql/archive_new.sql");

$host = $ens_test->host;
$dbname = $ens_test->dbname;
$user = $ens_test->user;

$db = Bio::EnsEMBL::Archive::DBSQL::DBAdaptor->new( -host => $host, -dbname => $dbname, -user => $user );
print "ok 2\n";

my $seq = Bio::EnsEMBL::Archive::Seq->new(
					  -name => 'test_e',
					  -type => 'exon',
					  );

my $vseq = Bio::EnsEMBL::Archive::VersionedSeq->new(
						    -archive_seq => $seq,
						    -version => 1,
						    -start_clone => 'test_clone',
						    -start => 1,
						    -end_clone => 'test_clone',
						    -end => 10,
						    -sequence => 'ATGCGTATGC',
						    -modified => '2001-06-28 13:45:00',
						    -release_number => 100
						    );
my $vsda = $db->get_VersionedSeqAdaptor;

$vsda->store($vseq);
print "ok 3\n";
