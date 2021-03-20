const getJsonData = (id) => {
    return new Promise((resolve, reject)=>{
        let xhr = new XMLHttpRequest();
        xhr.open('GET', `./?id=${id}&mode=json`, true);
        xhr.responseType = "json";
        xhr.onload = (e) => {
            resolve(e.currentTarget.response);
        };
        xhr.onerror = () => reject('error');
        xhr.onabort = () => reject('abort');
        xhr.ontimeout = () => reject('timeout');
        xhr.send();
    });
};

const deleteImagePicture = (id, check1='', check2='', check3='') => {
    return new Promise((resolve, reject)=>{
        let xhr = new XMLHttpRequest();
        xhr.open('GET', `./?id=${id}&mode=img-delete&check1=${check1}&check2=${check2}&check3=${check3}&pass=1`, true);
        xhr.onload = (e) => {
            resolve(`succeeded to delete ${id}`);
        };
        xhr.onerror = () => reject(`failed to delete ${id}`);
        xhr.onabort = () => reject(`failed to delete ${id}`);
        xhr.ontimeout = () => reject(`failed to delete ${id}`);
        xhr.send();
    });
};

const getQueries = (opt_query) => {
	var query = opt_query ? '?' + opt_query : location.search;
	var params = (query.slice(1)).split('&');
	var paramLength = params.length;
	var result = {};
	for(var i = 0; i < paramLength; i++) {
		var pair = params[i].split('=');
		result[pair[0]] = pair[1];
	}
	return result;
};

const getFromInfo = (json) => {
    if( json.imageCopyrightURL && json.imageCopyright ) {
        return `<a href="${json.imageCopyrightURL}">${json.imageCopyright}</a>`;
    }
    if( json.imageCopyrightURL ) {
        return `<a href="${json.imageCopyrightURL}">${json.imageCopyrightURL}</a>`;
    }
    if( json.imageCopyright ) {
        return json.imageCopyright;
    }
    return '<span style="color:red;">出典情報なし</span>';
};

const trs = document.getElementsByTagName('tr');
const trsLength = trs.length;

for(let i = 0; i < trsLength; i++) {
    const target = trs[i];
    getJsonData(target.id).then((json)=>{
        document.getElementById(`image_${target.id}`).src = json.imageURL;
        document.getElementById(`from_${target.id}`).innerHTML = getFromInfo(json);
        document.getElementById(`name_${target.id}`).textContent = json.characterName;
        document.getElementById(`user_${target.id}`).textContent = json.playerName;
        document.getElementById(`user_${target.id}`).setAttribute('href', `./confirmPictures.cgi?player=${json.playerName}`);
    },
    (err)=>{
        console.error(err);
    });
}

if(getQueries().player) {
    document.getElementById(`goNext`).setAttribute('href', `${document.getElementById('goNext').href}${getQueries().player}`);
}

const updateCheck = (e)=>{
    const characterId = e.target.id.replace(/check\d_/, '');
    if(
        document.getElementById(`check1_${characterId}`).checked &&
        document.getElementById(`check2_${characterId}`).checked &&
        document.getElementById(`check3_${characterId}`).value
    ) {
        document.getElementById(`${characterId}`).style.backgroundColor = 'peachpuff';
    } else {
        document.getElementById(`${characterId}`).style.backgroundColor = 'white';
    }
};

const download = (title, url) => {
    const a = document.createElement("a");
    document.body.appendChild(a);
    a.download = title;
    a.href = url;
    a.click();
    a.remove();
    URL.revokeObjectURL(url);
};

const convertDateFormat = (date) => {
    return `${date.getFullYear()}-${String(date.getMonth()).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}:${String(date.getSeconds()).padStart(2, '0')}`;
};

Array.from(document.getElementsByClassName('check1')).forEach((elem)=>{elem.addEventListener('input', updateCheck);});
Array.from(document.getElementsByClassName('check2')).forEach((elem)=>{elem.addEventListener('input', updateCheck);});
Array.from(document.getElementsByClassName('check3')).forEach((elem)=>{elem.addEventListener('input', updateCheck);});

document.getElementById('execDelete').addEventListener('click', (e)=>{
    const ids = Array.from(document.getElementsByTagName('tr')).map((tr)=>{
        return { number: tr.title, id: tr.id };
    });
    const checkes = [
        Array.from(document.getElementsByClassName('check1')).map((d)=>{return d.checked;}),
        Array.from(document.getElementsByClassName('check2')).map((d)=>{return d.checked;})
    ];
    const comments = Array.from(document.getElementsByClassName('check3')).map((d)=>{return d.value;});
    const names = Array.from(document.getElementsByClassName('name')).map((d)=>{return d.innerText;});
    const users = Array.from(document.getElementsByClassName('user')).map((d)=>{return d.innerText;});
    const deleteTargets = ids.map((id, i)=>{
        id.check = checkes[0][i] && checkes[1][i];
        id.comment = comments[i];
        id.name = names[i];
        id.user = users[i];
        return id;
    }).filter((id, i)=>{
        return id.check && id.comment;
    });
    Promise.all(deleteTargets.map((target)=>{
        return deleteImagePicture(target.id, target.check, target.check, target.comment);
    })).then((resolve)=>{
        const date = convertDateFormat(new Date());
        const reportStr = [`# ${date} 画像削除実施報告`].concat(
            deleteTargets.sort((a,b)=>{
                return a.user > b.user;
            }).map((target)=>{
                return [
                    '',
                    `## ${target.id} (${target.number})`,
                    '### キャラクター名',
                    target.name,
                    '### ユーザ名',
                    target.user,
                    '### 事由',
                    target.comment
                ];
            }).flat()
        ).join('\n');
        const textUrl = window.URL.createObjectURL(new Blob([ reportStr ], { "type" : 'text/plain;charset=utf-8;' }));
        download(`${date}_画像削除実施報告.md`, textUrl);
        alert(`${deleteTargets.length}件について削除しました\nキャッシュの削除とハード再読み込み実施してください`);
    }, (err)=>{
        console.error(err);
    });
});
