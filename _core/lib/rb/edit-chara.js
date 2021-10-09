"use strict";
const gameSystem = 'sw2';

let exps = {};
let status = {};
let syndromes = [];
// ----------------------------------------
window.onload = function() {
  calcStt();
  nameSet();
  calcItem();
  imagePosition();
  changeColor();
  
  palettePresetChange();
};

// 送信前チェック ----------------------------------------
function formCheck(){
  if(form.characterName.value === '' && form.aka.value === ''){
    alert('キャラクター名か二つ名のいずれかを入力してください。');
    form.characterName.focus();
    return false;
  }
  if(form.protect.value === 'password' && form.pass.value === ''){
    alert('パスワードが入力されていません。');
    form.pass.focus();
    return false;
  }
}

// レギュレーション ----------------------------------------
function changeRegu(){
  document.getElementById("history0-exp").innerHTML = form.history0Exp.value;
}

// ステージチェック ----------------------------------------
let ccOn = 0;
function checkStage(){
  ccOn = (form.stage.value.match('クロウリングケイオス')) ? 1 : 0;
  document.querySelectorAll('.cc-only').forEach(obj =>{
    obj.style.display = ccOn ? '' : 'none';
  });
  calcMagic();
}
// シンドローム変更 ----------------------------------------

// ステータス計算 ----------------------------------------
function calcStt() {
  const igr = form.igr.value;
  const element = form.element.value;

  exps.status = 0;
  ['Body', 'Sense', 'Intelligence', 'Will', 'Charm', 'Social'].forEach((column, i)=>{
    const base = baseStatus[igr][column] + baseStatus[element][column] + 20;
    document.getElementById(`stt-base-${column}`).innerText = base;
    const bonus = Number(form[`sttBonus${column}`].value || 0);
    const grows = Number(form[`sttGrow${column}`].value || 0);
    const other = Number(form[`sttOther${column}`].value || 0);
    const total = base + bonus + grows + other;
    document.getElementById(`stt-total-${column}`).innerText = total;

    exps.status += grows * 3;
  });
  document.getElementById('exp-status').innerText = exps.status;
  calcSubStt();
}
// サブステータス
function calcSubStt() {
  calcMaxHp();
  calcInitiative();
  calcStock();
}
let maxHp = 0;
function calcMaxHp(){
  maxHp = Math.floor(['Body', 'Will', 'Social'].reduce((current, column)=>{
    return current + Number(document.getElementById(`stt-total-${column}`).innerText);
  }, 0) / 3);
  document.getElementById('max-fp-value').innerHTML = maxHp;
  document.getElementById('max-fp-total').innerText = (maxHp + (Number(form.maxFpAdd.value) || 0));
  return (maxHp + (Number(form.maxFpAdd.value) || 0));
}
const calcMaxFp = calcMaxHp;
let initiative = 0;
function calcInitiative(){
  initiative = Math.floor(['Body', 'Sense'].reduce((current, column)=>{
    return current + Number(document.getElementById(`stt-total-${column}`).innerText);
  }, 0) / 3);
  document.getElementById('initiative-value').innerText = initiative;
  document.getElementById('initiative-total').innerText = (initiative + (Number(form.initiativeAdd.value) || 0));
  return initiative;
}

let move = 0;
function calcMove(){console.warn('開発用：使わない関数が呼ばれています');}

let stock = 0;
let stockUsed = 0;
function calcStock(){
  stock = Number(document.getElementById(`stt-total-Social`).innerText) / 2;
  document.getElementById('stock-value').innerHTML = stock;
  document.getElementById("stock-total").innerHTML = (stock + (Number(form.stockAdd.value) || 0));
  document.getElementById("item-max-stock").innerHTML = (stock + (Number(form.stockAdd.value) || 0));
  calcSaving();
  return stock;
}
function calcSaving(){}

let magicDice = 0;
function calcMagicDice(){console.warn('開発用：使わない関数が呼ばれています');}
// 技能
const skillNameToId = {
  '白兵': 'Melee'    ,
  '射撃': 'Ranged'   ,
  'RC'  : 'RC'       ,  
  '交渉': 'Negotiate',
  '回避': 'Dodge'    ,
  '知覚': 'Percept'  ,
  '意志': 'Will'     ,
  '調達': 'Procure'  ,
}
let skillData = {};
function calcSkill() {

  document.getElementById('exp-skill').innerHTML = exps['skill'];
  calcExp();
}

