var io = io || {};
io.github = io.github || {};
io.github.shunshun94 = io.github.shunshun94 || {};
io.github.shunshun94.trpg = io.github.shunshun94.trpg || {};
io.github.shunshun94.trpg.ytsheet = io.github.shunshun94.trpg.ytsheet || {};
io.github.shunshun94.trpg.ytsheet.QuickInsertion = io.github.shunshun94.trpg.ytsheet.QuickInsertion || {};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS = io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS || {};
io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.InitialValues = [
    {
        regulation: '初期作成',
        experience: 3000,
        money: 1200,
        honor: 0,
        abyssShard: 0,
        grow: [0, 0, 0, 0, 0, 0]
    }, {
        regulation: '3-4',
        experience: 3000 + 2500,
        money: 2500,
        honor: 30,
        abyssShard: 1,
        grow: [1, 1, 0, 0, 0, 0]
    }, {
        regulation: '4-5',
        experience: 3000 + 7000,
        money: 6000,
        honor: 80,
        abyssShard: 2,
        grow: [1, 1, 1, 1, 1, 0]
    }, {
        regulation: '5-6',
        experience: 3000 + 13000,
        money: 14000,
        honor: 150,
        abyssShard: 3,
        grow: [2, 2, 2, 2, 1, 0]
    }, {
        regulation: '6-7（成長集中）',
        experience: 3000 + 20000,
        money: 24000,
        honor: 250,
        abyssShard: 5,
        grow: [4, 3, 3, 2, 1, 0]
    }, {
        regulation: '6-7（成長分散）',
        experience: 3000 + 20000,
        money: 24000,
        honor: 250,
        abyssShard: 5,
        grow: [3, 3, 2, 2, 2, 1]
    }, {
        regulation: '7-8（成長集中）',
        experience: 3000 + 27000,
        money: 36000,
        honor: 350,
        abyssShard: 7,
        grow: [5, 4, 3, 3, 2, 0]
    }, {
        regulation: '7-8（成長分散）',
        experience: 3000 + 27000,
        money: 36000,
        honor: 350,
        abyssShard: 7,
        grow: [4, 3, 3, 3, 2, 2]
    }, {
        regulation: '8-9（成長集中）',
        experience: 3000 + 37000,
        money: 54000,
        honor: 500,
        abyssShard: 9,
        grow: [6, 5, 4, 4, 2, 1]
    }, {
        regulation: '8-9（成長分散）',
        experience: 3000 + 37000,
        money: 54000,
        honor: 500,
        abyssShard: 9,
        grow: [5, 4, 4, 4, 3, 2]
    }, {
        regulation: '9-10（成長集中）',
        experience: 3000 + 47000,
        money: 80000,
        honor: 700,
        abyssShard: 12,
        grow: [8, 6, 5, 5, 3, 1]
    }, {
        regulation: '9-10（成長分散）',
        experience: 3000 + 47000,
        money: 80000,
        honor: 700,
        abyssShard: 12,
        grow: [6, 5, 5, 5, 4, 3]
    }, {
        regulation: '10-11（成長集中）',
        experience: 3000 + 62000,
        money: 120000,
        honor: 900,
        abyssShard: 15,
        grow: [9, 7, 7, 6, 4, 1]
    }, {
        regulation: '10-11（成長分散）',
        experience: 3000 + 62000,
        money: 120000,
        honor: 900,
        abyssShard: 15,
        grow: [7, 6, 6, 6, 5, 4]
    }, {
        regulation: '11-12（成長集中）',
        experience: 3000 + 82000,
        money: 160000,
        honor: 1300,
        abyssShard: 21,
        grow: [12, 10, 9, 7, 5, 1]
    }, {
        regulation: '11-12（成長分散）',
        experience: 3000 + 82000,
        money: 160000,
        honor: 1300,
        abyssShard: 21,
        grow: [10, 9, 7, 7, 6, 5]
    }, {
        regulation: '12-13（成長集中）',
        experience: 3000 + 102000,
        money: 210000,
        honor: 1700,
        abyssShard: 30,
        grow: [15, 12, 10, 9, 6, 2]
    }, {
        regulation: '12-13（成長分散）',
        experience: 3000 + 102000,
        money: 210000,
        honor: 1700,
        abyssShard: 30,
        grow: [12, 10, 9, 9, 8, 6]
    }, {
        regulation: '13-14（成長集中）',
        experience: 3000 + 132000,
        money: 270000,
        honor: 2200,
        abyssShard: 39,
        grow: [18, 14, 13, 11, 7, 2]
    }, {
        regulation: '13-14（成長分散）',
        experience: 3000 + 132000,
        money: 270000,
        honor: 2200,
        abyssShard: 39,
        grow: [14, 13, 11, 11, 9, 7]
    }, {
        regulation: '14-15（成長集中）',
        experience: 3000 + 162000,
        money: 350000,
        honor: 2800,
        abyssShard: 48,
        grow: [21, 17, 15, 13, 9, 2]
    }, {
        regulation: '14-15（成長分散）',
        experience: 3000 + 162000,
        money: 350000,
        honor: 2800,
        abyssShard: 48,
        grow: [17, 15, 13, 13, 11, 8]
    }, {
        regulation: '15A（成長集中）',
        experience: 3000 + 197000,
        money: 450000,
        honor: 3500,
        abyssShard: 57,
        grow: [25, 20, 17, 15, 10, 3]
    }, {
        regulation: '15A（成長分散）',
        experience: 3000 + 197000,
        money: 450000,
        honor: 3500,
        abyssShard: 57,
        grow: [20, 17, 15, 15, 13, 10]
    }, {
        regulation: '15B（成長集中）',
        experience: 3000 + 217000,
        money: 500000,
        honor: 4000,
        abyssShard: 66,
        grow: [28, 22, 19, 17, 11, 3]
    }, {
        regulation: '15B（成長分散）',
        experience: 3000 + 217000,
        money: 500000,
        honor: 4000,
        abyssShard: 66,
        grow: [22, 19, 17, 17, 14, 11]
    }, {
        regulation: '15C（成長集中）',
        experience: 3000 + 247000,
        money: 550000,
        honor: 4500,
        abyssShard: 75,
        grow: [31, 25, 21, 18, 12, 3]
    }, {
        regulation: '15C（成長分散）',
        experience: 3000 + 247000,
        money: 550000,
        honor: 4500,
        abyssShard: 75,
        grow: [25, 22, 18, 18, 15, 12]
    }
];

