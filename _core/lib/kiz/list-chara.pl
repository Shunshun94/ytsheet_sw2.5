################## 一覧表示 ##################
use strict;
#use warnings;
use utf8;
use open ":utf8";
use HTML::Template;

my $LOGIN_ID = check;

my $mode = $::in{'mode'};
my $sort = $::in{'sort'};

### テンプレート読み込み #############################################################################
my $INDEX;
$INDEX = HTML::Template->new( filename  => $set::skin_tmpl , utf8 => 1,
  path => ['./', $::core_dir."/skin/kiz", $::core_dir."/skin/_common", $::core_dir],
  search_path_on_include => 1,
  die_on_bad_params => 0, die_on_missing_include => 0, case_sensitive => 1, global_vars => 1);


$INDEX->param(modeList => 1);
$INDEX->param(modeMylist => 1) if $mode eq 'mylist';

$INDEX->param(LOGIN_ID => $LOGIN_ID);
$INDEX->param(OAUTH_MODE => $set::oauth_service);
$INDEX->param(OAUTH_LOGIN_URL => $set::oauth_login_url);

$INDEX->param(mode => $mode);

### データ処理 #######################################################################################
### クエリ --------------------------------------------------
my $index_mode;
foreach (keys %::in) {
  $::in{$_} =~ s/</&lt;/g;
  $::in{$_} =~ s/>/&gt;/g;
}
if(!($mode eq 'mylist' || $::in{'tag'} || $::in{'group'} || $::in{'name'} || $::in{'player'} || $::in{'class'} || $::in{'negai'} || $::in{'belong'} || $::in{'grow'} || $::in{'image'})){
  $index_mode = 1;
  $INDEX->param(modeIndex => 1);
  $INDEX->param(simpleMode => 1) if $set::simplelist;
}
my @q_links;
foreach(
  'mode',
  'tag',
  #'group',
  'name',
  'player',
  'class',
  'negai',
  'belong',
  'grow',
  'image',
  'fellow',
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
  while(my $line = <$FH>){
    if($line =~ /^(.+?)<>\[$LOGIN_ID\]</){ push(@mylist, $1) }
  }
  close($FH);
}

## リスト取得
my @list;
if($set::simpleindex && $index_mode){ #グループ見出しのみ
  my @grouplist;
  foreach (sort { $a->[1] cmp $b->[1] } @set::groups){
    push(@grouplist, {
      "ID" => @$_[0],
      "NAME" => @$_[2],
      "TEXT" => @$_[3],
    });
  }
  $INDEX->param("ListGroups" => \@grouplist);
}
else { #通常
  open (my $FH, "<", $set::listfile);
  @list = <$FH>;
  close($FH);
}
### フィルタ処理 --------------------------------------------------
## マイリスト
if($mode eq 'mylist'){
  my $regex = join('|', @mylist);
  @list = grep { $_ =~ /^(?:$regex)\</ } @list;
}
## 非表示除外
elsif (
     !($set::masterid && $set::masterid eq $LOGIN_ID)
  && !($mode eq 'mylist')
  && !$::in{'tag'}
){
  @list = grep { !(split(/<>/))[9] } @list;
}

## グループ
my %group_sort;
my %group_name;
my %group_text;
foreach (@set::groups){
  $group_sort{@$_[0]} = @$_[1];
  $group_name{@$_[0]} = @$_[2];
  $group_text{@$_[0]} = @$_[3];
}
$group_name{'all'} = 'すべて' if $::in{'group'} eq 'all';

## グループ検索
my $group_query = $::in{'group'};
if($group_query && $::in{'group'} ne 'all') {
  if($group_query eq $set::group_default){ @list = grep { $_ =~ /^(?:[^<]*?<>){6}(\Q$group_query\E)?</ } @list; }
  else { @list = grep { $_ =~ /^(?:[^<]*?<>){6}\Q$group_query\E</ } @list; }
}
$INDEX->param(group => $group_name{$group_query});

## タグ検索
my $tag_query = decode('utf8', $::in{'tag'});
if($tag_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){8}[^<]*? \Q$tag_query\E / } @list; }
$INDEX->param(tag => $tag_query);

## 名前検索
my $name_query = lc decode('utf8', $::in{'name'});
if($name_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){4}[^<]*?\Q$name_query\E/i } @list; }
$INDEX->param(name => $name_query);

## PL名検索
my $pl_query = decode('utf8', $::in{'player'});
if($pl_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){5}[^<]*?\Q$pl_query\E/i } @list; }
$INDEX->param(player => $pl_query);

## 種別検索
my $class_query = decode('utf8', $::in{'class'});
if($class_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){10}[^<]*?\Q$class_query\E/i } @list; }
$INDEX->param(class => $class_query);

## ネガイ検索
my @negai_query = split('\s', decode('utf8', $::in{'negai'}));
foreach my $q (@negai_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){11,12}[^<]*?\Q$q\E/ } @list; }
$INDEX->param(negai => "@negai_query");

## 所属検索
my @belong_query = split('\s', decode('utf8', $::in{'belong'}));
foreach my $q (@belong_query) { @list = grep { $_ =~ /^(?:[^<]*?<>){15}[^<]*?\Q$q\E/ } @list; }
$INDEX->param(belong => "@belong_query");

