################## チャットパレット用サブルーチン ##################
use strict;
#use warnings;
use utf8;

require $set::data_items;

### 魔法威力 #########################################################################################
sub magicPows {
  my %pows = (
    'Sor' => [10,20],
    'Con' => [ 0],
    'Pri' => [10],
    'Mag' => [],
    'Fai' => [10],
    'Dru' => [],
    'Dem' => [10,20],
    'Gri' => [10,20],
    'Bar' => [10],
  );
  my %heals = (
    'Con' => [ 0],
    'Pri' => [10],
    'Gri' => [20],
    'Bar' => [ 0,10,20],
  );
  if($::pc{'lvSor'} >=  5){ push(@{$pows{'Sor'}}, 30) }
  if($::pc{'lvSor'} >=  8){ push(@{$pows{'Sor'}}, 40) }
  if($::pc{'lvSor'} >= 11){ push(@{$pows{'Sor'}}, 50) }
  if($::pc{'lvSor'} >= 14){ push(@{$pows{'Sor'}}, 60) }
  if($::pc{'lvSor'} >= 15){ push(@{$pows{'Sor'}},100) }
  if($::pc{'lvCon'} >=  8){ push(@{$pows{'Con'}}, 20) }
  if($::pc{'lvCon'} >=  9){ push(@{$pows{'Con'}}, 30) }
  if($::pc{'lvCon'} >= 15){ push(@{$pows{'Con'}}, 60) }
  if($::pc{'lvPri'} >=  5){ push(@{$pows{'Pri'}}, 20) }
  if($::pc{'lvPri'} >=  9){ push(@{$pows{'Pri'}}, 30) }
  if($::pc{'lvFai'} >=  5){ push(@{$pows{'Fai'}}, 20) }
  if($::pc{'lvFai'} >= 10){ push(@{$pows{'Fai'}}, 40) }
  if($::pc{'lvFai'} >= 11){ push(@{$pows{'Fai'}}, 50) }
  if($::pc{'lvFai'} >= 14){ push(@{$pows{'Fai'}}, 60) }
  if($::pc{'lvMag'} >=  5){ push(@{$pows{'Mag'}}, 30) }
  if($::pc{'lvMag'} >= 15){ push(@{$pows{'Mag'}}, 90) }
  if($::pc{'lvDem'} >=  5){ push(@{$pows{'Dem'}}, 30); push(@{$pows{'Dem'}}, 40); push(@{$pows{'Dem'}}, 50) }
  if($::pc{'lvGri'} >=  4){ push(@{$pows{'Gri'}}, 30) }
  if($::pc{'lvGri'} >=  7){ push(@{$pows{'Gri'}}, 40); push(@{$pows{'Gri'}}, 50) }
  if($::pc{'lvGri'} >= 10){ push(@{$pows{'Gri'}}, 60) }
  if($::pc{'lvGri'} >= 13){ push(@{$pows{'Gri'}}, 80); push(@{$pows{'Gri'}},100) }
  if($::pc{'lvBar'} >=  5){ push(@{$pows{'Bar'}}, 20) }
  if($::pc{'lvBar'} >= 10){ push(@{$pows{'Bar'}}, 30) }
  
  if($::pc{'lvCon'} >= 11){ push(@{$heals{'Con'}}, 30) }
  if($::pc{'lvPri'} >=  5){ push(@{$heals{'Pri'}}, 30) }
  if($::pc{'lvPri'} >= 10){ push(@{$heals{'Pri'}}, 50) }
  if($::pc{'lvPri'} >= 13){ push(@{$heals{'Pri'}}, 70) }
  if($::pc{'lvGri'} >=  7){ push(@{$heals{'Gri'}}, 40) }
  if($::pc{'lvGri'} >= 13){ push(@{$heals{'Gri'}},100) }
  if($::pc{'lvBar'} >=  5){ push(@{$heals{'Bar'}}, 30) }
  if($::pc{'lvBar'} >= 10){ push(@{$heals{'Bar'}}, 40) }
  
  return (\%pows, \%heals);
}

