#!/usr/bin/perl

use strict;
use utf8;
binmode STDOUT, ':utf8';
use CGI::Carp qw(fatalsToBrowser);
use CGI qw/:all/;
use LWP::UserAgent;
use JSON::PP;

our $core_dir = '../_core';
use lib '../_core/module';

require $core_dir.'/lib/sw2/config-default.pl';
require './config.cgi';
require $core_dir.'/lib/subroutine.pl';
require $core_dir.'/lib/oauth.pl';

sub error {
    die shift;
}

sub urlDataGet {
  my $url = shift;
  my $ua  = LWP::UserAgent->new;
  my $res = $ua->get($url);
  if ($res->is_success) {
    return $res->decoded_content;
  }
  else {
    return undef;
  }
}

sub getDataFromYtsheet {
  my $set_url = shift;
  my $data    = urlDataGet($set_url.'&mode=json') or error 'コンバート元のデータが取得できませんでした。URL:'.$set_url;
  if($data !~ /^{/){ error 'JSONデータが取得できませんでした' }
  my %pc = %{ decode_json(join '', $data) };
  if($pc{'result'} eq 'OK'){
    our $base_url = $set_url;
    $base_url =~ s|/[^/]+?$|/|;
    $pc{'convertSource'} = '別のゆとシートⅡ';
    return %pc;
  }
  elsif($pc{'result'}) {
    error 'コンバート元のゆとシートⅡでエラーがありました。<br>>'.$pc{'result'};
  }
  else {
    error '有効なデータが取得できませんでした';
  }
}

my $url = param('sheet');
my $before = param('before');
my $after  = param('after');

my $beforeUrl = $url.'&log='.$before;
my $afterUrl  = $url.'&log='.$after;

my %beforeData = getDataFromYtsheet($beforeUrl);
my %afterData  = getDataFromYtsheet($afterUrl);

print "Status: 200 OK\n";
print "Content-type: application/json\n\n";

sub is_ignorable {
  my $column = shift;
  my @ignore = ('freeNote', 'freeHistory', 'cashbook', 'items');
  return grep { $_ eq $column } @ignore;
}

my %result;

foreach my $column(keys(%afterData)){
  my $afterText  = $afterData{$column};
  my $beforeText = $beforeData{$column};
  if( is_ignorable($column) ) {
    $result{$column} = '比較対象外です';
  }
  elsif ($column eq 'updateTime') {
    $result{'updateTime'} = '[[Before('.$beforeData{'updateTime'}.')&gt;'.$beforeUrl.']] / [[After('.$afterData{'updateTime'}.')&gt;'.$afterUrl.']]';
  }
  else {
    if($afterText ne $beforeText) {
      if($beforeText) {
        if($column =~ /Num$/) {
          $result{$column} = $beforeText > $afterText ? $beforeText : $afterText;
        }
        elsif ($column =~ /^image/) {
          $result{$column} = $afterText;
        }
        elsif ($column eq 'level') {
          if( $beforeText > $afterText ) {
            $result{$column} = $beforeText.'→__'.$afterText.'__';
          }
          else {
            $result{$column} = $afterText.'←%%'.$beforeText.'%%';
          }
        }
        else {
          $result{$column} = $beforeText.'&gt;__'.$afterText.'__';
        }
      }
      else {
        $result{$column} = '__'.$afterText.'__';
      }
    }
    else {
      $result{$column} = $afterText;
    }
  }
}
foreach my $column(keys(%beforeData)){
  if(($result{$column} eq "") && ($beforeData{$column}) ) {
    $result{$column} = '%%'.$beforeData{$column}.'%%';
  }
}
$result{'convertSource'} = 'ゆとシート履歴比較ツール';
$result{'sourceUrls'} = $url;
$result{'unableConvert'} = 1;

my $jsonText = JSON::PP->new->canonical(1)->encode( \%result );
print $jsonText;
