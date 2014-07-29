#!/usr/bin/env perl
#This library is based on TTYtter
#Copyright (C) 2010 Cameron Kaiser, Floodgap Systems. All rights reserved.
#http://www.floodgap.com

#This library is licensed under the Floodgap Free Software License
#http://www.floodgap.com/software/ffsl/
#Ensure that you read the terms, because it's not anything like the GPL, BSD, or other licenses.
#It's most similar to CC3-BY-NC.

print "Loading twitter-contest library for ttytter\n";
#####################################################
#####################################################
############## CONFIG SECTION #######################
#####################################################
#####################################################

#space-separated list of terms which must be in the tweet
#Examples:
#To watch for tweets which contain the words "ubuntu" /and/ "linux"
#$track = 'ubuntu linux';
#To watch for tweets which contain hashtags and such, add them on
#Ex. looks for tweets which contain the followfriday hashtag and rushimprint
#$track = '#followfriday @rushimprint';
#$track = '#linux';
#Alternatively, use $tquery and specify the search API query directly
#Do not use $track and $query together
$tquery = "#ubuntu #linux";

#$store->{'terms_query'} = '#linux';

#if set to 1, all terms in track must be present
#if set to 0, just one of the terms in track must be present
#Set this to 0 if using $tquery, otherwise behavior is undefined
$store->{'all_terms_must_be_present'} = 0;

#if set to 0, do no log tweets from the user being used to watch
#if set to 1, log matching tweets regardless of user
$store->{'log_self'} = 0;

#1 turns off the timeline and only watch the hashtag. this is desirable.
$notimeline = 1;

#path to the sqlite database file, relative to where start_watcher.sh is
$store->{'db_path_sqlite'} = 'database/contest.db';

#the dsn determines what database to use. uncomment the next line to use sqlite
#or modify the following to reflect mysql settings
#honestly, sqlite is the better option for all but huge contests where apple stuff is a prize
#$store->{'db_dsn'} = "dbi:SQLite:dbname=".$store->{'db_path_sqlite'};
$store->{'db_dsn'} =
  "DBI:mysql:database=twcon;hostname=localhost;mysql_connect_timeout=5;";

#database user and password--leave blank if using sqlite
$store->{'db_user'} = 'twcon';
$store->{'db_pass'} = 'ycL7JYNCcTvnu3qL';

#1 to turn on debug output, 0 to turn it off
$store->{'debug'} = 0;

#####################################################
#####################################################
############## END CONFIG SECTION ###################
#####################################################
#####################################################

#################################################
##																						 ##
##	Woe unto thee who changeth the following   ##
##																						 ##
#################################################
print "twitter-contest: config set, doing misc before registering handler\n";

#die("This bot shouldn't be run anonymously.") if ($anonymous);

$store->{'dontecho'} = $whoami;

#if this fails, split user
( $store->{'dontecho'}, $store->{'crap'} ) = split( /:/, $user, 2 )
  if ( !length($whoami) );

$store->{'tracklist'} = '';
$store->{'tracklist'} = split(/ /, $track );

print "twitter-contest: setting up the database\n";

#setup the database handle
use DBI;
$store->{'dbargs'} = { AutoCommit => 1, PrintError => $store->{'debug'} };
#it actually gets set up within the $handle method now since aliasing it didn't work ever
print "twitter-contest: setting up date::parse\n";
use Date::Parse;
print "twitter-contest: registering handler\n";

#handler for tweets
$handle = sub {

    #perl and mysql don't play nice
    $store->{'dbh'} ||= DBI->connect(
        $store->{'db_dsn'},  $store->{'db_user'},
        $store->{'db_pass'}, $store->{'dbargs'}
    ) || die "Could not connect to database: $DBI::errstr";
    $store->{'dbh'}->{mysql_auto_reconnect} = 1;
    my $ref   = shift;                #the tweet
    my $debug = $store->{'debug'};    #debugging?
    my $all_terms_must_be_present =
      $store->{'all_terms_must_be_present'};    #check if all terms are present
    my @tracklist = $store->{'tracklist'};      #$track expanded into a list
    my $log_self  = $store->{'log_self'};

    #we need the screenname
    my $sn = &descape( $ref->{'user'}->{'screen_name'} );
    return
      if ( $log_self && $sn eq $store->{'dontecho'} )
      ;    #prevent inadvertant self-logging

    #we need the full text of the tweet for verification
    my $text = &descape( $ref->{'text'} );

=pod
    if ($all_terms_must_be_present) {

       #if desired, check for the existence of the variables in the tweet's text
       #we already know what at least one of the tracks is in it
        for $t (@tracklist) {
            if ( index( $text, $t ) == -1 ) {
                if ($debug) {
                    print $streamout "DISCARDED TWEET\n[", $sn, "] ", $text,
                      "\n\n";
                }
                return;    #we don't want it if a tracked term is missing
            }
        }
    }
=cut
    #grab the info we need to store
    #we already have the screenname in $sn
    #we already have the tweet in $text
    #we need the timestamp
    my $timestamp = &descape( $ref->{'created_at'} );

    #and we need the tweet's id
    my $tweet_id = &descape( $ref->{'id'} );

    #we need to know if they are following me
    #need an api call for this
    #TODO: implement this

    #debugging
    if ($debug) {
        print $streamout 'NEW TWEET', "\n", 'At ', $timestamp, ', ', $sn,
          ' tweeted: ', $text, "\n";
    }

    #assemble a query
    my $query = sprintf(
        "insert into contest_entry
                        (timestamp, user, tweet, id) 
                      values 
                        (%s, %s, %s, %s)",
        $store->{'dbh'}->quote( str2time($timestamp) ),
        $store->{'dbh'}->quote($sn),
        $store->{'dbh'}->quote($text),
        $store->{'dbh'}->quote($tweet_id)
    );
    if ($debug) { print $streamout $query, "\n\n" }

    #execute the query
    $store->{'dbh'}->do($query);
    if ( $debug and $store->{'dbh'}->err() ) {
        print $streamout "DB ERROR: $DBI::errstr\n";
        return 0;
    }
=pod
    if(!$store->{'db_args'}->{'AutoCommit'}){
        #commit the query if there was no error
        eval { $store->{'dbh'}->commit(); };
        if ($@) {
            eval { $store->{'dbh'}->rollback(); };
            return 0;
        }
        else {
            return 1;
        }
    }
=cut
    #&defaulthandler($ref);
};

##called at the beginning of checking tweets
$heartbeat = sub {
    ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    my $stamp = sprintf(
        "%4d-%02d-%02d %02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );

    print $streamout $stamp . ": MARK - Starting cycle.\n";
};
##called at the end of checking tweets
$conclude = sub {
    ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime(time);
    my $stamp = sprintf(
        "%4d-%02d-%02d %02d:%02d:%02d",
        $year + 1900,
        $mon + 1, $mday, $hour, $min, $sec
    );

    print $streamout $stamp
      . ": MARK - The cycle is complete.\n";  #the student has become the master
};
print "twitter-contest: setup complete.\n";

1;