### プリセット #######################################################################################
sub palettePreset {
  my $tool = shift;
  my $type = shift;
  my $text;
  my %bot;
  if   (!$tool)           { $bot{'YTC'} = 1; }
  elsif($tool eq 'bcdice'){ $bot{'BCD'} = 1; }
  ## ＰＣ
  if(!$type){
    # 基本判定
    $text .= "### ■非戦闘系\n";
    $text .= "2d6+{冒険者}+{器用B} 冒険者＋器用\n";
    $text .= "2d6+{冒険者}+{敏捷B} 冒険者＋敏捷\n";
    $text .= "2d6+{冒険者}+{筋力B} 冒険者＋筋力\n";
    $text .= "2d6+{冒険者}+{知力B} 冒険者＋知力\n";
    $text .= "2d6+{スカウト技巧} スカウト技巧\n" if $::pc{'packScoTec'};
    $text .= "2d6+{スカウト運動} スカウト運動\n" if $::pc{'packScoAgi'};
    $text .= "2d6+{スカウト観察} スカウト観察\n" if $::pc{'packScoObs'};
    $text .= "2d6+{レンジャー技巧} レンジャー技巧\n" if $::pc{'packRanTec'};
    $text .= "2d6+{レンジャー運動} レンジャー運動\n" if $::pc{'packRanAgi'};
    $text .= "2d6+{レンジャー観察} レンジャー観察\n" if $::pc{'packRanObs'};
    $text .= "2d6+{セージ知識} セージ知識\n" if $::pc{'packSagKno'};
    $text .= "2d6+{バード知識} バード知識\n" if $::pc{'packBarKno'};
    $text .= "2d6+{ライダー運動} ライダー運動\n" if $::pc{'packRidAgi'};
    $text .= "2d6+{ライダー知識} ライダー知識\n" if $::pc{'packRidKno'};
    $text .= "2d6+{ライダー観察} ライダー観察\n" if $::pc{'packRidObs'};
    $text .= "2d6+{アルケミスト知識} アルケミスト知識\n" if $::pc{'packAlcKno'};
    $text .= "\n";
    
    $text .= "### ■魔法系\n";
    # 魔法
    my ($pows, $heals) = magicPows();
    my %pows  = %{$pows};
    my %heals = %{$heals};
    
    $text .= "//魔力修正=".($::pc{'magicPowerAdd'}||0)."\n";
    $text .= "//行使修正=".($::pc{'magicCastAdd'}||0)."\n";
    $text .= "//魔法C=10\n";
    $text .= "//魔法D修正=".($::pc{'magicDamageAdd'}||0)."\n";
    foreach (
      ['Sor', '真語魔法'],
      ['Con', '操霊魔法'],
      ['Pri', '神聖魔法'],
      ['Mag', '魔動機術'],
      ['Fai', '妖精魔法'],
      ['Dru', '森羅魔法'],
      ['Dem', '召異魔法'],
      ['Gri', '秘奥魔法'],
      ['Bar', '呪歌'],
      ['Alc', '賦術'],
      ['Mys', '占瞳'],
    ){
      my ($id, $name) = @$_;
      next if !$::pc{'lv'.$id};
      
      $text .= "2d6+{@$_[1]}";
      if   ($name =~ /魔/){ $text .= "+{魔力修正}+{行使修正} ${name}行使\n"; }
      elsif($name =~ /歌/){ $text .= " 呪歌演奏\n"; }
      else                { $text .= " ${name}\n"; }
      
      foreach my $pow (@{$pows{$id}}) {
        $text .= "k${pow}[{魔法C}]+{$name}+{魔力修正}".($::pc{'magicDamageAdd'.$id}?"+$::pc{'magicDamageAdd'.$id}":'')."+{魔法D修正} ダメージ\n";
        $text .= "k${pow}+{$name}+{魔力修正}//"  .($::pc{'magicDamageAdd'.$id}?"+$::pc{'magicDamageAdd'.$id}":'')."+{魔法D修正} 半減\n" if ($bot{'YTC'});
        $text .= "hk${pow}+{$name}+{魔力修正} 半減\n" if ($bot{'BCD'});
      }
      foreach my $pow (@{$heals{$id}}) {
        $text .= "k${pow}+{$name}+{魔力修正} 回復量\n"
      }
      $text .= "\n";
    }
    
    # 攻撃
    $text .= "### ■武器攻撃系\n";
    $text .= "//命中修正=0\n";
    $text .= "//C修正=0\n";
    $text .= "//追加D修正=0\n";
    $text .= "//必殺効果=0\n";
    $text .= "//クリレイ=0\n";
    
    foreach (1 .. $::pc{'weaponNum'}){
      next if $::pc{'weapon'.$_.'Acc'}.$::pc{'weapon'.$_.'Rate'}.
              $::pc{'weapon'.$_.'Crit'}.$::pc{'weapon'.$_.'Dmg'} eq '';
      
      $::pc{'weapon'.$_.'Name'} = $::pc{'weapon'.$_.'Name'} || $::pc{'weapon'.($_-1).'Name'};
      $text .= "2d6+{命中$_}+{命中修正}";
      $text .= " 命中力／$::pc{'weapon'.$_.'Name'}\n";
      
      if   ($bot{'YTC'} ){ $text .= "k$::pc{'weapon'.$_.'Rate'}\[$::pc{'weapon'.$_.'Crit'}+{C修正}\]+{追加D$_}+{武器修正}"; }
      elsif($bot{'BCD'} ){ $text .= "k$::pc{'weapon'.$_.'Rate'}+{追加D$_}+{武器修正}\@($::pc{'weapon'.$_.'Crit'}+{C修正})"; }
      
      if($::pc{'weapon'.$_.'Name'} =~ /首切/ || $::pc{'weapon'.$_.'Note'} =~ /首切/){
        $text .= $bot{'YTC'} ? '首切' : $bot{'BCD'} ? 'r5' : '';
      }
      $text .= " ダメージ\n";
      $text .= "\n";
    }
    $text .= "//武器修正={追加D修正}\#{必殺効果}\$+{クリレイ}\n";
    # 抵抗回避
    $text .= "### ■抵抗回避\n";
    $text .= "//生命抵抗修正=0\n";
    $text .= "//精神抵抗修正=0\n";
    $text .= "//回避修正=0\n";
    $text .= "2d6+{生命抵抗}+{生命抵抗修正} 生命抵抗力\n";
    $text .= "2d6+{精神抵抗}+{精神抵抗修正} 精神抵抗力\n";
    $text .= "2d6+{回避}+{回避修正} 回避力\n";
    $text .= "\n";
    
    #
    $text .= "###\n";
  }
  ## 魔物
  elsif($type eq 'm') {
    $text .= "2d6+{生命抵抗} 生命抵抗力\n";
    $text .= "2d6+{精神抵抗} 精神抵抗力\n";
    $text .= "\n";

    foreach (1 .. $::pc{'statusNum'}){
      $text .= "2d6+{命中$_} 命中力／$::pc{'status'.$_.'Style'}\n" if $::pc{'status'.$_.'Accuracy'} ne '';
      $text .= "{ダメージ$_} ダメージ\n" if $::pc{'status'.$_.'Damage'} ne '';
      $text .= "2d6+{回避$_} 回避\n" if $::pc{'status'.$_.'Evasion'} ne '';
      $text .= "\n";
    }
    my $skills = $::pc{'skills'};
    $skills =~ tr/０-９（）/0-9\(\)/;
    $skills =~ s/<br>/\n/gi;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+?)(?:[0-9]+(?:レベル|LV)|\(.+\))*[\/／](?:魔力)([0-9]+)[(（][0-9]+[）)]/$text .= "2d6+{$1} $1\n";/megi;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+)[\/／]([0-9]+)[(（][0-9]+[）)]/$text .= "2d6+{$1} $1\n";/megi;
  }
  
  return $text;
}

