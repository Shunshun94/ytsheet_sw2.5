############# フォーム・キャラクター #############
use strict;
#use warnings;
use utf8;
use open ":utf8";
use feature 'say';

my $LOGIN_ID = $::LOGIN_ID;

### 読込前処理 #######################################################################################
require $set::lib_palette_sub;
### 各種データライブラリ読み込み --------------------------------------------------
require $set::consts;
my @skillLevel = (
  '得意', '不得意'
);

my @awakens;
my @impulses;
push(@awakens , @$_[0]) foreach(@data::awakens);
push(@impulses, @$_[0]) foreach(@data::impulses);

### データ読み込み ###################################################################################
my ($data, $mode, $file, $message) = pcDataGet($::in{'mode'});
our %pc = %{ $data };

my $mode_make = ($mode =~ /^(blanksheet|copy|convert)$/) ? 1 : 0;

### 出力準備 #########################################################################################
if($message){
  my $name = tag_unescape($pc{'characterName'} || $pc{'aka'} || '無題');
  $message =~ s/<!NAME>/$name/;
}
### プレイヤー名 --------------------------------------------------
if($mode_make && !$::make_error){
  $pc{'playerName'} = (getplayername($LOGIN_ID))[0];
}
### 初期設定 --------------------------------------------------
if($mode_make){ $pc{'protect'} ||= $LOGIN_ID ? 'account' : 'password'; }

if($mode eq 'edit' || ($mode eq 'convert' && $pc{'ver'})){
  %pc = data_update_chara(\%pc);
  if($pc{'updateMessage'}){
    $message .= "<hr>" if $message;
    $message .= "<h2>アップデート通知</h2><dl>";
    foreach (sort keys %{$pc{'updateMessage'}}){
      $message .= '<dt>'.$_.'</dt><dd>'.$pc{'updateMessage'}{$_}.'</dd>';
    }
    (my $lasttimever = $pc{'lasttimever'}) =~ s/([0-9]{3})$/\.$1/;
    $message .= "</dl><small>前回保存時のバージョン:$lasttimever</small>";
  }
}
elsif($mode eq 'blanksheet' && !$::make_error){
  $pc{'group'} = $set::group_default;
  
  $pc{'history0Exp'}   = $set::make_exp;
  
  $pc{'paletteUseBuff'} = 1;
}

$pc{'imageFit'} = $pc{'imageFit'} eq 'percent' ? 'percentX' : $pc{'imageFit'};
$pc{'imagePercent'} = $pc{'imagePercent'} eq '' ? '200' : $pc{'imagePercent'};
$pc{'imagePositionX'} = $pc{'imagePositionX'} eq '' ? '50' : $pc{'imagePositionX'};
$pc{'imagePositionY'} = $pc{'imagePositionY'} eq '' ? '50' : $pc{'imagePositionY'};
$pc{'wordsX'} ||= '右';
$pc{'wordsY'} ||= '上';

$pc{'colorHeadBgH'} = $pc{'colorHeadBgH'} eq '' ? 225 : $pc{'colorHeadBgH'};
$pc{'colorHeadBgS'} = $pc{'colorHeadBgS'} eq '' ?   9 : $pc{'colorHeadBgS'};
$pc{'colorHeadBgL'} = $pc{'colorHeadBgL'} eq '' ?  65 : $pc{'colorHeadBgL'};
$pc{'colorBaseBgH'} = $pc{'colorBaseBgH'} eq '' ? 210 : $pc{'colorBaseBgH'};
$pc{'colorBaseBgS'} = $pc{'colorBaseBgS'} eq '' ?   0 : $pc{'colorBaseBgS'};
$pc{'colorBaseBgL'} = $pc{'colorBaseBgL'} eq '' ? 100 : $pc{'colorBaseBgL'};

$pc{'skillCompNum'} ||= 2;
$pc{'skillArtNum'}  ||= 2;
$pc{'skillKnowNum'} ||= 2;
$pc{'talentNum'}  ||= 2;
$pc{'cheatNum'}   ||= 3;
$pc{'weaponNum'}  ||= 1;
$pc{'armorNum'}   ||= 1;
$pc{'itemNum'}    ||= 2;
$pc{'historyNum'} ||= 3;

### 折り畳み判断 --------------------------------------------------
my %open;
foreach (
  'skillMelee','skillRanged','skillRC','skillNegotiate',
  'skillDodge','skillPercept','skillWill','skillProcure',
){
  if ($pc{$_}){ $open{'skill'} = 'open'; last; }
}
foreach (
    'skillRide','skillArt','skillKnow','skillInfo',
){
  foreach my $num (1..$pc{$_.'Num'}){
    if ($pc{$_.$num}){ $open{'skill'} = 'open'; last; }
  }
}
if  ($pc{"lifepathOrigin"}
  || $pc{"lifepathExperience"}
  || $pc{"lifepathEncounter"}
  || $pc{"lifepathAwaken"}
  || $pc{"lifepathImpulse"}  ){ $open{'lifepath'} = 'open'; }
if  ($pc{"insanity"}
  || $pc{"insanityNote"}){ $open{'insanity'} = 'open'; }
foreach (1..7){ if($pc{"lois${_}Relation"} || $pc{"lois${_}Name"}  ){ $open{'lois'}   = 'open'; last; } }
foreach (1..3){ if($pc{"memory${_}Gain"}   || $pc{"memory${_}Name"}){ $open{'memory'} = 'open'; last; } }
foreach (1..$pc{'comboNum'}) { if($pc{"combo${_}Name"} || $pc{"combo${_}Combo"}){ $open{'combo'} = 'open'; last; } }
foreach (3..$pc{'effectNum'}){ if($pc{"effect${_}Name"} || $pc{"effect${_}Lv"}){ $open{'effect'} = 'open'; last; } }
foreach (1..$pc{'magicNum'}){ if($pc{"magic${_}Name"} || $pc{"magic${_}Exp"}){ $open{'magic'} = 'open'; last; } }
foreach (1..$pc{'weaponNum'})  { if($pc{"weapon${_}Name"})  { $open{'item'} = 'open'; last; } }
foreach (1..$pc{'armorNum'})   { if($pc{"armor${_}Name"})   { $open{'item'} = 'open'; last; } }
foreach (1..$pc{'vehiclesNum'}){ if($pc{"vehicles${_}Name"}){ $open{'item'} = 'open'; last; } }
foreach (1..$pc{'itemNum'})    { if($pc{"item${_}Name"})    { $open{'item'} = 'open'; last; } }