io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.CommonItems = [
    {
        name: '',
        content: '',
        cost: ''
    }, {
        name: 'アウェイクポーションと保存食と冒険者セット',
        content: '背負い袋\n水袋\n毛布\n火口箱\nナイフ\n\n|ロープ|10m|\n|たいまつ|6本|\n|保存食|7日分|\n|アウェイクポーション|1本|',
        cost: '250'
    }, {
        name: '【冒険でしばしば使うアイテム】',
        cost: ''
    }, {
        name: '冒険者セット',
        content: '背負い袋\n水袋\n毛布\n火口箱\nナイフ\n\n|ロープ|10m|\n|たいまつ|6本|',
        cost: '100'
    }, {
        name: '着替えセット',
        content: '|着替え|7日分|',
        cost: '10'
    }, {
        name: '保存食1週間分',
        content: '|保存食|7日分|',
        cost: '50'
    }, {
        name: 'ランタンと油',
        content: 'ランタン\n油',
        cost: '60'
    }, {
        name: 'ロープ10m',
        note: '1m毎に +1 / 100mなら100G',
        cost: '10'
    }, {
        name: 'テント(4人用)',
        note: '1人分サイズを大きくする毎に+50',
        cost: '250'
    }, {
        name: '【初期作成でよく買う技能用アイテム】',
        cost: ''
    }, {
        name: '救命草3本',
        content: '|救命草|3本|',
        cost: '30*3'
    }, {
        name: '魔香草1本',
        content: '|魔香草|1本|',
        cost: '100*1'
    }, {
        name: 'アウェイクポーション1本',
        content: '|アウェイクポーション|1本|',
        cost: '100*1'
    }, {
        name: '3点魔晶石1つ',
        content: '|魔晶石（3点）|1つ|',
        cost: '300*1'
    }, {
        name: '5点魔晶石1つ',
        content: '|魔晶石（5点）|1つ|',
        cost: '500*1'
    }, {
        name: 'マギスフィア（小）',
        cost: '200'
    }, {
        name: 'ガンベルト',
        cost: '20'
    }, {
        name: '銃弾（12発）',
        content: '|銃弾|12発|',
        cost: '50'
    }, {
        name: '活性弾（12発）',
        content: '|活性弾|12発|',
        cost: '160'
    }, {
        name: '聖印',
        cost: '100'
    }, {
        name: '6種類の宝石（レベル1～2）と宝石ケース',
        cost: '100*50*6'
    }, {
        name: 'アルケミーキット',
        cost: '200'
    }, {
        name: 'スカウト用ツール',
        cost: '100'
    }, {
        name: '【フレーバーアイテム】',
        content: '',
        cost: ''
    }, {
        name: '調理道具セット',
        cost: '50'
    }, {
        name: 'ワイン',
        note: '市場の最低価格',
        cost: '20'
    }, {
        name: '羽根ペンとインク',
        content: '羽根ペン\nインク',
        cost: '5'
    }, {
        name: '羊皮紙5枚',
        content: '|羊皮紙|5枚|',
        cost: '5'
    }
];