### プリセット（シンプル） ###########################################################################
sub palettePresetSimple {
  my $tool = shift;
  my $type = shift;
  my $text;
  my %bot;
  if   (!$tool)           { $bot{'YTC'} = 1; }
  elsif($tool eq 'bcdice'){ $bot{'BCD'} = 1; }
  ## ＰＣ
  if(!$type){
    # 基本判定
    $text .= "### ■非戦闘系\n";
    $text .= "2d6+$::pc{'level'}+$::pc{'bonusDex'} 冒険者＋器用\n";
    $text .= "2d6+$::pc{'level'}+$::pc{'bonusAgi'} 冒険者＋敏捷\n";
    $text .= "2d6+$::pc{'level'}+$::pc{'bonusStr'} 冒険者＋筋力\n";
    $text .= "2d6+$::pc{'level'}+$::pc{'bonusInt'} 冒険者＋知力\n";
    $text .= "2d6+$::pc{'monsterLore'} 魔物知識\n" if $::pc{'monsterLore'};
    $text .= "2d6+$::pc{'initiative'} 先制力\n" if $::pc{'initiative'};
    $text .= "2d6+$::pc{'packScoTec'} スカウト技巧\n" if $::pc{'packScoTec'};
    $text .= "2d6+$::pc{'packScoAgi'} スカウト運動\n" if $::pc{'packScoAgi'};
    $text .= "2d6+$::pc{'packScoObs'} スカウト観察\n" if $::pc{'packScoObs'};
    $text .= "2d6+$::pc{'packRanTec'} レンジャー技巧\n" if $::pc{'packRanTec'};
    $text .= "2d6+$::pc{'packRanAgi'} レンジャー運動\n" if $::pc{'packRanAgi'};
    $text .= "2d6+$::pc{'packRanObs'} レンジャー観察\n" if $::pc{'packRanObs'};
    $text .= "2d6+$::pc{'packSagKno'} セージ知識\n" if $::pc{'packSagKno'};
    $text .= "2d6+$::pc{'packBarKno'} バード知識\n" if $::pc{'packBarKno'};
    $text .= "2d6+$::pc{'packRidAgi'} ライダー運動\n" if $::pc{'packRidAgi'};
    $text .= "2d6+$::pc{'packRidKno'} ライダー知識\n" if $::pc{'packRidKno'};
    $text .= "2d6+$::pc{'packRidObs'} ライダー観察\n" if $::pc{'packRidObs'};
    $text .= "2d6+$::pc{'packAlcKno'} アルケミスト知識\n" if $::pc{'packAlcKno'};
    $text .= "\n";
    
    $text .= "### ■魔法系\n";
    # 魔法
    my ($pows, $heals) = magicPows();
    my %pows  = %{$pows};
    my %heals = %{$heals};
    
    $text .= "//魔力修正=".($::pc{'magicPowerAdd'}||0)."\n";
    $text .= "//行使修正=".($::pc{'magicCastAdd'}||0)."\n";
    $text .= "//魔法C=10\n";
    $text .= "//魔法D修正=".($::pc{'magicDamageAdd'}||0)."\n";
    foreach (
      ['Sor', '真語魔法'],
      ['Con', '操霊魔法'],
      ['Pri', '神聖魔法'],
      ['Mag', '魔動機術'],
      ['Fai', '妖精魔法'],
      ['Dru', '森羅魔法'],
      ['Dem', '召異魔法'],
      ['Gri', '秘奥魔法'],
      ['Bar', '呪歌'],
      ['Alc', '賦術'],
      ['Mys', '占瞳'],
    ){
      my ($id, $name) = @$_;
      next if !$::pc{'lv'.$id};
      my $base = $::pc{'magicPower'.$id} - $::pc{'magicPowerAdd'} - $::pc{'magicPowerAdd'.$id};
         $base .= $::pc{'magicPowerAdd'.$id} ? "+$::pc{'magicPowerAdd'.$id}" : '';
      
      $text .= "2d6+".$base. ($::pc{'magicCastAdd'.$id} ? "+$::pc{'magicCastAdd'.$id}" : '');
      if   ($name =~ /魔/){ $text .= "+{魔力修正}+{行使修正} ${name}行使\n"; }
      elsif($name =~ /歌/){ $text .= " 呪歌演奏\n"; }
      else                { $text .= " ${name}\n"; }
      
      foreach my $pow (@{$pows{$id}}) {
        my $add  = $::pc{'magicDamageAdd'.$id} ? "+$::pc{'magicDamageAdd'.$id}" : '';
        $text .= "k${pow}[{魔法C}]+$base+{魔力修正}".$add."+{魔法D修正} ダメージ\n";
        $text .= "k${pow}+$base+{魔力修正}//".$add."+{魔法D修正} 半減\n" if ($bot{'YTC'});
        $text .= "hk${pow}+$base+{魔力修正} 半減\n" if ($bot{'BCD'});
      }
      foreach my $pow (@{$heals{$id}}) {
        $text .= "k${pow}+$base+{魔力修正} 回復量\n"
      }
      $text .= "\n";
    }
    
    # 攻撃
    $text .= "### ■武器攻撃系\n";
    $text .= "//命中修正=0\n";
    $text .= "//C修正=0\n";
    $text .= "//追加D修正=0\n";
    $text .= "//必殺効果=0\n";
    $text .= "//クリレイ=0\n";
    
    foreach (1 .. $::pc{'weaponNum'}){
      next if $::pc{'weapon'.$_.'Acc'}.$::pc{'weapon'.$_.'Rate'}.
              $::pc{'weapon'.$_.'Crit'}.$::pc{'weapon'.$_.'Dmg'} eq '';
      
      $::pc{'weapon'.$_.'Name'} = $::pc{'weapon'.$_.'Name'} || $::pc{'weapon'.($_-1).'Name'};
      $text .= "2d6+{命中$_}+{命中修正}";
      $text .= " 命中力／$::pc{'weapon'.$_.'Name'}\n";
      
      $::pc{'weapon'.$_.'Crit'} =~ s/⑦|➆/7/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑧|➇/8/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑨|➈/9/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑩|➉/10/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑪/11/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑫/12/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑬/13/;
      if   ($bot{'YTC'} ){ $text .= "k$::pc{'weapon'.$_.'Rate'}\[$::pc{'weapon'.$_.'Crit'}+{C修正}\]+$::pc{'weapon'.$_.'DmgTotal'}+{武器修正}"; }
      elsif($bot{'BCD'} ){ $text .= "k$::pc{'weapon'.$_.'Rate'}+$::pc{'weapon'.$_.'DmgTotal'}+{武器修正}\@($::pc{'weapon'.$_.'Crit'}+{C修正})"; }
      
      if($::pc{'weapon'.$_.'Name'} =~ /首切/ || $::pc{'weapon'.$_.'Note'} =~ /首切/){
        $text .= $bot{'YTC'} ? '首切' : $bot{'BCD'} ? 'r5' : '';
      }
      $text .= " ダメージ\n";
      $text .= "\n";
    }
    $text .= "//武器修正={追加D修正}\#{必殺効果}\$+{クリレイ}\n";
    # 抵抗回避
    $text .= "### ■抵抗回避\n";
    $text .= "//生命抵抗修正=0\n";
    $text .= "//精神抵抗修正=0\n";
    $text .= "//回避修正=0\n";
    $text .= "2d6+$::pc{'vitResistTotal'}+{生命抵抗修正} 生命抵抗力\n";
    $text .= "2d6+$::pc{'mndResistTotal'}+{精神抵抗修正} 精神抵抗力\n";
    $text .= "2d6+$::pc{'defenseTotalAllEva'}+{回避修正} 回避力\n";
    $text .= "\n";
    
    #
    $text .= "###\n";
  }
  ## 魔物
  elsif($type eq 'm') {
    $text .= "2d6+$::pc{'vitResist'} 生命抵抗力\n";
    $text .= "2d6+$::pc{'mndResist'} 精神抵抗力\n";
    $text .= "\n";

    foreach (1 .. $::pc{'statusNum'}){
      $text .= "2d6+$::pc{'status'.$_.'Accuracy'} 命中力／$::pc{'status'.$_.'Style'}\n" if $::pc{'status'.$_.'Accuracy'} ne '';
      $text .= "{ダメージ$_} ダメージ\n" if $::pc{'status'.$_.'Damage'} ne '';
      $text .= "2d6+$::pc{'status'.$_.'Evasion'} 回避\n" if $::pc{'status'.$_.'Evasion'} ne '';
      $text .= "\n";
    }
    my $skills = $::pc{'skills'};
    $skills =~ tr/０-９（）/0-9\(\)/;
    $skills =~ s/<br>/\n/gi;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+?)(?:[0-9]+(?:レベル|LV)|\(.+\))*[\/／](?:魔力)([0-9]+)[(（][0-9]+[）)]/$text .= "2d6+{$1} $1\n";/megi;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+)[\/／]([0-9]+)[(（][0-9]+[）)]/$text .= "2d6+{$1} $1\n";/megi;
  }
  
  return $text;
}

