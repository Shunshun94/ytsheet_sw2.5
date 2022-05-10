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

our %in;
for (param()){ $in{$_} = param($_); }

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
  my $data    = urlDataGet($set_url.'&mode=json') or error 'Could not access to url '.$set_url;
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

our %beforeData = getDataFromYtsheet($in{'before'});
our %afterData = getDataFromYtsheet($in{'after'});

print "Status: 200 OK\n";
print "Content-type: text/html\n\n";

print $beforeData{'characterName'};
print $beforeData{'characterName'};
