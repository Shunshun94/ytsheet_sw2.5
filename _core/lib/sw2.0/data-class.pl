#################### データ ####################
use strict;
use utf8;

package data;

require $::core_dir.'/lib/sw2/data-class.pl';

### 魔法技能一覧 --------------------------------------------------
our @class_caster = (
  'ソーサラー',
  'コンジャラー',
  'ウィザード',
  'プリースト',
  'フェアリーテイマー',
  'マギテック',
  'デーモンルーラー',
  'グリモワール',
  'ドルイド',
);

### 技能詳細データ --------------------------------------------------
$data::class{'スカウト'}{package} = {
  Dex => { name => '器用', stt => 'A' },
  Agi => { name => '敏捷', stt => 'B', initiative => 1 },
  Int => { name => '知力', stt => 'E' },
};
$data::class{'レンジャー'}{package} = {
  Dex => { name => '器用', stt => 'A' },
  Agi => { name => '敏捷', stt => 'B' },
  Int => { name => '知力', stt => 'E' },
};
$data::class{'セージ'}{package} = {
  Int => { name => '知力', stt => 'E', monsterLore => 1 },
};
$data::class{'バード'}{package} = {
  Int => { name => '見識', stt => 'E' },
};
$data::class{'ライダー'}{package} = {
  Agi => { name => '敏捷', stt => 'B' },
  Int => { name => '知力', stt => 'E', monsterLore => 1 },
};
$data::class{'アルケミスト'}{package} = {
  Int => { name => '知力', stt => 'E' },
};
$data::class{'ジオマンサー'}{package} = {
  Int => { name => '知力', stt => 'E' },
};
$data::class{'ウィザード'} = {
  expTable => '',
  id       => 'Wiz',
  eName    => 'wizard',
  magic => {
    jName => '深智魔法',
    eName => 'wizardry',
  },
};
$data::class{'バード'}{craft}{data} = [
  [ 1,'アーリーバード'],
  [ 1,'アンビエント'],
  [ 1,'サモン・スモールアニマル'],
  [ 1,'サモン・フィッシュ'],
  [ 1,'ノイズ'],
  [ 1,'バラード'],
  [ 1,'ヒーリング'],
  [ 1,'ビビッド'],
  [ 1,'モラル'],
  [ 1,'ララバイ'],
  [ 1,'レクイエム'],
  [ 1,'レジスタンス'],
  [ 5,'アトリビュート'],
  [ 5,'キュアリオスティ'],
  [ 5,'チャーミング'],
  [ 5,'チョーク'],
  [ 5,'ヌーディ'],
  [ 5,'ノスタルジィ'],
  [ 5,'ビター'],
  [ 5,'ラブソング'],
  [10,'アメージング'],
  [10,'クラップ'],
  [10,'コーラス'],
  [10,'ソニックヴォイス'],
  [10,'ダル'],
  [10,'ダンス'],
  [10,'フォール'],
  [10,'マーチ'],
  [10,'リダクション'],
  [10,'レイジィ'],
  [16,'グラント'],
  [16,'ヒム'],
  [16,'リラックス'],
];
$data::class{'ライダー'}{craft}{data} = [
  [ 1,'威嚇'],
  [ 1,'遠隔指示'],
  [ 1,'騎獣強化'],
  [ 1,'騎獣の献身'],
  [ 1,'攻撃阻害'],
  [ 1,'高所攻撃'],
  [ 1,'探索指令'],
  [ 1,'タンデム'],
  [ 1,'チャージ'],
  [ 1,'HP強化'],
  [ 5,'限界駆動'],
  [ 5,'獅子奮迅'],
  [ 5,'人馬一体'],
  [ 5,'超高所攻撃'],
  [ 5,'特殊能力解放'],
  [ 5,'トランプル'],
  [ 5,'魔法指示'],
  [ 5,'HP超強化'],
  [ 5,'MP譲渡'],
  [10,'騎獣超強化'],
  [10,'騎乗指揮'],
  [10,'極高所攻撃'],
  [10,'縦横無尽'],
  [10,'スーパーチャージ'],
  [10,'超過駆動'],
  [10,'超攻撃阻害'],
  [10,'特殊能力完全解放'],
  [10,'八面六臂'],
  [10,'バランス'],
  [16,'潜在覚醒'],
  [16,'超越騎獣'],
  [16,'超人馬一体'],
  [16,'瞬発力','ケンタウロス専用'],
  [16,'零距離突撃','ケンタウロス専用'],
  [16,'スーパートランプル','ケンタウロス専用'],
];
$data::class{'アルケミスト'}{craft}{data} = [
  [ 1,'インスタントウェポン',''],
  [ 1,'ヴォーパルウェポン',''],
  [ 1,'クラッシュファング',''],
  [ 1,'クリティカルレイ',''],
  [ 1,'バークメイル',''],
  [ 1,'パラライズミスト',''],
  [ 1,'ポイズンニードル',''],
  [ 1,'ミラージュデイズ',''],
  [ 5,'アーマーラスト',''],
  [ 5,'アンロックニードル',''],
  [ 5,'イニシアティブブースト',''],
  [ 5,'エンサイクロペディア',''],
  [ 5,'グレイテストフォーチュン',''],
  [ 5,'コンセントレーション',''],
  [ 5,'ディスペルニードル',''],
  [ 5,'バインドアビリティ',''],
  [ 5,'ヒールスプレー',''],
  [ 5,'ビビッドリキッド',''],
  [ 5,'マナダウン',''],
  [ 5,'リーンフォース',''],
  [10,'クレイフィールド',''],
  [10,'コンバインマテリアル',''],
  [10,'スラッシュフィールド',''],
  [10,'ディバイドマテリアル',''],
  [10,'バリアフィールド',''],
  [10,'フレイムフィールド',''],
  [10,'レストフィールド',''],
  [16,'プリズムカーテン',''],
  [16,'ライフステイシス',''],
  [16,'マテリアルブレイク',''],
];
$data::class{'ウォーリーダー'}{package}{Int}{unlockCraft} = '軍師の知略';
$data::class{'ウォーリーダー'}{craft}{data} = [
  [1,'神速の構え',''],
  [1,'堅陣の構え',''],
  [1,'怒濤の攻陣Ⅰ',''],
  [1,'怒濤の攻陣Ⅱ：烈火',''],
  [1,'怒濤の攻陣Ⅱ：旋風',''],
  [1,'流麗なる俊陣Ⅰ',''],
  [1,'流麗なる俊陣Ⅱ：陽炎',''],
  [1,'流麗なる俊陣Ⅱ：流水',''],
  [1,'鉄壁の防陣Ⅰ',''],
  [1,'鉄壁の防陣Ⅱ：鉄鎧',''],
  [1,'鉄壁の防陣Ⅱ：堅体',''],
  [1,'強靭なる丈陣Ⅰ：抵体',''],
  [1,'強靭なる丈陣Ⅰ：抗心',''],
  [1,'強靭なる丈陣Ⅱ：強身',''],
  [1,'強靭なる丈陣Ⅱ：精定',''],
  [1,'強靭なる丈陣Ⅱ：安精',''],
  [1,'軍師の知略',''],
  [5,'怒濤の攻陣Ⅲ：轟炎',''],
  [5,'怒濤の攻陣Ⅲ：旋刃',''],
  [5,'怒濤の攻陣Ⅳ：爆焔',''],
  [5,'怒濤の攻陣Ⅳ：輝斬',''],
  [5,'流麗なる俊陣Ⅲ：浮身',''],
  [5,'流麗なる俊陣Ⅲ：幻惑',''],
  [5,'流麗なる俊陣Ⅳ：残影',''],
  [5,'流麗なる俊陣Ⅳ：瞬脱',''],
  [5,'鉄壁の防陣Ⅲ：鋼鎧',''],
  [5,'鉄壁の防陣Ⅲ：甲盾',''],
  [5,'鉄壁の防陣Ⅳ：反攻',''],
  [5,'鉄壁の防陣Ⅳ：無敵',''],
  [5,'強靭なる丈陣Ⅲ：剛体',''],
  [5,'強靭なる丈陣Ⅲ：整身',''],
  [5,'強靭なる丈陣Ⅲ：心清',''],
  [5,'強靭なる丈陣Ⅳ：克己',''],
  [5,'強靭なる丈陣Ⅳ：賦活',''],
  [5,'強靭なる丈陣Ⅳ：清涼',''],
  [5,'蘇る秘奥',''],
  [5,'勇壮なる軍歌',''],
  [10,'怒濤の攻陣Ⅴ：獄火',''],
  [10,'怒濤の攻陣Ⅴ：颱風',''],
  [10,'流麗なる俊陣Ⅴ：水鏡',''],
  [10,'流麗なる俊陣Ⅴ：影駆',''],
  [10,'鉄壁の防陣Ⅴ：鋼城',''],
  [10,'鉄壁の防陣Ⅴ：槍塞',''],
  [10,'強靭なる丈陣Ⅴ：激生',''],
  [10,'強靭なる丈陣Ⅴ：魔泉',''],
  [10,'大いなる挑発',''],
  [16,'怒濤の攻陣Ⅴ：鬼神',''],
  [16,'怒濤の攻陣Ⅴ：宿業',''],
  [16,'流麗なる俊陣Ⅴ：泡沫',''],
  [16,'鉄壁の防陣Ⅴ：要塞',''],
  [16,'強靭なる丈陣Ⅴ：不滅',''],
];

