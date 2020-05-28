var elasticlunr = require('elasticlunr');
require('./lunr.stemmer.support.js')(elasticlunr);
require('./lunr.ru.js')(elasticlunr);
require('./lunr.multi.js')(elasticlunr);


fs = require('fs');
var lzstring = require('./lz-string.js');

var idx = elasticlunr(function () {
    this.use(elasticlunr.multiLanguage('en', 'ru'));

    this.setRef('i');
    this.addField('title');
    this.addField('body');

});

function tgtrimm(str){
            var ars = str.replace(/[^a-zа-яё0-9]/gi,' '); 
            ars = ars.replace(/\s+/g, ' ').trim();
            return ars;
        }

elasticlunr.DocumentStore.prototype.toJSON = function () {

    var ret = {};

    for (i in this.docs) {
        ret[i] = {
            i: this.docs[i].i,
            h: this.docs[i].h,
            t: this.docs[i].t
        };
    }

    return {
        docs: ret,
        docInfo: this.docInfo,
        length: this.length,
        save: this._save
    };
};

fs.readFile('./indexesSource.js', function (err, data) {
    if (err) throw err;

    var raw = JSON.parse(data);

    var topics = raw.map(function (q) {
        body = "";
        prebody = tgtrimm(q.body).split(" ");

        for (i in prebody) {
            current = prebody[i].trim();

            if (!current)
                continue;

            body = body + current + " ";
        }

        title = tgtrimm(q.title);

        return {
            i: q.id,
            h: q.href,
            t: q.title,
            title: title,
            body: body
        };
    });

    topics.forEach(function (question) {
        idx.addDoc(question);
    });

    data = JSON.stringify(idx);
    fs.writeFile('./indexes.js', "indexDoc='" + lzstring.compressToEncodedURIComponent(data) + "'", function (err) {
        if (err) throw err;
        console.log('done');
    });
});