################## データ保存 ##################
use strict;
#use warnings;
use utf8;
use POSIX qw(ceil);

require $set::consts;
my %awakens;
my %impulses;
$awakens{@$_[0]} = @$_[1] foreach(@data::awakens);
$impulses{@$_[0]} = @$_[1] foreach(@data::impulses);

sub data_calc {
  my %pc = %{$_[0]};
  ### アップデート --------------------------------------------------
  if($pc{'ver'}){
    %pc = data_update_chara(\%pc);
  }
  
$pc{'paletteTool'} = 'bcdice';

  ### 能力値 --------------------------------------------------
my %status = (0=>'Body', 1=>'Sense', 2=>'Intelligence', 3=>'Will', 4=>'Charm', 5=>'Social');
foreach my $num (keys %status){
  my $name = $status{$num};
  my $base = 20;
  $base += $data::igrs_status{$pc{'igr'}}[$num] || 0;
  $base += $data::elements_status{$pc{'element'}}[$num] || 0;
  $base += $pc{'sttBonus'.$name} || 0;
  $base += $pc{'sttGrow'.$name} || 0;
  $base += $pc{'sttOther'.$name} || 0;
  $pc{"sttTotal".$name} = $base;

  # 経験点
  #for (my $i = $base; $i < $base+$pc{'sttGrow'.$Name}; $i++){
  #  $pc{'expUsedStatus'} += ($i > 20) ? 30 : ($i > 10) ? 20 : 10;
  #}
}

  ### 副能力値 --------------------------------------------------
  $pc{'maxHpTotal'}      = int(($pc{'sttTotalBody'} + $pc{'sttTotalWill'} + $pc{'sttTotalSocial'}) / 3) + $pc{'maxHpAdd'};
  $pc{'initiativeTotal'} = int(($pc{'sttTotalBody'} + $pc{'sttTotalSense'}) / 3) + $pc{'initiativeAdd'};
  $pc{'stockTotal'} = int($pc{'sttTotalSocial'} / 2) + $pc{'stockAdd'};
  
  ### 技能 --------------------------------------------------
  my %skill_name_to_id = (
    '白兵' => 'Melee',
    '射撃' => 'Ranged',
    'RC' => 'RC',
    '交渉' => 'Negotiate',
    '回避' => 'Dodge',
    '知覚' => 'Percept',
    '意志' => 'Will',
    '調達' => 'Procure',
  );
  # 経験点
  $pc{'expUsedSkill'} = 0;

  
  ### アイテム --------------------------------------------------
  foreach my $num (1 .. $pc{'weaponNum'}){
    $pc{'stockUsed'}   += $pc{"weapon${num}Stock"};
    $pc{'expUsedItem'} += $pc{"weapon${num}Exp"};
  }
  foreach my $num (1 .. $pc{'armorNum'}){
    $pc{'stockUsed'}   += $pc{"armor${num}Stock"};
    $pc{'expUsedItem'} += $pc{"armor${num}Exp"};
  }
  foreach my $num (1 .. $pc{'vehicleNum'}){
    $pc{'stockUsed'}   += $pc{"vehicle${num}Stock"};
    $pc{'expUsedItem'} += $pc{"vehicle${num}Exp"};
  }
  foreach my $num (1 .. $pc{'itemNum'}){
    $pc{'stockUsed'}   += $pc{"item${num}Stock"};
    $pc{'expUsedItem'} += $pc{"item${num}Exp"};
  }
  $pc{'savingTotal'} -= $pc{'stockUsed'}; 
  
  ### 侵蝕率 --------------------------------------------------
  $pc{'lifepathAwakenEncroach'}  = $awakens{$pc{'lifepathAwaken'}};
  $pc{'lifepathImpulseEncroach'} = $impulses{$pc{'lifepathImpulse'}};
  $pc{'baseEncroach'} = $pc{'lifepathAwakenEncroach'} + $pc{'lifepathImpulseEncroach'} + $pc{'lifepathOtherEncroach'};
  
  ### ロイス --------------------------------------------------
  my @dloises;
  foreach my $num (1..7){
    if($pc{"lois${num}Relation"} =~ /[DＤ]ロイス|^[DＤ]$/){
      $pc{"lois${num}Name"} =~ s#/#／#g;
      push(@dloises, $pc{"lois${num}Name"});
    }
  }
  ### メモリー --------------------------------------------------
  $pc{'expUsedMemory'} = 0;
  foreach my $num (1..3){
    if($pc{"memory${num}Gain"}){
      $pc{'expUsedMemory'} += 15;
    }
  }

  ### 経験点 --------------------------------------------------
  ## 履歴から 
  $pc{'expTotal'} = $pc{"history0Exp"};
  foreach my $i (1 .. $pc{'historyNum'}){
    $pc{'expTotal'} += s_eval($pc{"history${i}Exp"}) if $pc{"history${i}ExpApply"};
  }

  ## 経験点消費
  $pc{'expRest'} = $pc{'expTotal'};
  $pc{'expUsed'} = $pc{'expUsedStatus'} + $pc{'expUsedSkill'} + $pc{'expUsedEffect'} + $pc{'expUsedMagic'} + $pc{'expUsedItem'} + $pc{'expUsedMemory'};
  $pc{'expRest'} -= $pc{'expUsed'};

  ### 0を消去 --------------------------------------------------
  foreach (
    'skillMelee','skillRanged','skillRC','skillNegotiate',
    'skillDodge','skillPercept','skillWill','skillProcure',
    'skillAddMelee','skillAddRanged','skillAddRC','skillAddNegotiate',
    'skillAddDodge','skillAddPercept','skillAddWill','skillAddProcure',
  ){
    delete $pc{$_} if !$pc{$_};
  }
  foreach (
    'Ride','Art','Know','Info',
  ){
    foreach my $num (1..$pc{'skill'.$_.'Num'}){
      delete $pc{'skill'.$_.$num} if !$pc{'skill'.$_.$num};
      delete $pc{'skillAdd'.$_.$num} if !$pc{'skillAdd'.$_.$num};
    }
  }

  #### 改行を<br>に変換 --------------------------------------------------
  $pc{'words'}         =~ s/\r\n?|\n/<br>/g;
  $pc{'freeNote'}      =~ s/\r\n?|\n/<br>/g;
  $pc{'freeHistory'}   =~ s/\r\n?|\n/<br>/g;
  $pc{'chatPalette'}   =~ s/\r\n?|\n/<br>/g;
  $pc{"combo${_}Note"}   =~ s/\r\n?|\n/<br>/g foreach (1 .. $pc{'comboNum'});
  $pc{"weapon${_}Note"}  =~ s/\r\n?|\n/<br>/g foreach (1 .. $pc{'weaponNum'});
  $pc{"armor${_}Note"}   =~ s/\r\n?|\n/<br>/g foreach (1 .. $pc{'armorNum'});
  $pc{"vehicle${_}Note"} =~ s/\r\n?|\n/<br>/g foreach (1 .. $pc{'vehicleNum'});
  $pc{"item${_}Note"}    =~ s/\r\n?|\n/<br>/g foreach (1 .. $pc{'itemNum'});

  ### newline --------------------------------------------------
  my $charactername = ($pc{'aka'} ? "“$pc{'aka'}”" : "").$pc{'characterName'};
  $charactername =~ s/[|｜]([^|｜]+?)《.+?》/$1/g;
  $_ =~ s/[|｜]([^|｜]+?)《.+?》/$1/g foreach (@dloises);
  $_ =~ s/[:：].+?$//g foreach (@dloises);
  $::newline = "$pc{'id'}<>$::file<>".
               "$pc{'birthTime'}<>$::now<>$charactername<>$pc{'playerName'}<>$pc{'group'}<>".
               "$pc{'expTotal'}<>$pc{'gender'}<>$pc{'age'}<>$pc{'sign'}<>$pc{'blood'}<>$pc{'igr'}<>".
               
               "$pc{'element'}<>".
               "$pc{'home'}<>".
               
               "$pc{'sessionTotal'}<>$pc{'image'}<> $pc{'tags'} <>$pc{'hide'}<>$pc{'stage'}<>";

  return %pc;
}

1;