################## チャットパレット用サブルーチン ##################
use strict;
#use warnings;
use utf8;

require $set::consts;

### プリセット #######################################################################################
sub palettePreset {
  my $tool = shift;
  my $type = shift;
  my $text;
  my %bot;
  if   (!$tool)           { $bot{'YTC'} = 1; }
  elsif($tool eq 'bcdice'){ $bot{'BCD'} = 1; }

  if($tool eq 'bcdice') {
    $text =~ s/^(.+?)dx(.+?)@(.+?)(\s|$)/\($1\)dx$2\@($3)$4/mg;
  }
  
  return palettePresetSimple();
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
    $text .= "### ■判定\n";
    $text .= "RB{身体} 【身体】判定\n";
    $text .= "RB{感覚} 【感覚】判定\n";
    $text .= "RB{知力} 【知力】判定\n";
    $text .= "RB{意志} 【意志】判定\n";
    $text .= "RB{魅力} 【魅力】判定\n";
    $text .= "RB{社会} 【社会】判定\n";
    $text .= "\n";
    $text .= "FPD1 FPへのダメージロール\n";
    $text .= "FPR1 FPの回復ロール\n";
    $text .= "\n";

    foreach my $num (1 .. $::pc{'weaponNum'}){
      $text .= "$::pc{'weapon'.$num.'Atk'} $::pc{'weapon'.$num.'Name'}ダメージ（$::pc{'weapon'.$num.'Effect'}属性）\n";
    }
    $text .= "\n";

    my %skillLevelTable = (
      "得意"   => "+20",
      "不得意" => "-20"
    );
    my %status = ("身体"=>'Body', "感覚"=>'Sense', "知力"=>'Intelligence', "意志"=>'Will', "魅力"=>'Charm', "社会"=>'Social');
    foreach my $skillColumn (keys %data::skills) {
      if($::pc{$skillColumn}) {
        foreach my $statusColumn(keys %status) {
          $text .= "RB{$statusColumn}$skillLevelTable{$::pc{$skillColumn}} 【$statusColumn・$data::skills{$skillColumn}】\n";
        }
      }
    }


    foreach my $num (1 .. $::pc{'skillRideNum'}){
      $text .= "$::pc{'sttTotalBody'}+{DB}dx+".($::pc{'skillTotalRide'.$num}||0)."+{AB}\@10+{CB} 〈$::pc{'skillRide'.$num.'Name'}〉判定\n" if $::pc{'skillRide'.$num.'Name'};
    }
    foreach my $num (1 .. $::pc{'skillArtNum'}){
      $text .= "$::pc{'sttTotalSense'}+{DB}dx+".($::pc{'skillTotalArt'.$num}||0)."+{AB}\@10+{CB} 〈$::pc{'skillArt'.$num.'Name'}〉判定\n"  if $::pc{'skillArt'.$num.'Name'};
    }
    foreach my $num (1 .. $::pc{'skillKnowNum'}){
      $text .= "$::pc{'sttTotalMind'}+{DB}dx+".($::pc{'skillTotalKnow'.$num}||0)."+{AB}\@10+{CB} 〈$::pc{'skillKnow'.$num.'Name'}〉判定\n" if $::pc{'skillKnow'.$num.'Name'};
    }
    foreach my $num (1 .. $::pc{'skillInfoNum'}){
      $text .= "$::pc{'sttTotalSocial'}+{DB}dx+".($::pc{'skillTotalInfo'.$num}||0)."+{AB}\@10+{CB} 〈$::pc{'skillInfo'.$num.'Name'}〉判定\n" if $::pc{'skillInfo'.$num.'Name'};
    }
    $text .= "\n";
    foreach my $num (1 .. $::pc{'comboNum'}){
      next if !$::pc{'combo'.$num.'Name'};
      $text .= "### ■コンボ: $::pc{'combo'.$num.'Name'}\n";
      $text .= "【$::pc{'combo'.$num.'Name'}】：$::pc{'combo'.$num.'Combo'}\n";
      foreach my $i (1..4) {
        next if !$::pc{'combo'.$num.'Condition'.$i};
        $text .= "▼$::pc{'combo'.$num.'Condition'.$i} ----------\n" if $bot{'YTC'};
        if(!$::pc{'comboCalcOff'}){
          if($::pc{"combo${num}Stt"}){
            if   ($::pc{"combo${num}Stt"} eq '肉体'){ $text .= $::pc{'sttTotalBody'  }.'+'; }
            elsif($::pc{"combo${num}Stt"} eq '感覚'){ $text .= $::pc{'sttTotalSense' }.'+'; }
            elsif($::pc{"combo${num}Stt"} eq '精神'){ $text .= $::pc{'sttTotalMind'  }.'+'; }
            elsif($::pc{"combo${num}Stt"} eq '社会'){ $text .= $::pc{'sttTotalSocial'}.'+'; }
          }
          else {
            if   ($::pc{"combo${num}Skill"} =~ /^(白兵|回避|運転)/){ $text .= $::pc{'sttTotalBody'  }.'+';  }
            elsif($::pc{"combo${num}Skill"} =~ /^(射撃|知覚|芸術)/){ $text .= $::pc{'sttTotalSense' }.'+';  }
            elsif($::pc{"combo${num}Skill"} =~ /^(RC|意思|知識)/)  { $text .= $::pc{'sttTotalMind'  }.'+';  }
            elsif($::pc{"combo${num}Skill"} =~ /^(交渉|調達|情報)/){ $text .= $::pc{'sttTotalSocial'}.'+';  }
          }
        }
        $text .= ($::pc{'combo'.$num.'DiceAdd'.$i}||0)."+{DB}dx+".($::pc{'combo'.$num.'Fixed'.$i}||0)."+{AB}\@$::pc{'combo'.$num.'Crit'.$i}+{CB}";
        $text .= " 判定／$::pc{'combo'.$num.'Condition'.$i}／$::pc{'combo'.$num.'Name'}" if $bot{'BCD'};
        $text .= "\n";
        if($::pc{'combo'.$num.'Atk'.$i} ne ''){
          $text .= "d10+$::pc{'combo'.$num.'Atk'.$i}+{AtkB} ダメージ";
          $text .= "／$::pc{'combo'.$num.'Condition'.$i}／$::pc{'combo'.$num.'Name'}" if $bot{'BCD'};
          $text .= "\n";
        }
      }
      $text .= "\n";
    }
  }
  
  if($bot{'BCD'}) {
    $text =~ s/^(.+?)dx(.+?)@(.+?)(\s|$)/\($1\)dx$2\@($3)$4/mg;
  }
  
  return $text;
}

### デフォルト変数 ###################################################################################
sub paletteProperties {
  my $type = shift;
  my @propaties;
  push @propaties, "### ■能力値";
  push @propaties, "//身体=$::pc{'sttTotalBody'}"        ;
  push @propaties, "//感覚=$::pc{'sttTotalSense'}"       ;
  push @propaties, "//知力=$::pc{'sttTotalIntelligence'}";
  push @propaties, "//意志=$::pc{'sttTotalSense'}"       ;
  push @propaties, "//魅力=$::pc{'sttTotalCharm'}"       ;
  push @propaties, "//社会=$::pc{'sttTotalSocial'}"      ;

  return @propaties;
}

1;