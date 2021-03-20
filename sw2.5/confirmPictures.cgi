#!/usr/bin/perl

use strict;
use utf8;
use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:all/;

our $core_dir = '../_core';
use lib '../_core/module';

require $core_dir.'/lib/sw2/config-default.pl';
require './config.cgi';
require $core_dir.'/lib/subroutine.pl';
require $core_dir.'/lib/oauth.pl';

my $LOGIN_ID = &check;
my $FROM = param('from') || "";
my $FROM_COUNT = param('count') || 50;
my $count = param('count') || 50;
my $PLAYER_QUERY = param('player') || "";

if (!($set::masterid && $set::masterid eq $LOGIN_ID)) {
    &error("管理人じゃないと見れません");
}

my %grouplist;
open (my $FH, "<", $set::listfile);
my @list = sort { (split(/<>/,$b))[1] <=> (split(/<>/,$a))[1] } <$FH>;
close($FH);

print "Status: 200 OK\n";
print "Content-type: text/html\n\n";
print "<html><head><style>td{max-width:240px;}textarea{resize: none;}</style><meta charset='UTF-8'></head><body><table border='1' id='list'>";

my $lastNumber;
foreach (@list) {
  my (
    $id, $number, undef, $updatetime, $name, $player, undef,
    undef, undef, undef, undef, undef, undef,
    undef, undef, $image, undef, $hide, undef
  ) = (split /<>/, $_)[0..18];
  if($image && ( !($PLAYER_QUERY) || ($PLAYER_QUERY eq $player) )) {
      if( (!($FROM) || ($FROM >= $number)) && ($count > 0)) {
        print "<tr title='$number' id='$id' class='hidden_$hide'>";
        print "<td><a target='_blank' href='./?id=$id' class='name' id='name_$id'>dummy</a></td>";
        print "<td><a class='user' id='user_$id'>dummy</a></td>";
        print "<td><img class='image' id='image_$id' width='200' height='200' /><br/>";
        print "<span id='from_$id'></span>";
        print "</td>";
        # 削除フローチャート（ゆとらいず工房）https://twitter.com/yutorize/status/1369201449339482112
        print "<td><input type='checkbox' value='check1' class='check1' id='check1_$id' />転載である</td>";
        print "<td><input type='checkbox' value='check2' class='check2' id='check2_$id' />ルール外の転載である</td>";
        print "<td>詳細<br/><textarea rows='15' cols='15' class='check3' id='check3_$id'></textarea></td>";
        print "</tr>";
        $count--;
        $lastNumber = $number;
      }
  }
}

print "</table>";
Encode::decode('utf8', $PLAYER_QUERY);
print "<p><a id='goNext' href='./confirmPictures.cgi?from=$lastNumber&count=$FROM_COUNT&player='>次のページに進む</a></p>";
print "<p style='text-align:right;'><button style='background-color:peachpuff;' id='execDelete'>チェックしたものを削除する</button></p>";
print "<script src='./confirmPictures.js'></script></body></html>";