### 改行処理 --------------------------------------------------
$pc{'words'}         =~ s/&lt;br&gt;/\n/g;
$pc{'freeNote'}      =~ s/&lt;br&gt;/\n/g;
$pc{'freeHistory'}   =~ s/&lt;br&gt;/\n/g;
$pc{'chatPalette'}   =~ s/&lt;br&gt;/\n/g;
$pc{"combo${_}Note"}   =~ s/&lt;br&gt;/\n/g foreach (1 .. $pc{'comboNum'});
$pc{"weapon${_}Note"}  =~ s/&lt;br&gt;/\n/g foreach (1 .. $pc{'weaponNum'});
$pc{"armor${_}Note"}   =~ s/&lt;br&gt;/\n/g foreach (1 .. $pc{'armorNum'});
$pc{"vehicle${_}Note"} =~ s/&lt;br&gt;/\n/g foreach (1 .. $pc{'vehicleNum'});
$pc{"item${_}Note"}    =~ s/&lt;br&gt;/\n/g foreach (1 .. $pc{'itemNum'});

### フォーム表示 #####################################################################################
my $titlebarname = tag_delete name_plain tag_unescape $pc{'characterName'} if $pc{'characterName'};
print <<"HTML";
Content-type: text/html\n
<!DOCTYPE html>
<html lang="ja">

<head>
  <meta charset="UTF-8">
  <title>@{[$mode eq 'edit'?"編集：$titlebarname" : '新規作成']} - $set::title</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" media="all" href="${main::core_dir}/skin/_common/css/base.css?${main::ver}">
  <link rel="stylesheet" media="all" href="${main::core_dir}/skin/_common/css/sheet.css?${main::ver}">
  <link rel="stylesheet" media="all" href="${main::core_dir}/skin/rb/css/chara.css?${main::ver}">
  <link rel="stylesheet" media="all" href="${main::core_dir}/skin/_common/css/edit.css?${main::ver}">
  <link rel="stylesheet" media="all" href="${main::core_dir}/skin/rb/css/edit.css?${main::ver}">
  <script src="${main::core_dir}/skin/_common/js/lib/Sortable.min.js"></script>
  <script src="${main::core_dir}/lib/edit.js?${main::ver}" defer></script>
  <script src="${main::core_dir}/lib/rb/edit-chara.js?${main::ver}" defer></script>
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/all.css" integrity="sha384-mzrmE5qonljUremFsqc01SB46JvROS7bZs3IO2EmfFsd15uHvIt+Y8vEf7N7fWAU" crossorigin="anonymous">
  <style>
    #image,
    .image-custom-view {
      background-image: url("${set::char_dir}${file}/image.$pc{'image'}?$pc{'imageUpdate'}");
    }
  </style>
</head>
<body>
  <script src="${main::core_dir}/skin/_common/js/common.js?${main::ver}"></script>
  <header>
    <h1>$set::title</h1>
  </header>

  <main>
    <article>
      <form name="sheet" method="post" action="./" enctype="multipart/form-data" onsubmit="return formCheck();">
      <input type="hidden" name="ver" value="${main::ver}">
HTML
if($mode_make){
  print '<input type="hidden" name="_token" value="'.token_make().'">'."\n";
}
print <<"HTML";
      <input type="hidden" name="mode" value="@{[ $mode eq 'edit' ? 'save' : 'make' ]}">
      
      <div id="header-menu">
        <h2><span></span></h2>
        <ul>
          <li onclick="sectionSelect('common');"><span>キャラクター</span><span>データ</span></li>
          <!--<li onclick="sectionSelect('palette');"><span>チャット</span><span>パレット</span></li>-->
          <li onclick="sectionSelect('color');"><span>カラー</span><span>カスタム</span></li>
          <li class="button">
HTML
if($mode eq 'edit'){
print <<"HTML";
            <input type="button" value="複製" onclick="window.open('./?mode=copy&id=$::in{'id'}@{[  $::in{'backup'}?"&backup=$::in{'backup'}":'' ]}');">
HTML
}
print <<"HTML";
            <input type="submit" value="保存">
          </li>
        </ul>
      </div>
      
      <aside class="message">$message</aside>

      <section id="section-common">
      <div class="box" id="name-form">
        <div>
          <dl id="character-name">
            <dt>キャラクター名</dt>
            <dd>@{[input('characterName','text',"nameSet")]}</dd>

          </dl>
          <dl id="aka">
            <dt>ふたつ名</dt>
            <dd>@{[input('aka','text',"nameSet")]}</dd>
            <dt class="ruby">フリガナ</dt>
            <dd>@{[input('akaRuby','text',"nameSet")]}</dd>
          </dl>
        </div>
        <dl id="player-name">
          <dt>プレイヤー名</dt>
          <dd>@{[input('playerName')]}</dd>
        </dl>
      </div>
HTML
if($set::user_reqd){
  print <<"HTML";
    <input type="hidden" name="protect" value="account">
    <input type="hidden" name="protectOld" value="$pc{'protect'}">
    <input type="hidden" name="pass" value="$::in{'pass'}">
HTML
}
else {
  if($set::registerkey && $mode_make){
    print '登録キー：<input type="text" name="registerkey" required>'."\n";
  }
  print <<"HTML";
      <details class="box" id="edit-protect" @{[$mode eq 'edit' ? '':'open']}>
      <summary>編集保護設定</summary>
      <p id="edit-protect-view"><input type="hidden" name="protectOld" value="$pc{'protect'}">
HTML
  if($LOGIN_ID){
    print '<input type="radio" name="protect" value="account"'.($pc{'protect'} eq 'account'?' checked':'').'> アカウントに紐付ける（ログイン中のみ編集可能になります）<br>';
  }
    print '<input type="radio" name="protect" value="password"'.($pc{'protect'} eq 'password'?' checked':'').'> パスワードで保護 ';
  if ($mode eq 'edit' && $pc{'protect'} eq 'password' && $::in{'pass'}) {
    print '<input type="hidden" name="pass" value="'.$::in{'pass'}.'"><br>';
  } else {
    print '<input type="password" name="pass"><br>';
  }
  print <<"HTML";
<input type="radio" name="protect" value="none"@{[ $pc{'protect'} eq 'none'?' checked':'' ]}> 保護しない（誰でも編集できるようになります）
      </p>
      </details>
HTML
}
  print <<"HTML";
      <dl class="box" id="hide-options">
        <dt>閲覧可否設定</dt>
        <dd id="forbidden-checkbox">
          <select name="forbidden">
            <option value="">内容を全て開示する
            <option value="battle" @{[ $pc{'forbidden'} eq 'battle' ? 'selected' : '' ]}>データ・数値のみ秘匿する
            <option value="all"    @{[ $pc{'forbidden'} eq 'all'    ? 'selected' : '' ]}>内容を全て秘匿する
          </select>
        </dd>
        <dd id="hide-checkbox">
          <select name="hide">
            <option value="">一覧に表示
            <option value="1" @{[ $pc{'hide'} ? 'selected' : '' ]}>一覧には非表示
          </select>
          ※タグ検索結果・マイリストには表示されます
        </dd>
      </dl>
      <div class="box" id="group">
        <dl>
          <dt>グループ</dt><dd><select name="group">
