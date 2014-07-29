twitter-contest

by Colin Dean <cad@cad.cx>
(c) 2010 Clayton Kendall, Inc.

==Introduction==

This system includes two major packages:
  * Twitter watcher
  * Result viewer

The Twitter watcher component consists of TTYtter, a command line Twitter client written in Perl, with a custom library for the handling of Tweets.

The Result viewer component consists of a custom webadmin panel written in PHP.

They both require a central database. Schema are included for SQLite3 and MySQL.

By default, it's set up to use MySQL. However, using MySQL sucks because Perl's database driver for MySQL is prone to disconnecting and needing thus to be reconnected, costing time. SQLite3 doesn't have this limitation, so it may be faster for all but the largest contests.

==License==

twitter-contest.pl 1.0 is released under the Floodgap Free Software License.

twitter-contest relies heavily on TTYtter by Cameron Kaiser of Floodgap Systems, www.floodgap.com. TTYtter is released under the Floodgap Free Software License.

http://www.floodgap.com/software/ffsl/

Please read the terms of the FFSL before distributing this software, as the FFSL is not a GPL-compatible license. It is most similar to CC3-BY-NC in that you may not charge for the software itself, regardless of purchase, license, or rental. You may however charge for installation and configuration of the software.

twitter-contest webadmin is released under the GNU General Public License v2, and is (c) 2010 Clayton Kendall, Inc. <http://www.claytonkendall.com>.

http://www.gnu.org/copyleft/gpl.html

==Requirements==
* Perl 5.5+
  * Perl DBI class (libdbi-perl or p5-dbi)
  * sqlite driver for dbi (libdbd-mysql-perl or p5-dbd-sqlite)
  * mysql driver for dbi (ibdbd-sqlite3-perl or p5-dbd-mysql)
  * Date::Parse (installable through CPAN if not in repos)
* PHP 5.2+
  * PDO (installable through PECL)
  * php5-sqlite
  * php5-mysqli
* SQLite 3
* MySQL 5+

==Setup==

Setup is fairly easy, but is best done at a command line.

===Config files===

Edit watcher/twitter-contest.pl to your liking to specify the terms which should be present in tweets. Also, ensure that the database connection settings is set correctly.

Next, set up the webadmin.

 Most of the PHP settings in webadmin/config/config.php should not need to be adjusted. They are primarily path settings. Simply ensure that webadmin/www is available from the web and that the database connection information is correct. This can be best done with a symlink from a web-visible area to that directory. 

Also, webadmin/var/templates_c and webadmin/var/cache should be writable by the webserver user. chmod 777 is probably the quickest way to do this.

==Database==
Next, ensure that the database is prepared. Import the schema for whatever database you are using. 

Ensure that you changed the database information in the configuration sections of the watcher and webadmin. There are two places it needs to be changed (lines are approximate):

* watcher/twitter-contest.pl lines 52-56
* webadmin/config/config.php lines 16-18

===MySQL===

    mysql -u [username] -p [database] < database/schema-mysql.sql

Or import it using phpmyadmin. You may need to remove the comments from the SQL file, as MySQL's comment syntax is different from other SQL engines.

===SQLite3===

Do this:
    sqlite3 database/contest.db
then
    .read database/schema-sqlite.sql
The latter, done at the SQLite3 command line, will import it. 

If you prefer to do it in a GUI, using SQLite Manager for Firefox to create a database and import the schema. It's probably the easiest-to-install GUI for SQLite.

==Running==

From the root directory, run start_watcher.sh. This will start ttytter with the appropriate options. Watch ttytter.log with [tail -f ttytter.log], or watch the process. Switch the commented lines at the end of start_watcher.sh if you want to see the output on your terminal.

==Etc==

SQlite should be sufficient for all but the largest of contests. MySQL might be easier for administration and/or replication.

If you use this for a sizable contest, let me know!
