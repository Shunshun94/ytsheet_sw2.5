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
        console.log(err);
    });
}