HTML
foreach (@set::groups){
  my $id   = @$_[0];
  my $name = @$_[2];
  my $exclusive = @$_[4];
  next if($exclusive && (!$LOGIN_ID || $LOGIN_ID !~ /^($exclusive)$/));
  print '<option value="'.$id.'"'.($pc{'group'} eq $id ? ' selected': '').'>'.$name.'</option>';
}
print <<"HTML";
          </select></dd>
          <dt>タグ</dt><dd>@{[ input 'tags','','checkStage','' ]}</dd>
        </dl>
      </div>
      <div id="area-status">
        @{[ image_form ]}

        <div class="box-union" id="personal">
          <dl class="box"><dt>年齢  </dt><dd>@{[input "age"]}</dd></dl>
          <dl class="box"><dt>性別  </dt><dd>@{[input "gender",'','','list="list-gender"']}</dd></dl>
          <dl class="box"><dt>身長  </dt><dd>@{[input "height"]}</dd></dl>
          
          <dl class="box"><dt>髪の色</dt><dd>@{[input "hair"]}</dd></dl>
          <dl class="box"><dt>瞳の色</dt><dd>@{[input "eyes"]}</dd></dl>
          <dl class="box"><dt>肌の色</dt><dd>@{[input "skin"]}</dd></dl>
          
          <dl class="box"><dt>IGR</dt><dd>
          <select name="igr" oninput="calcStt();">@{[ option 'igr',@data::igrs ]}</select>
          </dd></dl>
          <dl class="box"><dt>エレメント</dt><dd>
          <select name="element" oninput="calcStt();">@{[ option 'element',@data::elements ]}</select>
          </dd></dl>

          <dl class="box"><dt>出身</dt><dd>
          <select name="home" oninput="">@{[ option 'home',@data::homes ]}</select>
          </dd></dl>
        </div>
        <div class="box" id="syndrome-status">
          <h2>能力値 [<span id="exp-status">0</span>]</h2>
          <table>
            <thead>
              <tr><th></th><th>身体</th><th>感覚</th><th>知力</th><th>意志</th><th>魅力</th><th>社会</th></tr>
            </thead>
            <tbody>
              <tr>
                <th></th>
                <td id="stt-base-Body"         ></td>
                <td id="stt-base-Sense"        ></td>
                <td id="stt-base-Intelligence" ></td>
                <td id="stt-base-Will"         ></td>
                <td id="stt-base-Charm"        ></td>
                <td id="stt-base-Social"       ></td>
              </tr>
              <tr>
                <th><small>ボーナス</small></th>
                <td>@{[input "sttBonusBody"  ,'number','calcStt']}</td>
                <td>@{[input "sttBonusSense"  ,'number','calcStt']}</td>
                <td>@{[input "sttBonusIntelligence"  ,'number','calcStt']}</td>
                <td>@{[input "sttBonusWill"  ,'number','calcStt']}</td>
                <td>@{[input "sttBonusCharm"  ,'number','calcStt']}</td>
                <td>@{[input "sttBonusSocial"  ,'number','calcStt']}</td>
              </tr>

              <tr>
                <th>成長</th>
                <td>@{[input "sttGrowBody"  ,'number','calcStt']}</td>
                <td>@{[input "sttGrowSense"  ,'number','calcStt']}</td>
                <td>@{[input "sttGrowIntelligence"  ,'number','calcStt']}</td>
                <td>@{[input "sttGrowWill"  ,'number','calcStt']}</td>
                <td>@{[input "sttGrowCharm"  ,'number','calcStt']}</td>
                <td>@{[input "sttGrowSocial"  ,'number','calcStt']}</td>
              </tr>
              <tr>
                <th>その他</th>
                <td>@{[input "sttOtherBody"  ,'number','calcStt']}</td>
                <td>@{[input "sttOtherSense"  ,'number','calcStt']}</td>
                <td>@{[input "sttOtherIntelligence"  ,'number','calcStt']}</td>
                <td>@{[input "sttOtherWill"  ,'number','calcStt']}</td>
                <td>@{[input "sttOtherCharm"  ,'number','calcStt']}</td>
                <td>@{[input "sttOtherSocial"  ,'number','calcStt']}</td>
              </tr>
              <tr>
                <th>合計</th>
                <td id="stt-total-Body"         >0</td>
                <td id="stt-total-Sense"        >0</td>
                <td id="stt-total-Intelligence" >0</td>
                <td id="stt-total-Will"         >0</td>
                <td id="stt-total-Charm"        >0</td>
                <td id="stt-total-Social"       >0</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="box-union" id="sub-status">
          <dl class="box" id="max-hp">
            <dt>FP</dt>
            <dd><span id="max-fp-value"></span>+@{[input "maxFpAdd",'number','calcMaxFp']}=<b id="max-fp-total"></b></dd>
          </dl>
          <dl class="box" id="initiative">
            <dt>行動値</dt>
            <dd><span id="initiative-value"></span>+@{[input "initiativeAdd",'number','calcInitiative']}=<b id="initiative-total"></b></dd>
          </dl>
          <dl class="box" id="stock">
            <dt>常備化ポイント</dt>
            <dd><span id="stock-value"></span>+@{[input "stockAdd",'number','calcStock']}=<b id="stock-total"></b></dd>
          </dl>
        </div>
      </div>

      <details class="box" id="status" $open{'skill'}>
        <summary>技能 [<span id="exp-skill">0</span>]</summary>
        <dl id="skill-table">
          <dt></dt>
          <dd>
            <dl id="skill-body-table">
              <dt class="left">当身</dt><dd><select name="skillAtemi">@{[option "skillAtemi",@skillLevel]}</select></dd>
              <dt class="left">威圧</dt><dd><select name="skillDominate">@{[option "skillDominate",@skillLevel]}</select></dd>
              <dt class="left">運動</dt><dd><select name="skillExercise">@{[option "skillExercise",@skillLevel]}</select></dd>
              <dt class="left">隠密</dt><dd><select name="skillHide">@{[option "skillHide",@skillLevel]}</select></dd>
              <dt class="left">解錠</dt><dd><select name="skillPicking">@{[option "skillPicking",@skillLevel]}</select></dd>
              <dt class="left">回避</dt><dd><select name="skillDodge">@{[option "skillDodge",@skillLevel]}</select></dd>