$data::class{'フィジカルマスター'}{craft}{data} = ['ドレイク（ナイト）','バジリスク'];
$data::class{'フィジカルマスター'}{craft}{data} = [
  [1,'アイテム収納',''],
  [1,'生来武器強化A',''],
  [1,'属性付与',''],
  [1,'部位強化',''],
  [1,'部位耐久増強',''],
  [1,'コア耐久増強',''],
  [1,'ブレス強化','ドレイク専用'],
  [1,'魔剣ランク上昇A','ドレイク専用'],
  [1,'魔剣形状変更','ドレイク専用'],
  [1,'暗視付与','バジリスク専用'],
  [1,'邪視強化A／石化','バジリスク専用'],
  [1,'邪視強化A／貫く','バジリスク専用'],
  [1,'邪視強化A／破錠','バジリスク専用'],
  [1,'邪視強化A／賦活','バジリスク専用'],
  [1,'邪視強化A／高揚','バジリスク専用'],
  [1,'邪視強化A／消散','バジリスク専用'],
  [1,'邪視強化A／蘇る','バジリスク専用'],
  [1,'邪視強化A／全天','バジリスク専用'],
  [1,'邪視強化A／操位','バジリスク専用'],
  [1,'邪視強化A／潜魂','バジリスク専用'],
  [1,'邪視強化A／停滞','バジリスク専用'],
  [1,'邪視強化A／その他','バジリスク専用'],
  [1,'邪視拡大／達成値','バジリスク専用'],
  [1,'邪視拡大／戦闘特技','バジリスク専用'],
  [5,'渾身攻撃',''],
  [5,'生来武器強化S',''],
  [5,'部位超強化',''],
  [5,'部位耐久超増強',''],
  [5,'コア耐久超増強',''],
  [5,'練技使用',''],
  [5,'魔剣+1','ドレイク専用'],
  [5,'魔剣吸収','ドレイク専用'],
  [5,'魔剣ランク上昇S','ドレイク専用'],
  [5,'邪視拡大／数','バジリスク専用'],
  [5,'邪視強化S／石化','バジリスク専用'],
  [5,'邪視強化S／貫く','バジリスク専用'],
  [5,'邪視強化S／破錠','バジリスク専用'],
  [5,'邪視強化S／賦活','バジリスク専用'],
  [5,'邪視強化S／高揚','バジリスク専用'],
  [5,'邪視強化S／消散','バジリスク専用'],
  [5,'邪視強化S／蘇る','バジリスク専用'],
  [5,'邪視強化S／全天','バジリスク専用'],
  [5,'邪視強化S／操位','バジリスク専用'],
  [5,'邪視強化S／潜魂','バジリスク専用'],
  [5,'邪視強化S／停滞','バジリスク専用'],
  [5,'邪視強化S／その他','バジリスク専用'],
  [5,'巨大な身体','バジリスク専用'],
  [10,'生来武器強化SS',''],
  [10,'部位極強化',''],
  [10,'部位耐久極増強',''],
  [10,'コア耐久極増強',''],
  [10,'魔将の領域',''],
  [10,'マナ解除',''],
  [10,'燦光のブレス','ドレイク専用'],
  [10,'魔剣ランク上昇SS','ドレイク専用'],
  [10,'邪眼追加','バジリスク専用'],
  [10,'邪視強化SS／石化','バジリスク専用'],
  [10,'邪視強化SS／貫く','バジリスク専用'],
  [10,'邪視強化SS／破錠','バジリスク専用'],
  [10,'邪視強化SS／賦活','バジリスク専用'],
  [10,'邪視強化SS／高揚','バジリスク専用'],
  [10,'邪視強化SS／消散','バジリスク専用'],
  [10,'邪視強化SS／蘇る','バジリスク専用'],
  [10,'邪視強化SS／全天','バジリスク専用'],
  [10,'邪視強化SS／操位','バジリスク専用'],
  [10,'邪視強化SS／潜魂','バジリスク専用'],
  [10,'邪視強化SS／停滞','バジリスク専用'],
  [10,'邪視強化SS／その他','バジリスク専用'],
  [10,'魔法使用','バジリスク専用'],
  [16,'再生／その他部位',''],
  [16,'マナ耐性／その他部位',''],
  [16,'灼熱のブレス','ドレイク専用'],
  [16,'魔剣+2','ドレイク専用'],
  [16,'邪眼追加Ⅱ','バジリスク専用'],
  [16,'巨大な身体Ⅱ','バジリスク専用'],
];
$data::class{'ソーサラー'      }{magic}{trancendOnly} = 1;
$data::class{'コンジャラー'    }{magic}{trancendOnly} = 1;
$data::class{'ウィザード'      }{magic}{trancendOnly} = 1;
$data::class{'プリースト'      }{magic}{trancendOnly} = 1;
$data::class{'マギテック'      }{magic}{trancendOnly} = 1;
$data::class{'デーモンルーラー'}{magic}{trancendOnly} = 1;
$data::class{'ソーサラー'}{magic}{data} = [
  [16,'デュアル・インパクト'],
  [16,'フィクス・エンチャントメント'],
  [16,'マナ・バースト'],
];
$data::class{'コンジャラー'}{magic}{data} = [
  [16,'アース・ヒールⅢ'],
  [16,'テンポラリィ・リザレクション'],
  [16,'プリセット・ドール'],
];
$data::class{'ウィザード'}{magic}{data} = [
  [16,'スペル・エンハンスⅡ'],
  [16,'ユースレス・マテリアル'],
  [16,'ハイパー・レジスタンス'],
];
$data::class{'プリースト'}{magic}{data} = [
  [16,'ゴッド・ストンプ'],
  [16,'バトルソングⅡ'],
  [16,'ホーリー・ブレッシングⅡ'],
];
$data::class{'マギテック'}{magic}{data} = [
  [16,'アドバンスド・ボム'],
  [16,'リープレンジ・ショット'],
  [16,'リフレッシュ・バレット'],
];
$data::class{'デーモンルーラー'}{magic}{data} = [
  [16,'ガルムゲート'],
  [16,'デモンズグレイヴ'],
  [16,'ブラッドジェイル'],
];
$data::class{'デーモンルーラー'}{magic}{accUnlock} = { lv => 1 };
$data::class{'デーモンルーラー'}{magic}{evaUnlock} = { lv => 7 };

### 求道者 --------------------------------------------------
our @seeker_lv = (
  '',
  '全能力値上昇Ⅰ', '防護点上昇Ⅰ', '成長枠獲得Ⅰ', '特殊能力獲得Ⅰ',
  '全能力値上昇Ⅱ', '防護点上昇Ⅱ', '成長枠獲得Ⅱ', '特殊能力獲得Ⅱ',
  '全能力値上昇Ⅲ', '防護点上昇Ⅲ', '成長枠獲得Ⅲ', '特殊能力獲得Ⅲ',
  '全能力値上昇Ⅳ', '防護点上昇Ⅳ', '成長枠獲得Ⅳ', '特殊能力獲得Ⅳ',
  '全能力値上昇Ⅴ', '防護点上昇Ⅴ', '成長枠獲得Ⅴ', '特殊能力獲得Ⅴ',
);
our @seeker_abilities = (
  'ＨＰ、ＭＰ上昇',
  '抵抗力上昇',
  '魔力上昇',
  '超越騎獣の使用と強化',
  'その他部位の強化',
  '戦闘開始時判定へのボーナス修正',
  '複数宣言＝２回',
  '２回行動',
  '種族特徴の獲得、強化'
);
1;