io.github.shunshun94.trpg.ytsheet.QuickInsertion.appendCommonItem = (e) => {
    e.preventDefault();
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-CommonItemSelector';
    const itemNumber = Number(document.getElementById(`${id}-select`).value);
    const item = io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.CommonItems[itemNumber];
    if(item.cost === '') {return;}
    document.getElementsByName('items')[0].value += `\n${item.content || item.name}`;
    document.getElementsByName('items')[0].value = document.getElementsByName('items')[0].value.trim();
    document.getElementsByName('cashbook')[0].value += `\n${item.name}::-${item.cost}`;
    document.getElementsByName('cashbook')[0].value = document.getElementsByName('cashbook')[0].value.trim();
    const event = document.createEvent("HTMLEvents");
    event.initEvent('input', true, true);
    document.getElementsByName('cashbook')[0].dispatchEvent(event);
};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.generateCommonItemSelector = () => {
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-CommonItemSelector';
    const baseDiv = document.createElement('div');
    baseDiv.id = id;

    const selector = document.createElement('select');
    selector.id = `${id}-select`;
    selector.style = 'max-width:200px;';
    io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.CommonItems.forEach((d, i)=>{
        const option = document.createElement('option');
        option.value = i;
        option.textContent = d.name;
        selector.appendChild(option);
    });
    baseDiv.appendChild(selector);

    const exec = document.createElement('button');
    exec.id = `${id}-exec`;
    exec.textContent = '購入';
    exec.onclick = io.github.shunshun94.trpg.ytsheet.QuickInsertion.appendCommonItem;
    baseDiv.appendChild(exec);

    return baseDiv;
};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.inputData = (domName, value) => {
    document.getElementsByName(domName)[0].value = value;
    const event = document.createEvent("HTMLEvents");
    event.initEvent('input', true, true);
    document.getElementsByName(domName)[0].dispatchEvent(event);
};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.applyInitialValue = (e) => {
    e.preventDefault();
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-initialValueSelector';
    const regulationNumber = Number(document.getElementById(`${id}-select`).value);
    const regulation = io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.InitialValues[regulationNumber];
    [
        {name: 'history0Exp', column: 'experience'},
        {name: 'history0Honor', column: 'honor'},
        {name: 'history0Money', column: 'money'}
    ].forEach((d)=>{
        io.github.shunshun94.trpg.ytsheet.QuickInsertion.inputData(d.name, regulation[d.column]);
    });
    ['sttPreGrowA', 'sttPreGrowB', 'sttPreGrowC',
     'sttPreGrowD', 'sttPreGrowE', 'sttPreGrowF'].forEach((d, i)=>{
        io.github.shunshun94.trpg.ytsheet.QuickInsertion.inputData(d, regulation.grow[i]);
     });
    const currentTexts = document.getElementsByName('items')[0].value.split('\n').filter((d)=>{
        return ! d.includes('アビスシャード');
    }).join('\n');
    if(regulation.abyssShard) {
        document.getElementsByName('items')[0].value = `${currentTexts}\n|アビスシャード|${regulation.abyssShard}個|`.trim();
    } else {
        document.getElementsByName('items')[0].value = currentTexts.trim();
    }
};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.generateInitialValueSelector = () => {
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-initialValueSelector';
    const baseDiv = document.createElement('div');
    baseDiv.id = id;

    const selector = document.createElement('select');
    selector.id = `${id}-select`;
    selector.style = 'max-width:200px;';
    io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.InitialValues.forEach((d, i)=>{
        const option = document.createElement('option');
        option.value = i;
        option.textContent = d.regulation;
        selector.appendChild(option);
    });
    baseDiv.appendChild(selector);

    const exec = document.createElement('button');
    exec.id = `${id}-exec`;
    exec.textContent = 'レギュレーション反映';
    exec.onclick = io.github.shunshun94.trpg.ytsheet.QuickInsertion.applyInitialValue;
    baseDiv.appendChild(exec);

    return baseDiv;
};

if(location.search.includes('mode=blanksheet')) {
    document.getElementById('regulation').appendChild(io.github.shunshun94.trpg.ytsheet.QuickInsertion.generateInitialValueSelector());
    document.getElementsByName('money')[0].value = 'auto';
    document.getElementsByName('deposit')[0].value = 'auto';
}
document.getElementById('items').getElementsByTagName('h2')[0].appendChild(io.github.shunshun94.trpg.ytsheet.QuickInsertion.generateCommonItemSelector())