// アイテム
function calcItem(){
  stockUsed = 0;
  let itemExp = 0;
  for (let num = 1; num <= Number(form.weaponNum.value); num++){
    stockUsed    += Number(form['weapon'+num+'Stock'].value);
    itemExp      += Number(form['weapon'+num+'Exp'].value);
  }
  for (let num = 1; num <= Number(form.armorNum.value); num++){
    stockUsed    += Number(form['armor'+num+'Stock'].value);
    itemExp      += Number(form['armor'+num+'Exp'].value);
  }
  for (let num = 1; num <= Number(form.itemNum.value); num++){
    stockUsed    += Number(form['item'+num+'Stock'].value);
    itemExp      += Number(form['item'+num+'Exp'].value);
  }
  document.getElementById("item-total-stock").innerHTML = stockUsed;
  document.getElementById('exp-item').innerText = itemExp;
}

// 経験点
function calcExp(){
  let total = Number(form['history0Exp'].value);
  for (let num = 1; num <= Number(form.historyNum.value); num++){
    const obj = form['history'+num+'Exp'];
    if(form['history'+num+'ExpApply'].checked){
      let exp = safeEval(obj.value);
      if(isNaN(exp)){
        obj.classList.add('error');
      }
      else {
        total += exp;
        obj.classList.remove('error');
      }
    }
    else { obj.classList.remove('error'); }
  }
  let rest = total;
  for (let key in exps){
    rest -= exps[key];
  }
  document.getElementById("exp-total").innerHTML = total;
  document.getElementById("exp-used-status").innerHTML = exps['status'] || 0;
  document.getElementById("exp-used-skill" ).innerHTML = exps['skill']  || 0;
  document.getElementById("exp-used-effect").innerHTML = exps['effect'] || 0;
  document.getElementById("exp-used-magic" ).innerHTML = exps['magic'] || 0;
  document.getElementById("exp-used-item"  ).innerHTML = exps['item']   || 0;
  document.getElementById("exp-used-memory").innerHTML = exps['memory'] || 0;
  document.getElementById("exp-rest").innerHTML = rest;
}

// 侵蝕値 ----------------------------------------
function calcEncroach(){
  console.warn('開発用：使わない関数が呼ばれています');
}

// ロイス ----------------------------------------
function emoP(num){ console.warn('開発用：使わない関数が呼ばれています'); }
function emoN(num){ console.warn('開発用：使わない関数が呼ばれています'); }
function changeLoisColor(num){
  console.warn('開発用：使わない関数が呼ばれています');
}
function changeFlagState(id){
  const obj = document.querySelector(`#${id} [name$="State"]`);
  let state = obj.value;
  state = (state == '未回収') ? '回収済' : '未回収';
  obj.value = state;
  document.getElementById(id+'-state').dataset.state = state;
}
// ソート
let loisSortable = Sortable.create(document.querySelector('#lois-table tbody'), {
  group: "lois",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onUpdate: function (evt) {
    const order = loisSortable.toArray();
    let num = 1;
    for(let id of order) {
      if(document.getElementById(id)){
        document.querySelector(`#${id} [name$="Relation"]`    ).setAttribute('name',`lois${num}Relation`);
        document.querySelector(`#${id} [name$="Name"]`        ).setAttribute('name',`lois${num}Name`);
        document.querySelector(`#${id} [name$="Note"]`        ).setAttribute('name',`lois${num}Note`);
        document.querySelector(`#${id} [name$="State"]`       ).setAttribute('name',`lois${num}State`);
        num++;
      }
    }
  }
});
// リセット
function resetLois(num){
  form[`lois${num}Relation`].value = '';
  form[`lois${num}Name`    ].value = '';
  form[`lois${num}Note`    ].value = '';
  form[`lois${num}State`   ].value = '未回収';
  document.getElementById(`lois${num}-state`).dataset.state = '未回収';
}
function resetLoisAll(){
  if (!confirm('全てのフラグを削除します。よろしいですか？')) return false;
  for(let num = 1; num <= 7; num++){
    resetLois(num);
  }
}
function resetLoisAdd(){
  if (!confirm('4～7番目のフラグを削除します。よろしいですか？')) return false;
  for(let num = 4; num <= 7; num++){
    resetLois(num);
  }
}

