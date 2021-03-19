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
        xhr.open('POST', `./?id=${id}&mode=img-delete&check1=${check1}&check2=${check2}&check3=${check3}`, true);
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
    },
    (err)=>{
        console.error(err);
    });
}

if(getQueries().player) {
    document.getElementById(`goNext`).href = document.getElementById(`goNext`).href + getQueries().player;
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
    const deleteTargets = ids.map((id, i)=>{
        id.check = checkes[0][i] && checkes[1][i];
        id.comment = comments[i];
        return id;
    }).filter((id, i)=>{
        return id.check && id.comment;
    });
    Promise.all(deleteTargets.map((target)=>{
        return deleteImagePicture(target.id, target.check, target.check, target.comment);
    })).then((resolve)=>{
        console.log(resolve);
    }, (err)=>{
        console.error(err);
    });
});
