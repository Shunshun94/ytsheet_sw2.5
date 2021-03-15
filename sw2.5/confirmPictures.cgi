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
print "<html><head><style>td{max-width:240px;}</style><meta charset='UTF-8'></head><body><table border='1' id='list'>";

my $lastNumber;
foreach (@list) {
  my (
    $id, $number, undef, $updatetime, $name, $player, undef,
    undef, undef, undef, undef, undef, undef,
    undef, undef, $image, undef, $hide, undef
  ) = (split /<>/, $_)[0..18];
  if($image && ( !($PLAYER_QUERY) || ($PLAYER_QUERY eq $player) )) {
      if( (!($FROM) || ($FROM >= $number)) && ($count > 0)) {
        print "<tr id='$id' class='hidden_$hide'>";
        print "<td><a target='_blank' href='./?id=$id'>$name</a></td>";
        print "<td><a href='./confirmPictures.cgi?player=$player'>$player</a></td>";
        print "<td><img id='image_$id' width='200' height='200' /><br/>";
        print "<span id='from_$id'></span>";
        print "</td></tr>";
        $count--;
        $lastNumber = $number;
      }
  }
}

print "</table>";
Encode::decode('utf8', $PLAYER_QUERY);
print "<p><a id='goNext' href='./confirmPictures.cgi?from=$lastNumber&count=$FROM_COUNT&player='>次のページに進む</a></p>";
print "<script src='./confirmPictures.js'></script></body></html>";