HTML
foreach my $num (1 .. $pc{'skillCompNum'}) {
print <<"HTML";
              <dt>@{[input "skillComp${num}Name",'','','list="list-comp"']}</dt><dd><select>@{[option "skillComp$num",@skillLevel]}</select></dd>
HTML
}
print <<"HTML";
            </dl>
          </dd>
          <dt></dt>
          <dd>
            <dl id="skill-body-table">
              <dt class="left">観察</dt><dd><select name="skillObserve">@{[option "skillObserve",@skillLevel]}</select></dd>
              <dt class="left">近接武器</dt><dd><select name="skillWeapon">@{[option "skillWeapon",@skillLevel]}</select></dd>
              <dt class="left">攻撃魔法</dt><dd><select name="skillMagic">@{[option "skillMagic",@skillLevel]}</select></dd>
              <dt class="left">交渉</dt><dd><select name="skillNegotiation">@{[option "skillNegotiation",@skillLevel]}</select></dd>
              <dt class="left">修理</dt><dd><select name="skillRepair">@{[option "skillRepair",@skillLevel]}</select></dd>
              <dt class="left">乗馬</dt><dd><select name="skillHorse">@{[option "skillHorse",@skillLevel]}</select></dd>
HTML
foreach my $num (1 .. $pc{'skillArtNum'}) {
print <<"HTML";
              <dt>@{[input "skillArt${num}Name",'','','list="list-art"']}</dt><dd><select>@{[option "skillArt$num",@skillLevel]}</select></dd>
HTML
}
print <<"HTML";
            </dl>
          </dd>
          <dt></dt>
          <dd>
            <dl id="skill-body-table">
              <dt class="left">探索</dt><dd><select name="skillSearch">@{[option "skillSearch",@skillLevel]}</select></dd>
              <dt class="left">調査</dt><dd><select name="skillInvestigate">@{[option "skillInvestigate",@skillLevel]}</select></dd>
              <dt class="left">追跡/逃走</dt><dd><select name="skillTrace">@{[option "skillTrace",@skillLevel]}</select></dd>
              <dt class="left">抵抗力</dt><dd><select name="skillRegist">@{[option "skillRegist",@skillLevel]}</select></dd>
              <dt class="left">飛び道具</dt><dd><select name="skillProjectile">@{[option "skillProjectile",@skillLevel]}</select></dd>
              <dt class="left">魔法機械操作</dt><dd><select name="skillMachine">@{[option "skillMachine",@skillLevel]}</select></dd>
HTML
foreach my $num (1 .. $pc{'skillKnowNum'}) {
print <<"HTML";
              <dt>@{[input "skillKnow${num}Name",'','','list="list-know"']}</dt><dd><select>@{[option "skillKnow$num",@skillLevel]}</select></dd>
HTML
}
print <<"HTML";
            </dl>
          </dd>
        </dl>
      </details>
      <details class="box" id="lifepath" $open{'lifepath'}>
        <summary>ライフパス</summary>
        <table class="edit-table line-tbody">
          <tbody>
          <tr>
            <th>前歴</th>
            <td>@{[input "lifepathPast"]}</td>
            <td colspan="2" class="left">@{[input "lifepathPastNote",'','','placeholder="備考"']}</td>
          </tr>
          </tbody>
          <tbody>
          <tr>
            <th>秘密</th>
            <td>@{[input "lifepathSecret"]}</td>
            <td colspan="2" class="left">@{[input "lifepathSecretNote",'','','placeholder="備考"']}</td>
          </tr>
          </tbody>
          <tbody>
          <tr>
            <th>破滅</th>
            <td>@{[input "lifepathRuin"]}</td>
            <td colspan="2" class="left">@{[input "lifepathRuinNote",'','','placeholder="備考"']}</td>
          </tr>
          </tbody>
        </table>
      </details>
      <details class="box" id="lois" $open{'flag'} style="position:relative">
        <summary>フラグ</summary>
        <table class="edit-table" id="lois-table">
          <thead>
            <tr>
              <th>関係</th>
              <th>名前</th>
              <th>説明</th>
              <th>状態</th>
            </tr>
          </thead>
          <tbody>
HTML
foreach my $num (1 .. 7) {
if(!$pc{"flag${num}State"}){ $pc{"flag${num}State"} = '未回収' }
print <<"HTML";
            <tr id="flag${num}">
              <td><span class="handle"></span>@{[input "flag${num}Relation"]}</td>
              <td>@{[input "flag${num}Name"]}</td>
              <td>@{[input "flag${num}Note"]}</td>
              <td onclick="changeFlagState(this.parentNode.id)"><span id="flag${num}-state" data-state="$pc{"flag${num}State"}"></span>@{[input "flag${num}State",'hidden']}</td>
            </tr>
HTML
}
print <<"HTML";
          </tbody>
        </table>
        <div class="right" style="position: absolute; top: 0; right: 0;">
          <a class="button small" onclick="resetLoisAll()">全フラグをリセット</a>
          <a class="button small" onclick="resetLoisAdd()">4番目以降をリセット</a>
        </div>
      </details>
      <details class="box" id="effect" $open{'effect'}>
        <summary>特技 [<span id="exp-effect">0</span>]</summary>
        @{[input 'talentNum','hidden']}
        <table class="edit-table line-tbody" id="effect-table">
          <thead>
            <tr><th></th><th>名称</th><th>効果</th></tr>
          </thead>
