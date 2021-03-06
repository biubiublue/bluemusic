  var base64hash = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

function gobtoa (s) {
    if (/([^\u0000-\u00ff])/.test(s)) {
        throw new Error('INVALID_CHARACTER_ERR');
    }
    var i = 0,
    prev,
    ascii,
    mod,
    result = [];
    
    
    while (i < s.length) {
        ascii = s.charCodeAt(i);
        mod = i % 3;
        
        
        switch(mod) {
                // 第一个6位只需要让8位二进制右移两位
            case 0:
                result.push(base64hash.charAt(ascii >> 2));
                break;
                //第二个6位 = 第一个8位的后两位 + 第二个8位的前4位
            case 1:
                result.push(base64hash.charAt((prev & 3) << 4 | (ascii >> 4)));
                break;
                //第三个6位 = 第二个8位的后4位 + 第三个8位的前2位
                //第4个6位 = 第三个8位的后6位
            case 2:
                result.push(base64hash.charAt((prev & 0x0f) << 2 | (ascii >> 6)));
                result.push(base64hash.charAt(ascii & 0x3f));
                break;
        }
        
        
        prev = ascii;
        i ++;
    }
    // 循环结束后看mod, 为0 证明需补3个6位，第一个为最后一个8位的最后两位后面补4个0。另外两个6位对应的是异常的“=”；
    // mod为1，证明还需补两个6位，一个是最后一个8位的后4位补两个0，另一个对应异常的“=”
    if(mod == 0) {
        result.push(base64hash.charAt((prev & 3) << 4));
        result.push('==');
    } else if (mod == 1) {
        result.push(base64hash.charAt((prev & 0x0f) << 2));
        result.push('=');
    }
    
    
    return result.join('');
}


function _aes_encrypt(text, sec_key) {
    
    
    var pad = 16 - text.length % 16;
    for (var i=0; i<pad; i++) {
        text = text + String.fromCharCode(pad);
    }
    
    var key = aesjs.util.convertStringToBytes(sec_key);

    // The initialization vector, which must be 16 bytes
    var iv = aesjs.util.convertStringToBytes("0102030405060708");
    
    var textBytes = aesjs.util.convertStringToBytes(text);
    
    var aesCbc = new aesjs.ModeOfOperation.cbc(key, iv);
    var cipherArray = [];
    while(textBytes.length != 0) {
        var block = aesCbc.encrypt(textBytes.slice(0, 16));
        Array.prototype.push.apply(cipherArray,block);
        textBytes = textBytes.slice(16);
    }
    var ciphertext = '';
    
    for (var i=0; i<cipherArray.length; i++) {
        ciphertext = ciphertext + String.fromCharCode(cipherArray[i]);
    }
    //return ciphertext;
    ciphertext = gobtoa(ciphertext)
    return ciphertext;
    
}

function hexify(text) {
    return text.split('').map(function(x){return x.charCodeAt(0).toString(16)}).join('');
}

function zfill(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}


function expmod( base, exp, mymod ) {
    if ( equalsInt(exp, 0) == 1) return int2bigInt(1,10);
    if ( equalsInt(mod(exp, int2bigInt(2,10) ), 0) ) {
        var newexp = dup(exp);
        rightShift_(newexp,1);
        var result = powMod(expmod( base, newexp, mymod), [2,0], mymod);
        return result;
    }
    else {
        var result = mod(mult(expmod( base, sub(exp, int2bigInt(1,10)), mymod), base), mymod);
        return result;
    }
}

function _rsa_encrypt(text, pubKey, modulus) {
    text = text.split('').reverse().join('');

    var base = str2bigInt(hexify(text), 16);
    var exp = str2bigInt(pubKey, 16);
    var mod = str2bigInt(modulus, 16);
    var bigNumber = expmod(base, exp, mod);
    var rs = bigInt2str(bigNumber, 16);
    return zfill(rs, 256).toLowerCase();
    
    //return text;
}

function _create_secret_key(size) {
    var result = [];
    var choice = '012345679abcdef'.split('');
    for (var i=0; i<size; i++) {
        var index = Math.floor(Math.random() * choice.length);
        result.push(choice[index]);
    }
    return result.join('');
}

function encrypted_request(text) {
    var modulus = '00e0b509f6259df8642dbc35662901477df22677ec152b5ff68ace615bb7b72' +
    '5152b3ab17a876aea8a5aa76d2e417629ec4ee341f56135fccf695280104e0312ecbd' +
    'a92557c93870114af6c9d05c4f7f0c3685b7a46bee255932575cce10b424d813cfe48' +
    '75d3e82047b97ddef52741d546b8e289dc6935b3ece0462db0a22b8e7';
    var nonce = '0CoJUm6Qyw8W8jud';
    var pubKey = '010001';
    text = JSON.stringify(text);
    var sec_key = _create_secret_key(16);
    var enc_text = _aes_encrypt(_aes_encrypt(text, nonce), sec_key);
    var enc_sec_key = _rsa_encrypt(sec_key, pubKey, modulus);
    var data = {
        'params': enc_text,
        'encSecKey': enc_sec_key
    };
    
    return data;
}

function go_request(song_id) {
    var d = {
        "ids": [song_id],
        "br": 320000,
        "csrf_token": ""
    }
    var data = encrypted_request(d);
    return data;
}

function go_requestpldetail(pl_id) {
    
    var d = {
    "id": pl_id,
    "offset": 0,
    "total": true,
    "limit": 1000,
    "n": 1000,
    "csrf_token": ""
    };
    
    
    var data = encrypted_request(d);
    return data;
}

function go_requestsonglyric(song_id) {
    
    var d = {
        "id": song_id,
        "lv": -1,
        "tv": -1,
        "csrf_token": ""
    }
    
    var data = encrypted_request(d);
    return data;
}