// 技能欄 ----------------------------------------
// 追加
function addSkill(type){
  let num = Number(form[`skill${type}Num`].value) + 1;
  let dt = document.createElement('dt');
  let dd = document.createElement('dd');
  dt.innerHTML = `<input name="skill${type}${num}Name" type="text" list="list-${type.toLowerCase()}">`;
  dd.innerHTML = `<input name="skill${type}${num}" type="number" oninput="calcSkill()">+<input name="skillAdd${type}${num}" type="number" oninput="calcSkill()">`;
  const status = (
    type === 'Ride' ? 'body'   :
    type === 'Art'  ? 'sense'  :
    type === 'Know' ? 'mind'   :
    type === 'Info' ? 'social' :
    ''
  );
  const target = document.querySelector(`#skill-${status}-table`);
  target.appendChild(dt, target);
  target.appendChild(dd, target);
  
  form[`skill${type}Num`].value = num;
}
// 削除
function delSkill(type){
  let num = Number(form[`skill${type}Num`].value);
  if(num > 1){
    if(form[`skill${type}${num}Name`].value || form[`skill${type}${num}`].value || form[`skillAdd${type}${num}`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const status = (
      type === 'Ride' ? 'body'   :
      type === 'Art'  ? 'sense'  :
      type === 'Know' ? 'mind'   :
      type === 'Info' ? 'social' :
      ''
    );
    const target = document.querySelector(`#skill-${status}-table`);
    target.lastElementChild.remove();
    target.lastElementChild.remove();
    num--;
    form[`skill${type}Num`].value = num;
    calcSkill();
  }
}

// ソート
let effectSortable = Sortable.create(document.getElementById('effect-table'), {
  group: "effect",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onSort: function(evt){ effectSortAfter(); },
  onStart: function(evt){
    document.querySelectorAll('.trash-box').forEach((obj) => { obj.style.display = 'none' });
  }
});

function effectSortAfter(){
  const order = effectSortable.toArray();
  for(let id of order) {
    if(document.getElementById(id)){
      document.querySelector(`#${id} [name$="Name"]`    ).setAttribute('name',`effect${num}Name`);
      document.querySelector(`#${id} [name$="Note"]`    ).setAttribute('name',`effect${num}Note`);
    }
  }
}


// 術式欄 ----------------------------------------
// 追加
function addTalent(){
  let num = Number(form.talentNum.value) + 1;
  let tbody = document.createElement('tbody');
  tbody.setAttribute('id',idNumSet('talent'));
  tbody.innerHTML = `<tr>
    <td class="handle"></td>
    <td><input name="magic${num}Name"     type="text"   placeholder="名称"></td>
    <td><input name="magic${num}Note"     type="text"   placeholder="効果"></td>
  </tr>`;
  const target = document.querySelector("#effect-table");
  target.appendChild(tbody);
  
  form.talentNum.value = num;
  document.querySelector('#exp-effect').innerText = (Number(form.talentNum.value) - 2) * 15;
}
// 削除
function delTalent(){
  let num = Number(form.talentNum.value);
  if(num > 2){
    if(form[`magic${num}Name`].value || form[`magic${num}Note`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#effect-table tbody:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.talentNum.value = num;
    document.querySelector('#exp-effect').innerText = (Number(form.talentNum.value) - 2) * 15;
  }
}

function addCheat() {
  let num = Number(form.cheatNum.value) + 1;
  let tbody = document.createElement('tbody');
  tbody.setAttribute('id',idNumSet('cheat'));
  tbody.innerHTML = `<tr>
    <td class="handle"></td>
    <td><input name="cheat${num}Name"     type="text"   placeholder="名称"></td>
    <td><input name="cheat${num}Cost"     type="text"   placeholder="効果"></td>
    <td><input name="cheat${num}Note"     type="text"   placeholder="効果"></td>
  </tr>`;
  const target = document.querySelector("#magic-table");
  target.appendChild(tbody);

  form.cheatNum.value = num;
  document.querySelector('#exp-magic').innerText = (Number(form.cheatNum.value) - 3) * 30;
}

function delCheat() {
  let num = Number(form.cheatNum.value);
  if(num > 3){
    if(form[`cheat${num}Name`].value || form[`cheat${num}Cost`].value || form[`cheat${num}Note`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#magic-table tbody:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.cheatNum.value = num;
    document.querySelector('#exp-magic').innerText = (Number(form.cheatNum.value) - 3) * 30;
  }
}

// ソート
let magicSortable = Sortable.create(document.getElementById('magic-table'), {
  group: "magic",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onSort: function(evt){ magicSortAfter(); },
  onStart: function(evt){
    document.querySelectorAll('.trash-box').forEach((obj) => { obj.style.display = 'none' });
  }
});

function magicSortAfter(){
  const order = magicSortable.toArray();
  let num = 1;
  for(let id of order) {
    if(document.getElementById(id)){
      document.querySelector(`#${id} [name$="Name"]`    ).setAttribute('name',`cheat${num}Name`);
      document.querySelector(`#${id} [name$="Cost"]`).setAttribute('name',`cheat${num}Cost`);
      document.querySelector(`#${id} [name$="Note"]`    ).setAttribute('name',`cheat${num}Note`);
      num++;
    }
  }
  form.cheatNum.value = num-1;
}

// コンボ欄 ----------------------------------------
// 技能セット
function comboSkillSetAll(){
  console.warn('開発用：使わない関数が呼ばれています');
}
function comboSkillSet(num){
  console.warn('開発用：使わない関数が呼ばれています');
}
// 計算
function calcComboAll(){
  console.warn('開発用：使わない関数が呼ばれています');
}
function calcCombo(num){console.warn('開発用：使わない関数が呼ばれています');}

// 武器欄 ----------------------------------------
// 追加
function addWeapon(){
  let num = Number(form.weaponNum.value) + 1;
  let tbody = document.createElement('tr');
  tbody.setAttribute('id',idNumSet('weapon'));
  tbody.innerHTML = `
    <td><input name="weapon${num}Name"  type="text"><span class="handle"></span></td>
    <td><input name="weapon${num}Stock" type="number" oninput="calcItem()"></td>
    <td><input name="weapon${num}Exp" type="number" oninput="calcItem()"></td>
    <td><input name="weapon${num}Initiative" type="number"></td>
    <td><input name="weapon${num}Type"  type="text" list="list-weapon-type"></td>
    <td><input name="weapon${num}Effect" type="text" list="list-weapon-effect"></td>
    <td><input name="weapon${num}Atk" type="text"></td>
    <td><input name="weapon${num}Target" type="text" list="list-weapon-target"></td>
    <td><input name="weapon${num}Range" type="text"></td>
    <td><textarea name="weapon${num}Note" rows="2"></textarea></td>
  `;
  const target = document.querySelector("#weapon-table tbody");
  target.appendChild(tbody, target);
  
  form.weaponNum.value = num;
}
// 削除
function delWeapon(){
  let num = Number(form.weaponNum.value);
  if(num > 1){
    if(form[`weapon${num}Name`].value || form[`weapon${num}Stock`].value || form[`weapon${num}Exp`].value || form[`weapon${num}Initiative`].value || form[`weapon${num}Type`].value || form[`weapon${num}Effect`].value || form[`weapon${num}Atk`].value || form[`weapon${num}Target`].value || form[`weapon${num}Range`].value || form[`weapon${num}Note`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#weapon-table tbody tr:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.weaponNum.value = num;
    calcItem();
  }
}
// ソート
let weaponSortable = Sortable.create(document.querySelector('#weapon-table tbody'), {
  group: "weapon",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onUpdate: function (evt) {
    const order = weaponSortable.toArray();
    let num = 1;
    for(let id of order) {
      if(document.getElementById(id)){
        document.querySelector(`#${id} [name$="Name"]` ).setAttribute('name',`weapon${num}Name`);
        document.querySelector(`#${id} [name$="Stock"]`).setAttribute('name',`weapon${num}Stock`);
        document.querySelector(`#${id} [name$="Exp"]`  ).setAttribute('name',`weapon${num}Exp`);
        document.querySelector(`#${id} [name$="Type"]` ).setAttribute('name',`weapon${num}Type`);
        document.querySelector(`#${id} [name$="Skill"]`).setAttribute('name',`weapon${num}Skill`);
        document.querySelector(`#${id} [name$="Acc"]`  ).setAttribute('name',`weapon${num}Acc`);
        document.querySelector(`#${id} [name$="Atk"]`  ).setAttribute('name',`weapon${num}Atk`);
        document.querySelector(`#${id} [name$="Guard"]`).setAttribute('name',`weapon${num}Guard`);
        document.querySelector(`#${id} [name$="Range"]`).setAttribute('name',`weapon${num}Range`);
        document.querySelector(`#${id} [name$="Note"]` ).setAttribute('name',`weapon${num}Note`);
        num++;
      }
    }
  }
});
// 防具欄 ----------------------------------------
// 追加
function addArmor(){
  let num = Number(form.armorNum.value) + 1;
  let tbody = document.createElement('tr');
  tbody.setAttribute('id',idNumSet('armor'));
  tbody.innerHTML = `
    <td><input name="armor${num}Name"  type="text"><span class="handle"></span></td>
    <td><input name="armor${num}Stock" type="number" oninput="calcItem()"></td>
    <td><input name="armor${num}Exp" type="number" oninput="calcItem()"></td>

    <td><input name="armor${num}ArmorCut"   type="number"></td>
    <td><input name="armor${num}ArmorPenetration"   type="number"></td>
    <td><input name="armor${num}ArmorImpact"   type="number"></td>

    <td><input name="armor${num}ArmorGround"   type="number"></td>
    <td><input name="armor${num}ArmorWater"   type="number"></td>
    <td><input name="armor${num}ArmorFire"   type="number"></td>
    <td><input name="armor${num}ArmorWind"   type="number"></td>
    <td><input name="armor${num}ArmorLight"   type="number"></td>
    <td><input name="armor${num}ArmorDark"   type="number"></td>

    <td><input name="armor${num}Initiative" type="text"></td>
    <td><textarea name="armor${num}Note" rows="2"></textarea></td>
  `;
  const target = document.querySelector("#armor-table tbody");
  target.appendChild(tbody, target);
  form.armorNum.value = num;
}
// 削除
function delArmor(){
  let num = Number(form.armorNum.value);
  if(num > 1){
    if( form[`armor${num}Name`].value || form[`armor${num}Stock`].value || form[`armor${num}Exp`].value || 
        form[`armor${num}Initiative`].value || form[`armor${num}Note`].value ||
        form[`armor${num}ArmorCut`].value || form[`armor${num}ArmorPenetration`].value || form[`armor${num}ArmorImpact`].value ||
        form[`armor${num}ArmorGround`].value || form[`armor${num}ArmorWater`].value || form[`armor${num}ArmorFire`].value ||
        form[`armor${num}ArmorWind`].value || form[`armor${num}ArmorLight`].value || form[`armor${num}ArmorDark`].value
        ){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#armor-table tbody tr:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.armorNum.value = num;
    calcItem();
  }
}
// ソート
let armorSortable = Sortable.create(document.querySelector('#armor-table tbody'), {
  group: "armor",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onUpdate: function (evt) {
    const order = armorSortable.toArray();
    let num = 1;
    for(let id of order) {
      if(document.getElementById(id)){
        document.querySelector(`#${id} [name$="Name"]`      ).setAttribute('name',`armor${num}Name`);
        document.querySelector(`#${id} [name$="Stock"]`     ).setAttribute('name',`armor${num}Stock`);
        document.querySelector(`#${id} [name$="Exp"]`       ).setAttribute('name',`armor${num}Exp`);
        document.querySelector(`#${id} [name$="Type"]`      ).setAttribute('name',`armor${num}Type`);
        document.querySelector(`#${id} [name$="Initiative"]`).setAttribute('name',`armor${num}Initiative`);
        document.querySelector(`#${id} [name$="Dodge"]`     ).setAttribute('name',`armor${num}Dodge`);
        document.querySelector(`#${id} [name$="Armor"]`     ).setAttribute('name',`armor${num}Armor`);
        document.querySelector(`#${id} [name$="Note"]`      ).setAttribute('name',`armor${num}Note`);
        num++;
      }
    }
  }
});

// アイテム欄 ----------------------------------------
// 追加
function addItem(){
  let num = Number(form.itemNum.value) + 1;
  let tbody = document.createElement('tr');
  tbody.setAttribute('id',idNumSet('item'));
  tbody.innerHTML = `
    <td><input name="item${num}Name"  type="text"><span class="handle"></span></td>
    <td><input name="item${num}Stock" type="number" oninput="calcItem()"></td>
    <td><input name="item${num}Exp" type="number" oninput="calcItem()"></td>
    <td><input name="item${num}Type"  type="text" list="list-item-type"></td>
    <td><textarea name="item${num}Note" rows="2"></textarea></td>
  `;
  const target = document.querySelector("#item-table tbody");
  target.appendChild(tbody, target);
  
  form.itemNum.value = num;
}
// 削除
function delItem(){
  let num = Number(form.itemNum.value);
  if(num > 1){
    console.log(num, form.itemNum);
    if(form[`item${num}Name`].value || form[`item${num}Stock`].value || form[`item${num}Exp`].value || form[`item${num}Type`].value || form[`item${num}Note`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#item-table tbody tr:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.itemNum.value = num;
    calcItem();
  }
}
// ソート
let itemSortable = Sortable.create(document.querySelector('#item-table tbody'), {
  group: "armor",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onUpdate: function (evt) {
    const order = itemSortable.toArray();
    let num = 1;
    for(let id of order) {
      if(document.getElementById(id)){
        document.querySelector(`#${id} [name$="Name"]`      ).setAttribute('name',`item${num}Name`);
        document.querySelector(`#${id} [name$="Stock"]`     ).setAttribute('name',`item${num}Stock`);
        document.querySelector(`#${id} [name$="Type"]`      ).setAttribute('name',`item${num}Type`);
        document.querySelector(`#${id} [name$="Note"]`      ).setAttribute('name',`item${num}Note`);
        num++;
      }
    }
  }
});

// 履歴欄 ----------------------------------------
// 追加
function addHistory(){
  let num = Number(form.historyNum.value) + 1;
  let tbody = document.createElement('tbody');
  tbody.setAttribute('id',idNumSet('history'));
  tbody.innerHTML = `<tr>
    <td rowspan="2" class="handle"></td>
    <td rowspan="2"><input name="history${num}Date"   type="text"></td>
    <td rowspan="2"><input name="history${num}Title"  type="text"></td>
    <td><input name="history${num}Exp"    type="text" oninput="calcExp()"></td>
    <td><label><input name="history${num}ExpApply" type="checkbox" oninput="calcExp()"><b>適用</b></label></td>
    <td><input name="history${num}Gm"     type="text"></td>
    <td><input name="history${num}Member" type="text"></td>
  </tr>
  <tr><td colspan="5" class="left"><input name="history${num}Note" type="text"></td></tr>`;
  const target = document.querySelector("#history-table tfoot");
  target.parentNode.insertBefore(tbody, target);
  
  form.historyNum.value = num;
}
// 削除
function delHistory(){
  let num = Number(form.historyNum.value);
  if(num > 1){
    if(form[`history${num}Date`].value || form[`history${num}Title`].value || form[`history${num}Exp`].value || form[`history${num}Gm`].value || form[`history${num}Member`].value || form[`history${num}Note`].value){
      if (!confirm(delConfirmText)) return false;
    }
    const target = document.querySelector("#history-table tbody:last-of-type");
    target.parentNode.removeChild(target);
    num--;
    form.historyNum.value = num;
  }
}
// ソート
let historySortable = Sortable.create(document.getElementById('history-table'), {
  group: "history",
  dataIdAttr: 'id',
  animation: 100,
  handle: '.handle',
  filter: 'thead,tfoot',
  ghostClass: 'sortable-ghost',
  onUpdate: function (evt) {
    const order = historySortable.toArray();
    let num = 1;
    for(let id of order) {
      if(document.getElementById(id)){
        document.querySelector(`#${id} [name$="Date"]`  ).setAttribute('name',`history${num}Date`);
        document.querySelector(`#${id} [name$="Title"]` ).setAttribute('name',`history${num}Title`);
        document.querySelector(`#${id} [name$="Exp"]`   ).setAttribute('name',`history${num}Exp`);
        document.querySelector(`#${id} [name$="Gm"]`    ).setAttribute('name',`history${num}Gm`);
        document.querySelector(`#${id} [name$="Member"]`).setAttribute('name',`history${num}Member`);
        document.querySelector(`#${id} [name$="Note"]`  ).setAttribute('name',`history${num}Note`);
        num++;
      }
    }
  }
});