HTML
foreach my $num (1 .. $pc{'talentNum'}) {
print <<"HTML";
          <tbody id="talent${num}">
            <tr>
              <td class="handle"> </td>
              <td>@{[input "talent${num}Name",'','','placeholder="名称"']}</td>
              <td>@{[input "talent${num}Note"]}</td>
            </tr>
          </tbody>
HTML
}
print <<"HTML";
        </table>
        <div class="add-del-button"><a onclick="addTalent()">▼</a><a onclick="delTalent()">▲</a></div>
      </details>

      <details class="box" id="magic" $open{'magic'}>
        <summary>チートパワー [<span id="exp-magic">0</span>]</summary>
        @{[input 'cheatNum','hidden']}
        <table class="edit-table line-tbody" id="magic-table">
          <thead>
            <tr><th></th><th>名称</th><th>コスト</th><th>効果</th></tr>
          </thead>
HTML
foreach my $num (1 .. $pc{'cheatNum'}) {
print <<"HTML";
          <tbody id="cheat${num}">
            <tr>
              <td class="handle"> </td>
              <td>@{[input "cheat${num}Name"    ,'','','placeholder="名称"']}</td>
              <td>@{[input "cheat${num}Cost",'','','placeholder="コスト"']}</td>
              <td>@{[input "cheat${num}Note"    ,'','','placeholder="効果"']}</td>
            </tr>
          </tbody>
HTML
}
print <<"HTML";
        </table>
        <div class="add-del-button"><a onclick="addCheat()">▼</a><a onclick="delCheat()">▲</a></div>
      </details>

      <details class="box box-union" id="items" $open{'item'}>
      <summary>アイテム [<span id="exp-item">0</span>]</summary>
      <div class="box">
        @{[input 'weaponNum','hidden']}
        <table class="edit-table" id="weapon-table">
          <thead>
            <tr><th>武器</th><th>常備化</th><th>行動</th><th>種別</th><th>属性</th><th>攻撃力</th><th><span>対象</span></th><th>射程</th><th>解説</th></tr>
          </thead>
          <tbody>
HTML
foreach my $num (1 .. $pc{'weaponNum'}) {
print <<"HTML";
            <tr id="weapon${num}" class="weapon${num}">
              <td>@{[input "weapon${num}Name"]}<span class="handle"></span></td>
              <td>@{[input "weapon${num}Stock",'number','calcItem']}</td>
              <td>@{[input "weapon${num}Initiative", 'number']}</td>
              <td>@{[input "weapon${num}Type",'','','list="list-weapon-type"']}</td>
              <td>@{[input "weapon${num}Effect",'','','list="list-weapon-effect"']}</td>
              <td>@{[input "weapon${num}Atk"]}</td>
              <td>@{[input "weapon${num}Target",'','','list="list-weapon-target"']}</td>
              <td>@{[input "weapon${num}Range"]}</td>
              <td><textarea name="weapon${num}Note" rows="2">$pc{"weapon${num}Note"}</textarea></td>
            </tr>
HTML
}
print <<"HTML";
          </tbody>
        </table>
        <div class="add-del-button"><a onclick="addWeapon()">▼</a><a onclick="delWeapon()">▲</a></div>
      </div>
      <div class="box">
        @{[input 'armorNum','hidden']}
        <table class="edit-table" id="armor-table">
          <thead>
            <tr>
              <th>防具</th><th>常備化</th><th>行動</th>
              <th>切</th><th>貫</th><th>衝</th>
              <th>地</th><th>水</th><th>火</th><th>風</th><th>光</th><th>闇</th>
              <th>解説</th></tr>
          </thead>
          <tbody>
HTML
foreach my $num (1 .. $pc{'armorNum'}) {
print <<"HTML";
            <tr id="armor${num}">
              <td>@{[input "armor${num}Name"]}<span class="handle"></span></td>
              <td>@{[input "armor${num}Stock",'number','calcItem']}</td>
              <td>@{[input "armor${num}ArmorCut",'number']}</td>
              <td>@{[input "armor${num}ArmorPenetration",'number']}</td>
              <td>@{[input "armor${num}ArmorImpact",'number']}</td>
              <td>@{[input "armor${num}ArmorGround",'number']}</td>
              <td>@{[input "armor${num}ArmorWater",'number']}</td>
              <td>@{[input "armor${num}ArmorFire",'number']}</td>
              <td>@{[input "armor${num}ArmorWind",'number']}</td>
              <td>@{[input "armor${num}ArmorLight",'number']}</td>
              <td>@{[input "armor${num}ArmorDark",'number']}</td>
              <td>@{[input "armor${num}Initiative"]}</td>
              <td><textarea name="armor${num}Note" rows="2">$pc{"armor${num}Note"}</textarea></td>
            </tr>
HTML
}
print <<"HTML";
          </tbody>
        </table>
        <div class="add-del-button"><a onclick="addArmor()">▼</a><a onclick="delArmor()">▲</a></div>
      </div>
      <div class="box">
        @{[input 'itemNum','hidden']}
        <table class="edit-table" id="item-table">
          <thead>
            <tr><th>一般アイテム</th><th>常備化</th><th>種別</th><th>解説</th></tr>
          </thead>
          <tbody>
