################ シンドローム ################
use strict;
use utf8;

package data;

our @igrs = (
  "悪役",
  "攻略対象",
  "主人公",
  "モブ",
  "不在"
);

our %igrs_status = (
  "悪役"     => [13, 10, 11, 11,  7,  8],
  "攻略対象" => [ 7,  8,  8,  7, 15, 15],
  "主人公"   => [ 8,  9,  8,  9, 20,  6],
  "モブ"     => [12, 14, 10, 12,  7,  5],
  "不在"     => [10, 12, 12, 15,  6,  5]
);

our @elements = (
  "罪人",
  "無垢",
  "賢人",
  "近待",
  "芸人",
  "天才",
  "貴族",
  "豪商",
  "市民",
  "異邦人"
);

our %elements_status = (
  "罪人"   => [4, 9, 2, 5, 4, 4],
  "無垢"   => [0, 6, 6, 3, 9, 4],
  "賢人"   => [3, 4, 9, 4, 4, 4],
  "近待"   => [6, 6, 5, 3, 4, 4],
  "芸人"   => [6, 5, 8, 6, 2, 2],
  "天才"   => [4, 6, 8, 6, 2, 2],
  "貴族"   => [4, 2, 4, 4, 6, 8],
  "豪商"   => [4, 4, 5, 5, 2, 8],
  "市民"   => [6, 6, 6, 6, 2, 2],
  "異邦人" => [4, 5, 4, 4, 6, 5]
);

our @homes = (
  "転生者",
  "現地人"
);

our %skills = (
  "skillAtemi" => "当身",
  "skillDominate" => "威圧",
  "skillExercise" => "運動",
  "skillHide" => "隠密",
  "skillPicking" => "解錠",
  "skillDodge" => "回避",
  "skillObserve" => "観察",
  "skillWeapon" => "近接武器",
  "skillMagic" => "攻撃魔法",
  "skillNegotiation" => "交渉",
  "skillRepair" => "修理",
  "skillHorse" => "乗馬",
  "skillSearch" => "探索",
  "skillInvestigate" => "調査",
  "skillTrace" => "追跡/逃走",
  "skillRegist" => "抵抗力",
  "skillProjectile" => "飛び道具",
  "skillMachine" => "魔法機械操作"
);

1;