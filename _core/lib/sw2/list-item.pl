################## 一覧表示 ##################
use strict;
#use warnings;
use utf8;
use open ":utf8";
use HTML::Template;

my $LOGIN_ID = check;

my $mode = $::in{'mode'};
my $sort = $::in{'sort'};

#require $set::data_item;

### テンプレート読み込み #############################################################################
my $INDEX;
$INDEX = HTML::Template->new( filename  => $set::skin_tmpl , utf8 => 1,
  path => ['./', $::core_dir."/skin/sw2", $::core_dir."/skin/_common", $::core_dir],
  search_path_on_include => 1,
  die_on_bad_params => 0, die_on_missing_include => 0, case_sensitive => 1, global_vars => 1);

$INDEX->param(modeItemList => 1);
$INDEX->param(modeMylist => 1) if $mode eq 'mylist';
$INDEX->param(typeName => 'アイテム');

$INDEX->param(LOGIN_ID => $LOGIN_ID);
$INDEX->param(OAUTH_MODE => $set::oauth_service);
$INDEX->param(OAUTH_LOGIN_URL => $set::oauth_login_url);

$INDEX->param(mode => $mode);
$INDEX->param(type => 'i');

### データ処理 #######################################################################################
### クエリ --------------------------------------------------
my $index_mode;
if(!($mode eq 'mylist' || $::in{'tag'} || $::in{'category'} || $::in{'name'} || $::in{'author'})){
  $index_mode = 1;
  $INDEX->param(modeIndex => 1);
}
my @q_links;
foreach(
  'mode',
  'tag',
  #'group',
  'name',
  'category',
  'author',
  ){
  push( @q_links, $_.'='.uri_escape_utf8(decode('utf8', param($_))) ) if param($_);
}
my $q_links = join('&', @q_links);

### ファイル読み込み --------------------------------------------------
## マイリスト取得
my @mylist;
if($mode eq 'mylist'){
  $INDEX->param( playerName => (getplayername($LOGIN_ID))[0] );
  open (my $FH, "<", $set::passfile);
  while(<$FH>){
    my @data = (split /<>/, $_)[0,1];
    if($data[1] eq "\[$LOGIN_ID\]"){ push(@mylist, $data[0]) }
  }
  close($FH);
}

## リスト取得
open (my $FH, "<", $set::itemlist);
my @list = sort { (split(/<>/,$b))[3] <=> (split(/<>/,$a))[3] } <$FH>;
close($FH);

### フィルタ処理 --------------------------------------------------
## マイリスト
if($mode eq 'mylist'){
  my $regex = join('|', @mylist);
  @list = grep { (split(/<>/))[0] =~ /^(?:$regex)$/ } @list;
}
## 非表示除外
elsif (
     !($set::masterid && $set::masterid eq $LOGIN_ID)
  && !($mode eq 'mylist')
  && !$::in{'tag'}
){
  @list = grep { !(split(/<>/))[13] } @list;
}

## 分類検索
my $category_query = decode('utf8', $::in{'category'});
if($category_query && $::in{'category'} ne 'all') {
  @list = grep { (split(/<>/))[6] eq $category_query } @list;
  
}
$INDEX->param(category => $category_query);

## タグ検索
my $tag_query = decode('utf8', $::in{'tag'});
if($tag_query) { @list = grep { (split(/<>/))[12] =~ / $tag_query / } @list; }
$INDEX->param(tag => $tag_query);

## 名前検索
my $name_query = decode('utf8', $::in{'name'});
if($name_query) { @list = grep { (split(/<>/))[4] =~ /$name_query/ } @list; }
$INDEX->param(name => $name_query);

### リストを回す --------------------------------------------------
my %count;
my %grouplist;
foreach (@list) {
  my (
    $id, undef, undef, $updatetime, $name, $author, $category, $price, $age, $summary, $type,
    $image, $tag, $hide
  ) = (split /<>/, $_)[0..13];
  
  #カウント
  $count{'すべて'}++;
  #最大表示制限
  next if ($index_mode && $count{'すべて'} > $set::list_maxline && $set::list_maxline);
  
  #グループ（分類）
  $category =~ s/[ 　]/<br>/g;
  
  #更新日時
  my ($min,$hour,$day,$mon,$year) = (localtime($updatetime))[1..5];
  $year += 1900; $mon++;
  $updatetime = sprintf("<span>%04d-</span><span>%02d-%02d</span> <span>%02d:%02d</span>",$year,$mon,$day,$hour,$min);
  
  #出力用配列へ
  my @characters;
  push(@characters, {
    "ID" => $id,
    "NAME" => $name,
    "AUTHOR" => $author,
    "CATEGORY" => $category,
    "PRICE" => $price,
    "AGE" => $age,
    "SUMMARY" => $summary,
    "MAGIC" => ($type =~ /\[ma\]/ ? "<img class=\"${set::icon_dir}wp_magic.png\">" : ''),
    "DATE" => $updatetime,
    "HIDE" => $hide,
  });
  
  push(@{$grouplist{'すべて'}}, @characters);
}

### 出力用配列 --------------------------------------------------
my @characterlists; 
my $page = $::in{'page'} ? $::in{'page'} : 1;
my $pagestart = $page * $set::pagemax - $set::pagemax;
my $pageend   = $page * $set::pagemax - 1;
our @categories = (
  ['すべて','']
);
foreach (@categories){
  my $name = $_->[0];
  next if !$count{$name};

  ## ソート
  if($sort eq 'author')  { @{$grouplist{$name}} = sort { $a->{'AUTHOR'} cmp $b->{'AUTHOR'} } @{$grouplist{$name}}; }
  elsif($sort eq 'date'){ @{$grouplist{$name}} = sort { $b->{'DATE'} <=> $a->{'DATE'} } @{$grouplist{$name}}; }
  
  ## ページネーション
  my $navbar;
  if($set::pagemax && !$index_mode){
    my $pageend = ($count{$name}-1 < $pageend) ? $count{$name}-1 : $pageend;
    @{$grouplist{$name}} = @{$grouplist{$name}}[$pagestart .. $pageend];
    foreach(1 .. ceil($count{$name} / $set::pagemax)){
      if($_ == $page){  $navbar .= '<b>'.$_.'</b> '}
      else { $navbar .= '<a href="./?type=i&category='.$::in{'category'}.'&'.$q_links.'&page='.$_.'&sort='.$::in{'sort'}.'">'.$_.'</a> ' }
    }
  }
  $navbar = '<div class="navbar">'.$navbar.'</div>' if $navbar;

  ##
  push(@characterlists, {
    "URL" => uri_escape_utf8($name),
    "NAME" => $name,
    "NUM" => $count{$name},
    "Characters" => [@{$grouplist{$name}}],
    "NAV" => $navbar,
  });
}

$INDEX->param("qLinks" => $q_links);

$INDEX->param("Lists" => \@characterlists);


$INDEX->param("title" => $set::title);
$INDEX->param("ver" => $::ver);
$INDEX->param("coreDir" => $::core_dir);

### ディレクトリ指定 --------------------------------------------------
$INDEX->param("coreDir" => $::core_dir);

### 出力 #############################################################################################
print "Content-Type: text/html\n\n";
print $INDEX->output;

1;