HTML
foreach my $num (1 .. $pc{'itemNum'}) {
print <<"HTML";
            <tr id="item${num}">
              <td>@{[input "item${num}Name"]}<span class="handle"></span></td>
              <td>@{[input "item${num}Stock",'number','calcItem']}</td>
              <td>@{[input "item${num}Type",'','','list="list-item-type"']}</td>
              <td><textarea name="item${num}Note" rows="2">$pc{"item${num}Note"}</textarea></td>
            </tr>
HTML
}
print <<"HTML";
          </tbody>
        </table>
        <div class="add-del-button"><a onclick="addItem()">▼</a><a onclick="delItem()">▲</a></div>
      </div>
      <div class="box">
        <table class="edit-table">
          <thead><tr><th></th><th>常備化</th><th></th></tr></thead>
          <tbody>
            <tr>
            <th>合計</th>
            <td><b id="item-total-stock">0</b>/<b id="item-max-stock">0</b></td>
            <td></td>
            </tr>
          </tbody>
        </table>
      </div>
      </details>
      
      
      <details class="box" id="free-note" @{[$pc{'freeNote'}?'open':'']}>
        <summary>容姿・経歴・その他メモ</summary>
        <textarea name="freeNote">$pc{'freeNote'}</textarea>
        <details class="annotate">
        <summary>テキスト装飾・整形ルール（クリックで展開）</summary>
        ※メモ欄以外でも有効です。<br>
        太字　：<code>''テキスト''</code>：<b>テキスト</b><br>
        斜体　：<code>'''テキスト'''</code>：<span class="oblique">テキスト</span><br>
        打消線：<code>%%テキスト%%</code>：<span class="strike">テキスト</span><br>
        下線　：<code>__テキスト__</code>：<span class="underline">テキスト</span><br>
        透明　：<code>{{テキスト}}</code>：<span style="color:transparent">テキスト</span><br>
        ルビ　：<code>|テキスト《てきすと》</code>：<ruby>テキスト<rt>てきすと</rt></ruby><br>
        傍点　：<code>《《テキスト》》</code>：<span class="text-em">テキスト</span><br>
        透明　：<code>{{テキスト}}</code>：<span style="color:transparent">テキスト</span>（ドラッグ反転で見える）<br>
        リンク：<code>[[テキスト>URL]]</code><br>
        別シートへのリンク：<code>[テキスト#シートのID]</code><br>
        <hr>
        ※以下は一部の複数行の欄でのみ有効です。<br>
        （有効な欄：「容姿・経歴・その他メモ」「履歴（自由記入）」）<br>
        大見出し：行頭に<code>*</code><br>
        中見出し：行頭に<code>**</code><br>
        少見出し：行頭に<code>***</code><br>
        左寄せ　：行頭に<code>LEFT:</code>：以降のテキストがすべて左寄せになります。<br>
        中央寄せ：行頭に<code>CENTER:</code>：以降のテキストがすべて中央寄せになります。<br>
        右寄せ　：行頭に<code>RIGHT:</code>：以降のテキストがすべて右寄せになります。<br>
        横罫線（直線）：<code>----</code>（4つ以上のハイフン）<br>
        横罫線（点線）：<code> * * * *</code>（4つ以上の「スペース＋アスタリスク」）<br>
        横罫線（破線）：<code> - - - -</code>（4つ以上の「スペース＋ハイフン」）<br>
        表組み　　：<code>|テキスト|テキスト|</code><br>
        定義リスト：<code>:項目名|説明文</code><br>
        　　　　　　<code>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|説明文2行目</code> 項目名を記入しないか、半角スペースで埋めると上と結合<br>
        折り畳み：行頭に<code>[>]項目名</code>：以降のテキストがすべて折り畳みになります。<br>
        　　　　　項目名を省略すると、自動的に「詳細」になります。<br>
        折り畳み終了：行頭に<code>[---]</code>：（ハイフンは3つ以上任意）<br>
        　　　　　　　省略すると、以後のテキストが全て折りたたまれます。<br>
        コメントアウト：行頭に<code>//</code>：記述した行を非表示にします。
        </details>
      </details>
      
      <details class="box" id="free-history" @{[$pc{'freeHistory'}?'open':'']}>
        <summary>履歴（自由記入）</summary>
        <textarea name="freeHistory">$pc{'freeHistory'}</textarea>
      </details>
      
      <div class="box" id="history">
        <h2>セッション履歴</h2>
        @{[input 'historyNum','hidden']}
        <table class="edit-table line-tbody" id="history-table">
          <colgroup><col><col><col><col><col><col><col></colgroup>
          <thead>
          <tr>
            <th></th>
            <th>日付</th>
            <th>タイトル</th>
            <th colspan="2">経験点</th>
            <th>GM</th>
            <th>参加者</th>
          </tr>
          <tr>
            <td>-</td>
            <td></td>
            <td>キャラクター作成</td>
            <td id="history0-exp">$pc{'history0Exp'}</td>
            <td><input type="checkbox" checked disabled>適用</td>
          </tr>
          </thead>
HTML
foreach my $num (1 .. $pc{'historyNum'}) {
print <<"HTML";
          <tbody id="history${num}">
          <tr>
            <td rowspan="2" class="handle"></td>
            <td rowspan="2">@{[input "history${num}Date" ]}</td>
            <td rowspan="2">@{[input "history${num}Title" ]}</td>
            <td>@{[ input "history${num}Exp",'text','calcExp' ]}</td>
            <td><label>@{[ input "history${num}ExpApply",'checkbox','calcExp' ]}<b>適用</b></label>
            <td>@{[ input "history${num}Gm" ]}</td>
            <td>@{[ input "history${num}Member" ]}</td>
          </tr>
          <tr><td colspan="4" class="left">@{[input("history${num}Note",'','','placeholder="備考"')]}</td></tr>
          </tbody>
HTML
}
print <<"HTML";
          <tfoot>
            <tr><th></th><th>日付</th><th>タイトル</th><th colspan="2">経験点</th><th>GM</th><th>参加者</th></tr>
          </tfoot>
        </table>
        <div class="add-del-button"><a onclick="addHistory()">▼</a><a onclick="delHistory()">▲</a></div>
        <h2>記入例</h2>
        <table class="example edit-table line-tbody">
          <colgroup><col><col><col><col><col><col><col></colgroup>
          <thead>
          <tr>
            <th></th>
            <th>日付</th>
            <th>タイトル</th>
            <th colspan="2">経験点</th>
            <th>GM</th>
            <th>参加者</th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <td>-</td>
            <td><input type="text" value="2020-03-18" disabled></td>
            <td><input type="text" value="第一話「記入例」" disabled></td>
            <td><input type="text" value="10+5+1" disabled></td>
            <td><label><input type="checkbox" checked disabled><b>適用</b></label></td>
            <td class="gm"><input type="text" value="サンプルGM" disabled></td>
            <td class="member"><input type="text" value="鳴瓢秋人　本堂町小春　百貴船太郎　富久田保津" disabled></td>
          </tr>
          </tbody>
        </table>
        <div class="annotate">
        ※経験点欄は<code>10+5+1</code>など四則演算が有効です（獲得条件の違う経験点などを分けて書けます）。<br>
        　経験点欄の右の適用チェックを入れると、その経験点が適用されます。
        </div>
      </div>
      <!--
      <div class="box" id="exp-footer">
        <p>
        経験点[<b id="exp-total"></b>] - 
        ( 能力値[<b id="exp-used-status"></b>]
        - 技能[<b id="exp-used-skill"></b>]
        - エフェクト[<b id="exp-used-effect"></b>]
        <span class="cc-only">- 術式[<b id="exp-used-magic"></b>]</span>
        - アイテム[<b id="exp-used-item"></b>]
        - メモリー[<b id="exp-used-memory"></b>]
        ) = 残り[<b id="exp-rest"></b>]点
        </p>
      </div>-->
      </section>
      
      <section id="section-palette" style="display:none;">
      <div class="box">
        <h2>チャットパレット</h2>
        <p>
          手動パレットの配置:<select name="paletteInsertType" style="width: auto;">
            <option value="exchange" @{[ $pc{'paletteInsertType'} eq 'exchange'?'selected':'' ]}>プリセットと入れ替える</option>
            <option value="begin"    @{[ $pc{'paletteInsertType'} eq 'begin'   ?'selected':'' ]}>プリセットの手前に挿入</option>
            <option value="end"      @{[ $pc{'paletteInsertType'} eq 'end'     ?'selected':'' ]}>プリセットの直後に挿入</option>
          </select>
        </p>
        <textarea name="chatPalette" style="height:20em" placeholder="例）&#13;&#10;2d6+{冒険者}+{器用}&#13;&#10;&#13;&#10;※入力がない場合、プリセットが自動的に反映されます。">$pc{'chatPalette'}</textarea>
        
        <div class="palette-column">
        <h2>デフォルト変数 （自動的に末尾に出力されます）</h2>
        <textarea id="paletteDefaultProperties" readonly style="height:20em">
HTML
  say $_ foreach(paletteProperties());
print <<"HTML";
</textarea>
        <p>
          <label>@{[ input 'chatPalettePropertiesAll', 'checkbox']} 全ての変数を出力する</label><br>
          （デフォルトだと、未使用の変数は出力されません）
        </p>
        </div>
        <div class="palette-column">
        <h2>プリセット （コピーペースト用）</h2>
        <textarea id="palettePreset" readonly style="height:20em"></textarea>
        <p>
          <label>@{[ input 'paletteUseVar', 'checkbox','palettePresetChange']}デフォルト変数を使う</label>
          ／
          <label>@{[ input 'paletteUseBuff', 'checkbox','palettePresetChange']}バフデバフ用変数を使う</label>
          <br>
          使用ダイスbot: <select name="paletteTool" onchange="palettePresetChange();" style="width:auto;">
          <option value="">ゆとチャadv.
          <option value="bcdice" @{[ $pc{'paletteTool'} eq 'bcdice' ? 'selected' : '']}>BCDice
          </select>
        </p>
        </div>
      </div>
      </section>
      <section id="section-color" style="display:none;">
      <h2>キャラクターシートのカラー設定</h2>
      <label class="box color-custom">
        <input type="checkbox" name="colorCustom" value="1" onchange="changeColor();" @{[ $pc{'colorCustom'} ? 'checked':'' ]}><i></i>キャラクターシートの色をカスタムする
      </label>
      <span class="box color-custom night-switch" onclick="nightModeChange()"><i></i>ナイトモード</span>
      <div class="box color-custom">
        <h2>見出し背景</h2>
        <table>
        <tr class="color-range-H"><th>色相</th><td><input type="range" name="colorHeadBgH" min="0" max="360" value="$pc{'colorHeadBgH'}" oninput="changeColor();"></td><td id="colorHeadBgHValue">$pc{'colorHeadBgH'}</td></tr>
        <tr class="color-range-S"><th>彩度</th><td><input type="range" name="colorHeadBgS" min="0" max="100" value="$pc{'colorHeadBgS'}" oninput="changeColor();"></td><td id="colorHeadBgSValue">$pc{'colorHeadBgS'}</td></tr>
        <tr class="color-range-L"><th>輝度</th><td><input type="range" name="colorHeadBgL" min="0" max="100" value="$pc{'colorHeadBgL'}" oninput="changeColor();"></td><td id="colorHeadBgLValue">$pc{'colorHeadBgL'}</td></tr>
        </table>
      </div>
      <div class="box color-custom">
        <h2>ベース背景</h2>
        <table>
        <tr class="color-range-H"><th>色相</th><td><input type="range" name="colorBaseBgH"  min="0" max="360" value="$pc{'colorBaseBgH'}" oninput="changeColor();"></td><td id="colorBaseBgHValue">$pc{'colorBaseBgH'}</td></tr>
        <tr class="color-range-S"><th>色の濃さ</th><td><input type="range" name="colorBaseBgS"  min="0" max="100" value="$pc{'colorBaseBgS'}" oninput="changeColor();"></td><td id="colorBaseBgSValue">$pc{'colorBaseBgS'}</td></tr>
        </table>
      </div>
      </section>
      
      
      @{[ input 'birthTime','hidden' ]}
      <input type="hidden" name="id" value="$::in{'id'}">
    </form>
HTML
if($mode eq 'edit'){
print <<"HTML";
    <form name="del" method="post" action="./" class="deleteform">
      <p style="font-size: 80%;">
      <input type="hidden" name="mode" value="delete">
      <input type="hidden" name="id" value="$::in{'id'}">
      <input type="hidden" name="pass" value="$::in{'pass'}">
      <input type="checkbox" name="check1" value="1" required>
      <input type="checkbox" name="check2" value="1" required>
      <input type="checkbox" name="check3" value="1" required>
      <input type="submit" value="シート削除"><br>
      ※チェックを全て入れてください
      </p>
    </form>
HTML
  # 怒りの画像削除フォーム
  if($LOGIN_ID eq $set::masterid){
    print <<"HTML";
    <form name="imgdel" method="post" action="./" class="deleteform">
      <p style="font-size: 80%;">
      <input type="hidden" name="mode" value="img-delete">
      <input type="hidden" name="id" value="$::in{'id'}">
      <input type="hidden" name="pass" value="$::in{'pass'}">
      <input type="checkbox" name="check1" value="1" required>
      <input type="checkbox" name="check2" value="1" required>
      <input type="checkbox" name="check3" value="1" required>
      <input type="submit" value="画像削除"><br>
      </p>
    </form>
    <p class="right">@{[ $::in{'backup'}?$::in{'backup'}:'最終' ]}更新時のIP:$pc{'IP'}</p>
HTML
  }
}
print <<"HTML";
    </article>
  </main>
  <footer>
    <p class="notes"><span>転生サバイバルRPG　ルーインブレイカーズは有限会社ファーイースト・アミューズメント・リサーチの著作物です</span></p>
    <!--<p class="copyright">ゆとシートⅡ for DX3rd ver.<TMPL_VAR ver> - <a href="https://yutorize.2-d.jp">ゆとらいず工房</a></p>-->
  </footer>
  <datalist id="list-gender">
    <option value="男">
    <option value="女">
    <option value="その他">
    <option value="なし">
    <option value="不明">
    <option value="不詳">
  </datalist>
  <datalist id="list-emotionP">
    <option value="傾倒">
    <option value="好奇心">
    <option value="憧憬">
    <option value="尊敬">
    <option value="連帯感">
    <option value="慈愛">
    <option value="感服">
    <option value="純愛">
    <option value="友情">
    <option value="慕情">
    <option value="同情">
    <option value="遺志">
    <option value="庇護">
    <option value="幸福感">
    <option value="信頼">
    <option value="執着">
    <option value="親近感">
    <option value="誠意">
    <option value="好意">
    <option value="有為">
    <option value="尽力">
    <option value="懐旧">
  </datalist>
  <datalist id="list-emotionN">
    <option value="侮蔑">
    <option value="食傷">
    <option value="脅威">
    <option value="嫉妬">
    <option value="悔悟">
    <option value="恐怖">
    <option value="不安">
    <option value="劣等感">
    <option value="疎外感">
    <option value="恥辱">
    <option value="憐憫">
    <option value="偏愛">
    <option value="憎悪">
    <option value="隔意">
    <option value="嫌悪">
    <option value="猜疑心">
    <option value="厭気">
    <option value="不信感">
    <option value="不快感">
    <option value="憤懣">
    <option value="敵愾心">
    <option value="無関心">
  </datalist>
  <datalist id="list-comp" >
    <option value="競技:">
    <option value="競技:陸上">
    <option value="競技:水泳">
    <option value="競技:球技">
    <option value="競技:持久">
    <option value="競技:政治">
    <option value="競技:商業">
    <option value="競技:盤上遊戯">
    <option value="競技:戦術">
    <option value="競技:戦略">
    <option value="競技:決闘">
  </datalist>
  <datalist id="list-art" >
    <option value="芸術:">
    <option value="芸術:音楽">
    <option value="芸術:演技">
    <option value="芸術:絵画">
    <option value="芸術:舞踊">
    <option value="芸術:文学">
    <option value="芸術:工芸">
    <option value="芸術:建築">
    <option value="芸術:裁縫">
    <option value="芸術:料理">
    <option value="芸術:サーヴィス">
  </datalist>
  <datalist id="list-know">
    <option value="知識:">
    <option value="知識:アカデミー">
    <option value="知識:フォーチュンアース">
    <option value="知識:魔法">
    <option value="知識:政治">
    <option value="知識:医学">
    <option value="知識:経済">
    <option value="知識:宗教">
    <option value="知識:歴史">
    <option value="知識:噂話">
    <option value="知識:マナー">
  </datalist>
  <datalist id="list-combo-skill">
    <option value="―">
    <option value="〈白兵〉">
    <option value="〈射撃〉">
    <option value="〈RC〉">
    <option value="〈交渉〉">
    <option value="〈白兵〉〈射撃〉">
    <option value="〈白兵〉〈RC〉">
    <option value="〈回避〉">
    <option value="〈知覚〉">
    <option value="〈意志〉">
    <option value="〈調達〉">
    <option value="【肉体】">
    <option value="【感覚】">
    <option value="【精神】">
    <option value="【社会】">
    <option value="効果参照">
  </datalist>
  <datalist id="list-weapon-effect">
    <option value="〈切断〉">
    <option value="〈貫通〉">
    <option value="〈衝撃〉">
    <option value="〈地〉">
    <option value="〈水〉">
    <option value="〈火〉">
    <option value="〈風〉">
    <option value="〈光〉">
    <option value="〈闇〉">
  </datalist>
  <datalist id="list-weapon-type">
    <option value="近接">
    <option value="飛">
    <option value="魔">
  </datalist>
  <datalist id="list-weapon-target">
    <option value="単">
    <option value="S">
  </datalist>
  <datalist id="list-armor-type">
    <option value="防具">
    <option value="防具※">
  </datalist>
  <datalist id="list-item-type">
    <option value="携帯品">
    <option value="所持品">
    <option value="ライフスタイル">
    <option value="サーヴィス">
  </datalist>
  <datalist id="list-range">
    <option value="―">
    <option value="至近">
    <option value="武器">
    <option value="視界">
    <option value="効果参照">
  </datalist>
  <script>
HTML
print 'const baseStatus = {';
foreach (keys %data::igrs_status) {
  next if !$_;
  my @ar = @{$data::igrs_status{$_}};
  print '"'.$_.'":{"Body":'.$ar[0].',"Sense":'.$ar[1].',"Intelligence":'.$ar[2].',"Will":'.$ar[3].',"Charm":'.$ar[4].',"Social":'.$ar[5].'},'
}
foreach (keys %data::elements_status) {
  next if !$_;
  my @ar = @{$data::elements_status{$_}};
  print '"'.$_.'":{"Body":'.$ar[0].',"Sense":'.$ar[1].',"Intelligence":'.$ar[2].',"Will":'.$ar[3].',"Charm":'.$ar[4].',"Social":'.$ar[5].'},'
}
print "};\n";
print 'const awakens = {';
foreach (@data::awakens) {
  next if (@$_[0] =~ /^label=/);
  print '"'.@$_[0].'":'.@$_[1].','
}
print "};\n";
print 'const impulses = {';
foreach (@data::impulses) {
  print '"'.@$_[0].'":'.@$_[1].','
}
print "};\n";
## チャットパレット
print <<"HTML";
  let palettePresetText = {
    'ytc'    : { 'full': `@{[ palettePreset()         ]}`, 'simple': `@{[ palettePresetSimple()         ]}` } ,
    'bcdice' : { 'full': `@{[ palettePreset('bcdice') ]}`, 'simple': `@{[ palettePresetSimple('bcdice') ]}` } ,
  };
  </script>
</body>

</html>
HTML

1;