### デフォルト変数 ###################################################################################
sub paletteProperties {
  my $type = shift;
  my @propaties;
  ## PC
  if  (!$type){
    push @propaties, "//器用度=$::pc{'sttDex'}".($::pc{'sttAddA'}?"+$::pc{'sttAddA'}":"");
    push @propaties, "//敏捷度=$::pc{'sttAgi'}".($::pc{'sttAddB'}?"+$::pc{'sttAddB'}":"");
    push @propaties, "//筋力=$::pc{'sttStr'}".($::pc{'sttAddC'}?"+$::pc{'sttAddC'}":"");
    push @propaties, "//生命力=$::pc{'sttVit'}".($::pc{'sttAddD'}?"+$::pc{'sttAddD'}":"");
    push @propaties, "//知力=$::pc{'sttInt'}".($::pc{'sttAddE'}?"+$::pc{'sttAddE'}":"");
    push @propaties, "//精神力=$::pc{'sttMnd'}".($::pc{'sttAddF'}?"+$::pc{'sttAddF'}":"");
    push @propaties, "//器用={器用度}";
    push @propaties, "//敏捷={敏捷度}";
    push @propaties, "//生命={生命力}";
    push @propaties, "//精神={精神力}";
    push @propaties, "//器用B=(({器用})/6)";
    push @propaties, "//敏捷B=(({敏捷})/6)";
    push @propaties, "//筋力B=(({筋力})/6)";
    push @propaties, "//生命B=(({生命})/6)";
    push @propaties, "//知力B=(({知力})/6)";
    push @propaties, "//精神B=(({精神})/6)";
    push @propaties, "//DEX={器用}";
    push @propaties, "//AGI={敏捷}";
    push @propaties, "//STR={筋力}";
    push @propaties, "//VIT={生命}";
    push @propaties, "//INT={知力}";
    push @propaties, "//MND={精神}";
    push @propaties, "//dexB={器用B}";
    push @propaties, "//agiB={敏捷B}";
    push @propaties, "//strB={筋力B}";
    push @propaties, "//vitB={生命B}";
    push @propaties, "//intB={知力B}";
    push @propaties, "//mndB={精神B}";
    push @propaties, '';
    push @propaties, "//生命抵抗={生命B}".($::pc{'vitResistAddTotal'}?"+$::pc{'vitResistAddTotal'}":"");
    push @propaties, "//精神抵抗={精神B}".($::pc{'mndResistAddTotal'}?"+$::pc{'mndResistAddTotal'}":"");
    push @propaties, "//最大HP=$::pc{'hpTotal'}";
    push @propaties, "//最大MP=$::pc{'mpTotal'}";
    push @propaties, '';
    push @propaties, "//冒険者レベル=$::pc{'level'}";
    push @propaties, "//冒険者={冒険者レベル}";
    push @propaties, "//LV={冒険者}";
    foreach (
      ['Fig','ファイター'],
      ['Gra','グラップラー'],
      ['Fen','フェンサー'],
      ['Sho','シューター'],
      ['Sor','ソーサラー'],
      ['Con','コンジャラー'],
      ['Pri','プリースト'],
      ['Fai','フェアリーテイマー'],
      ['Mag','マギテック'],
      ['Sco','スカウト'],
      ['Ran','レンジャー'],
      ['Sag','セージ'],
      ['Enh','エンハンサー'],
      ['Bar','バード'],
      ['Rid','ライダー'],
      ['Alc','アルケミスト'],
      ['Dru','ドルイド'],
      ['Dem','デーモンルーラー'],
      ['War','ウォーリーダー'],
      ['Mys','ミスティック'],
      ['Phy','フィジカルマスター'],
      ['Gri','グリモワール'],
      ['Ari','アリストクラシー'],
      ['Art','アーティザン'],
    ){
      next if !$::pc{'lv'.@$_[0]};
      push @propaties, "//@$_[1]=$::pc{'lv'.@$_[0]}";
      push @propaties, "//".uc(@$_[0])."={@$_[1]}";
    }
    push @propaties, '';
    #push @propaties, "//魔物知識=$::pc{'monsterLore'}" if $::pc{'monsterLore'};
    #push @propaties, "//先制力=$::pc{'initiative'}" if $::pc{'initiative'};
    push @propaties, "//スカウト技巧={スカウト}+{器用B}"        .($::pc{'packScoTecAdd'}?"+$::pc{'packScoTecAdd'}":"") if $::pc{'packScoTec'};
    push @propaties, "//スカウト運動={スカウト}+{敏捷B}"        .($::pc{'packScoAgiAdd'}?"+$::pc{'packScoAgiAdd'}":"") if $::pc{'packScoAgi'};
    push @propaties, "//スカウト観察={スカウト}+{知力B}"        .($::pc{'packScoObsAdd'}?"+$::pc{'packScoObsAdd'}":"") if $::pc{'packScoObs'};
    push @propaties, "//レンジャー技巧={レンジャー}+{器用B}"    .($::pc{'packRanTecAdd'}?"+$::pc{'packRanTecAdd'}":"") if $::pc{'packRanTec'};
    push @propaties, "//レンジャー運動={レンジャー}+{敏捷B}"    .($::pc{'packRanAgiAdd'}?"+$::pc{'packRanAgiAdd'}":"") if $::pc{'packRanAgi'};
    push @propaties, "//レンジャー観察={レンジャー}+{知力B}"    .($::pc{'packRanObsAdd'}?"+$::pc{'packRanObsAdd'}":"") if $::pc{'packRanObs'};
    push @propaties, "//セージ知識={セージ}+{知力B}"            .($::pc{'packSagKnoAdd'}?"+$::pc{'packSagKnoAdd'}":"") if $::pc{'packSagKno'};
    push @propaties, "//バード知識={バード}+{知力B}"            .($::pc{'packBarKnoAdd'}?"+$::pc{'packBarKnoAdd'}":"") if $::pc{'packBarKno'};
    push @propaties, "//ライダー運動={ライダー}+{敏捷B}"        .($::pc{'packRidAgiAdd'}?"+$::pc{'packRidAgiAdd'}":"") if $::pc{'packRidAgi'};
    push @propaties, "//ライダー知識={ライダー}+{知力B}"        .($::pc{'packRidKnoAdd'}?"+$::pc{'packRidKnoAdd'}":"") if $::pc{'packRidKno'};
    push @propaties, "//ライダー観察={ライダー}+{知力B}"        .($::pc{'packRidObsAdd'}?"+$::pc{'packRidObsAdd'}":"") if $::pc{'packRidObs'};
    push @propaties, "//アルケミスト知識={アルケミスト}+{知力B}".($::pc{'packAlcKnoAdd'}?"+$::pc{'packAlcKnoAdd'}":"") if $::pc{'packAlcKno'};
    push @propaties, '';
    
    foreach (
      ['Sor', '真語魔法', '知力', 'ソーサラー'],
      ['Con', '操霊魔法', '知力', 'コンジャラー'],
      ['Pri', '神聖魔法', '知力', 'プリースト'],
      ['Mag', '魔動機術', '知力', 'マギテック'],
      ['Fai', '妖精魔法', '知力', 'フェアリーテイマー'],
      ['Dru', '森羅魔法', '知力', 'ドルイド'],
      ['Dem', '召異魔法', '知力', 'デーモンルーラー'],
      ['Gri', '秘奥魔法', '知力', 'グリモワール'],
      ['Bar', '呪歌',     '精神', 'バード'],
      ['Alc', '賦術',     '知力', 'アルケミスト'],
      ['Mys', '占瞳',     '知力', 'ミスティック'],
    ){
      next if !$::pc{'lv'.@$_[0]};
      my $own = $::pc{'magicPowerOwn'.@$_[0]} ? "+2" : "";
      my $add = $::pc{'magicPowerAdd'.@$_[0]} ? "+$::pc{'magicPowerAdd'.@$_[0]}" : '';
      my $enh = $::pc{'magicPowerEnhance'} ? "+$::pc{'magicPowerEnhance'}" : '';
      push @propaties, "//".@$_[1]."=({".@$_[3]."}+({".@$_[2]."}".$own.")/6)".$enh.$add;
    }
    push @propaties, '';
    
    foreach (1 .. $::pc{'weaponNum'}){
      next if $::pc{'weapon'.$_.'Name'}.$::pc{'weapon'.$_.'Usage'}.$::pc{'weapon'.$_.'Reqd'}.
              $::pc{'weapon'.$_.'Acc'}.$::pc{'weapon'.$_.'Rate'}.$::pc{'weapon'.$_.'Crit'}.
              $::pc{'weapon'.$_.'Dmg'}.$::pc{'weapon'.$_.'Own'}.$::pc{'weapon'.$_.'Note'}
              eq '';
      $::pc{'weapon'.$_.'Name'} = $::pc{'weapon'.$_.'Name'} || $::pc{'weapon'.($_-1).'Name'};
      $::pc{'weapon'.$_.'Crit'} =~ s/⑦|➆/7/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑧|➇/8/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑨|➈/9/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑩|➉/10/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑪/11/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑫/12/;
      $::pc{'weapon'.$_.'Crit'} =~ s/⑬/13/;

      push @propaties, "//武器$_=$::pc{'weapon'.$_.'Name'}";

      if(!$::pc{'weapon'.$_.'Class'} || $::pc{'weapon'.$_.'Class'} eq '自動計算しない'){ @propaties, "//命中$_=$::pc{'weapon'.$_.'Acc'}"; }
      else { push @propaties, "//命中$_=({$::pc{'weapon'.$_.'Class'}}+({器用}".($::pc{'weapon'.$_.'Own'}?"+2":"").")/6+".($::pc{'weapon'.$_.'Acc'}||0).")"; }

      push @propaties, "//威力$_=$::pc{'weapon'.$_.'Rate'}";
      push @propaties, "//C値$_=$::pc{'weapon'.$_.'Crit'}";

      if(!$::pc{'weapon'.$_.'Class'} || $::pc{'weapon'.$_.'Class'} eq '自動計算しない'){ @propaties, "//追加D$_=$::pc{'weapon'.$_.'Dmg'}"; }
      else {
        my $basetext;
        if   ($::pc{'weapon'.$_.'Category'} eq 'クロスボウ'){ $basetext = "{$::pc{'weapon'.$_.'Class'}}"; }
        elsif($::pc{'weapon'.$_.'Category'} eq 'ガン'      ){ $basetext = "{魔動機術}"; }
        else { $basetext = "{$::pc{'weapon'.$_.'Class'}}+({筋力})/6"; }
        my $mastery = $::pc{'mastery' . ucfirst($data::weapon_id{ $::pc{'weapon'.$_.'Category'} }) };
           $basetext .= $mastery ? "+$mastery" : '';
        push @propaties, "//追加D$_=(${basetext}+".($::pc{'weapon'.$_.'Dmg'}||0).")";
      }

      push @propaties, '';
    }
    
    push @propaties, "//回避=({$::pc{'evasionClass'}}+({敏捷})/6+".($::pc{'evasiveManeuver'}+$::pc{'armourEva'}+$::pc{'shieldEva'}+$::pc{'defOtherEva'}).")";
    push @propaties, "//回避（盾なし）=({$::pc{'evasionClass'}}+({敏捷})/6+".($::pc{'evasiveManeuver'}+$::pc{'armourEva'}+$::pc{'defOtherEva'}).")";
    push @propaties, "//防護=$::pc{'defenseTotalAllDef'}";
    
  }
  ## 魔物
  elsif($type eq 'm') {
    push @propaties, "//LV=$::pc{'lv'}";
    push @propaties, '';
    push @propaties, "//生命抵抗=$::pc{'vitResist'}";
    push @propaties, "//精神抵抗=$::pc{'mndResist'}";
    
    push @propaties, '';
    foreach (1 .. $::pc{'statusNum'}){
      push @propaties, "//部位$_=$::pc{'status'.$_.'Style'}";
      push @propaties, "//命中$_=$::pc{'status'.$_.'Accuracy'}" if $::pc{'status'.$_.'Accuracy'} ne '';
      push @propaties, "//ダメージ$_=$::pc{'status'.$_.'Damage'}" if $::pc{'status'.$_.'Damage'} ne '';
      push @propaties, "//回避$_=$::pc{'status'.$_.'Evasion'}" if $::pc{'status'.$_.'Evasion'} ne '';
      push @propaties, '';
    }
    my $skills = $::pc{'skills'};
    $skills =~ tr/０-９（）/0-9\(\)/;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+?)(?:[0-9]+(?:レベル|LV)|\(.+\))*[\/／](?:魔力)([0-9]+)[(（][0-9]+[）)]/push @propaties, "\/\/$1=$2";/megi;
    $skills =~ s/^(?:[○◯〇△＞▶〆☆≫»□☑🗨]|&gt;&gt;)+(.+)[\/／]([0-9]+)[(（][0-9]+[）)]/push @propaties, "\/\/$1=$2";/megi;
  }
  
  return @propaties;
}

1;