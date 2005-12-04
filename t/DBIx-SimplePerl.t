# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl DBI-Simple.t'

#########################

# change 'tests => 3' to 'tests => last_test_to_print';

#use Test::More tests => 3;
use Test::More qw(no_plan);
BEGIN { use_ok('DBIx::SimplePerl') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my ($sice,$rc);

$sice	= DBIx::SimplePerl->new({debug=>1});
isa_ok( $sice, 'DBIx::SimplePerl' );
ok(defined($sice) eq 1,"instantiated");
#
# note:  These tests are overly simplistic.  They will be augmented over
# time


SKIP: {
	eval { require DBD::SQLite };

	skip "DBD::SQLite not installed", 2 if $@;
	my $dbname = sprintf "DBIx-SimplePerl.%i.db",$$;
	$sice->db_open(
                        'dsn' => "dbi:SQLite:dbname=".$dbname,
                        'dbuser'        => "",
                        'dbpass'        => ""
                      );
	
	$rc	= $sice->db_create_table(
					 table=>"test1",
					 columns=>{
					 	    name  => "varchar(30)",
						    number=> "integer",
						    fp    => "number"
					 	  }
					);
	if (defined($rc->{success}))
	   {
	     pass("SQLite db_create_table =".$dbname);	     
	   }
	  else
	   {
	     fail("SQLite db_create_table =".$dbname);
	     exit;
	   }
	   
	undef $rc;
	$rc	= $sice->db_add(
					 table=>"test1",
					 columns=>{
					 	    name  => "joe",
						    number=> "2",
						    fp    => "1.2"
					 	  }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_add");	     
	   }
	  else
	   {
	     fail("SQLite db_add");
	     exit;
	   }

	undef $rc;
	$rc	= $sice->db_add(
					 table=>"test1",
					 columns=>{
					 	    name  => "oje",
						    number=> "3",
						    fp    => "1.4"
					 	  }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_add");	     
	   }
	  else
	   {
	     fail("SQLite db_add");
	     exit;
	   }

	undef $rc;
	$rc	= $sice->db_add(
					 table=>"test1",
					 columns=>{
					 	    name  => "eoj",
						    number=> "4",
						    fp    => "1.6"
					 	  }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_add");	     
	   }
	  else
	   {
	     fail("SQLite db_add");
	     exit;
	   }

	undef $rc;
	$rc	= $sice->db_update(
					 table=>"test1",
					 search=>{
					 	    number=>3,
					         },
					 columns=>{
						    fp    => "1.8"
					 	  }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_update");	     
	   }
	  else
	   {
	     fail("SQLite db_update");
	     exit;
	   }

	undef $rc;
	$rc	= $sice->db_search(
					 table=>"test1",
					 search=>{
					 	    name=>"joe"
					         }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_update");	     
	   }
	  else
	   {
	     fail("SQLite db_update");
	     exit;
	   }
	my $q=($sice->{_sth}->fetchall_hashref('name'));
	foreach (sort keys %{$q})
         {
	   printf STDERR "%s:\t%s\t%s\n", $_, $q->{$_}->{number}, $q->{$_}->{fp} ;
         }
	undef $q;
	undef $rc;
	undef $rc;
	$rc	= $sice->db_delete(
					 table=>"test1",
					 search=>{
					 	    name=>"joe"
					         }
					);
	
 	if (defined($rc->{success}))
	   {
	     pass("SQLite db_update");	     
	   }
	  else
	   {
	     fail("SQLite db_update");
	     exit;
	   }
	
	unlink $dbname;

      }