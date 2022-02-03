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
        grow: 0
    }, {
        regulation: '3-4',
        experience: 3000 + 2500,
        money: 2500,
        honor: 30,
        abyssShard: 1,
        grow: 2
    }, {
        regulation: '4-5',
        experience: 3000 + 7000,
        money: 6000,
        honor: 80,
        abyssShard: 2,
        grow: 5
    }, {
        regulation: '5-6',
        experience: 3000 + 13000,
        money: 14000,
        honor: 150,
        abyssShard: 3,
        grow: 9
    }, {
        regulation: '6-7',
        experience: 3000 + 20000,
        money: 24000,
        honor: 250,
        abyssShard: 5,
        grow: 13
    }, {
        regulation: '7-8',
        experience: 3000 + 27000,
        money: 36000,
        honor: 350,
        abyssShard: 7,
        grow: 17
    }, {
        regulation: '8-9',
        experience: 3000 + 37000,
        money: 54000,
        honor: 500,
        abyssShard: 9,
        grow: 22
    }, {
        regulation: '9-10',
        experience: 3000 + 47000,
        money: 80000,
        honor: 700,
        abyssShard: 12,
        grow: 28
    }, {
        regulation: '10-11',
        experience: 3000 + 62000,
        money: 120000,
        honor: 900,
        abyssShard: 15,
        grow: 34
    }, {
        regulation: '11-12',
        experience: 3000 + 82000,
        money: 160000,
        honor: 1300,
        abyssShard: 21,
        grow: 44
    }, {
        regulation: '12-13',
        experience: 3000 + 102000,
        money: 210000,
        honor: 1700,
        abyssShard: 30,
        grow: 54
    }, {
        regulation: '13-14',
        experience: 3000 + 132000,
        money: 270000,
        honor: 2200,
        abyssShard: 39,
        grow: 65
    }, {
        regulation: '14-15',
        experience: 3000 + 162000,
        money: 350000,
        honor: 2800,
        abyssShard: 48,
        grow: 77
    }, {
        regulation: '15A',
        experience: 3000 + 197000,
        money: 450000,
        honor: 3500,
        abyssShard: 57,
        grow: 90
    }, {
        regulation: '15B',
        experience: 3000 + 217000,
        money: 500000,
        honor: 4000,
        abyssShard: 66,
        grow: 100
    }, {
        regulation: '15C',
        experience: 3000 + 247000,
        money: 550000,
        honor: 4500,
        abyssShard: 75,
        grow: 110
    }
];

io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.CommonItems = [
    {
        name: '',
        content: '',
        cost: ''
    }, {
        name: '冒険者セット',
        content: '背負い袋\n水袋\n毛布\nたいまつ6本\n火口箱\nロープ10m\nナイフ',
        cost: '100'
    }, {
        name: '着替えセット',
        content: '着替え7日分',
        cost: '10'
    }, {
        name: '保存食1週間分',
        content: '保存食21食分',
        cost: '50'
    }
];

io.github.shunshun94.trpg.ytsheet.QuickInsertion.applyInitialValue = (e) => {
    e.preventDefault();
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-initialValueSelector';
    const regulationNumber = Number(document.getElementById(`${id}-select`).value);
    const regulation = io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.InitialValues[regulationNumber];
    [
        {name: 'history0Exp', column: 'experience'},
        {name: 'history0Honor', column: 'honor'},
        {name: 'history0Money', column: 'money'},
        {name: 'sttPreGrowA', column: 'grow'},
    ].forEach((d)=>{
        document.getElementsByName(d.name)[0].value = regulation[d.column];
        const event = document.createEvent("HTMLEvents");
        event.initEvent('input', true, true);
        document.getElementsByName(d.name)[0].dispatchEvent(event);
    });
    const currentTexts = document.getElementsByName('items')[0].value.split('\n').filter((d)=>{
        return ! d.startsWith('アビスシャード');
    }).join('\n');
    if(regulation.abyssShard) {
        document.getElementsByName('items')[0].value = `アビスシャード${regulation.abyssShard}個\n${currentTexts}`;
    } else {
        document.getElementsByName('items')[0].value = currentTexts;
    }
};

io.github.shunshun94.trpg.ytsheet.QuickInsertion.generateInitialValueSelector = () => {
    const id = 'io-github-shunshun94-trpg-ytsheet-quickInsertion-initialValueSelector';
    const baseDiv = document.createElement('div');
    baseDiv.id = id;
    baseDiv.style = 'width:200px;';

    const selector = document.createElement('select');
    selector.id = `${id}-select`;
    io.github.shunshun94.trpg.ytsheet.QuickInsertion.CONSTS.InitialValues.forEach((d, i)=>{
        const option = document.createElement('option');
        option.value = i;
        option.textContent = d.regulation;
        selector.appendChild(option);
    });
    selector.style = 'display:block;';
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
}