## 画像フィルタ
if($::in{'image'} == 1) {
  @list = grep { $_ =~ /^(?:[^<]*?<>){7}[^<0]/ } @list;
  $INDEX->param(image => 1);
}
elsif($::in{'image'} eq 'N') {
  @list = grep { $_ !~ /^(?:[^<]*?<>){7}[^<0]/ } @list;
  $INDEX->param(image => 1);
}
### ソート --------------------------------------------------
if   ($sort eq 'name')    { my @tmp = map { sortName((split /<>/)[4]) } @list; @list = @list[sort {$tmp[$a] cmp $tmp[$b]} 0 .. $#tmp]; }
elsif($sort eq 'pl')      { my @tmp = map { (split /<>/)[5]           } @list; @list = @list[sort {$tmp[$a] cmp $tmp[$b]} 0 .. $#tmp]; }
elsif($sort eq 'date')    { my @tmp = map { (split /<>/)[3]           } @list; @list = @list[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp]; }
elsif($sort eq 'hibiware'){ my @tmp = map { (split /<>/)[18]          } @list; @list = @list[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp]; }
elsif($sort eq 'kizuna')  { my @tmp = map { (split /<>/)[17]          } @list; @list = @list[sort {$tmp[$b] <=> $tmp[$a]} 0 .. $#tmp]; }

sub sortName { $_[0] =~ s/^“.*”//; return $_[0]; }

### リストを回す --------------------------------------------------
my %count; my %pl_flag;
my %grouplist;
my $page = $::in{'page'} ? $::in{'page'} : 1;
my $pagestart = $page * $set::pagemax - $set::pagemax;
my $pageend   = $page * $set::pagemax - 1;
foreach (@list) {
  my (
    $id, undef, undef, $updatetime, $name, $player, $group, #0-6
    $image, $tag, $hide, #7-9
    $class, $outside, $inside, $gender, $age, #10-14
    $belong, $bigamy, $kizuna, $hibiware #15-18
  ) = (split /<>/, $_)[0..18];
  
  #グループ
  $group = $set::group_default if (!$group || !$group_name{$group});
  $group = 'all' if $::in{'group'} eq 'all';
  
  #カウント
  $count{'PC'}{$group}++;
  $count{'PL'}{$group}++ if !$pl_flag{$group}{$player};
  $pl_flag{$group}{$player} = 1;

  #表示域以外は弾く
  if (
    ( $index_mode && $count{'PC'}{$group} > $set::list_maxline && $set::list_maxline) || #TOPページ
    (!$index_mode && $set::pagemax && ($count{'PC'}{$group} < $pagestart || $count{'PC'}{$group} > $pageend)) #それ以外
  ){
    next;
  }
  
  #名前
  $name =~ s/^“(.*)”(.*)/<span>“$1”<\/span><span>$2<\/span>/;
  
  ## シンプルリスト
  if($index_mode && $set::simplelist){
    #出力用配列へ
    my @characters;
    push(@characters, {
      "ID" => $id,
      "NAME" => $name,
      "PLAYER" => $player,
      "GROUP" => $group,
      "CLASS" => $class,
      "HIDE" => $hide,
    });
    push(@{$grouplist{$group}}, @characters);
  }
  ## 通常リスト
  else {
    #性別
    $gender = genderConvert($gender);
    
    #年齢
    $age =~ s/^(.+?)[\(（].*?[）\)]$/$1/;
    $age =~ tr/０-９/0-9/;
    
    #更新日時
    my ($min,$hour,$day,$mon,$year) = (localtime($updatetime))[1..5];
    $year += 1900; $mon++;
    $updatetime = sprintf("<span>%04d-</span><span>%02d-%02d</span> <span>%02d:%02d</span>",$year,$mon,$day,$hour,$min);
    
    #出力用配列へ
    my @characters;
    push(@characters, {
      "ID" => $id,
      "NAME" => $name,
      "PLAYER" => $player,
      "GROUP" => $group,
      "AGE" => $age,
      "GENDER" => $gender,
      "CLASS" => $class,
      "NEGAI" => $outside.'／'.$inside,
      "BELONG" => $belong,
      "KIZUNA" => $kizuna,
      "HIBIWARE" => $hibiware,
      "DATE" => $updatetime,
      "HIDE" => $hide,
    });
    push(@{$grouplist{$group}}, @characters);
  }
}

### 出力用配列 --------------------------------------------------
my @characterlists; 
foreach (sort {$group_sort{$a} <=> $group_sort{$b}} keys %grouplist){
  ## ページネーション
  my $navbar;
  if($set::pagemax && !$index_mode && $::in{'group'}){
    my $lastpage = ceil($count{'PC'}{$_} / $set::pagemax);
    foreach(1 .. $lastpage){
      if($_ == $page){
        $navbar .= '<b>'.$_.'</b> ';
      }
      elsif(
        ($_ <= $page + 4 && $_ >= $page - 4) ||
        $_ == 1 ||
        $_ == $lastpage
      ){
        $navbar .= '<a href="./?group='.$::in{'group'}.'&'.$q_links.'&page='.$_.'&sort='.$::in{'sort'}.'">'.$_.'</a> '
      }
      else { $navbar .= '...' }
    }
    $navbar =~ s/\.{3,}/... /g;
  }
  $navbar = '<div class="navbar">'.$navbar.'</div>' if $navbar;
  
  ##
  push(@characterlists, {
    "ID" => $_,
    "NAME" => $group_name{$_},
    "TEXT" => $group_text{$_},
    "NUM-PC" => $count{'PC'}{$_},
    "NUM-PL" => $count{'PL'}{$_},
    "Characters" => [@{$grouplist{$_}}],
    "NAV" => $navbar,
  });
}

$INDEX->param("qLinks" => $q_links);

$INDEX->param("Lists" => \@characterlists);


$INDEX->param("title" => $set::title);
$INDEX->param("ver" => $::ver);
$INDEX->param("coreDir" => $::core_dir);

### 出力 #############################################################################################
print "Content-Type: text/html\n\n";
print $INDEX->output;

1;