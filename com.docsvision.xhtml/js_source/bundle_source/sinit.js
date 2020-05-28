elasticlunr.multiLanguage('en', 'ru');
elasticlunr.Configuration = function (config, fields) {};

elasticlunr.Configuration.prototype.get = function () {
	return {
		title: {
			boost: 10,
			bool: "AND",
			expand: false
		},
		body: {
			boost: 5,
			bool: "AND",
			expand: false
		}
	};
};

var sourceIndexDoc = LZString.decompressFromEncodedURIComponent(indexDoc);
indexData = elasticlunr.Index.load(JSON.parse(sourceIndexDoc))

function tgtrimm(str){
	var ars = str.replace(/[^a-zа-яё0-9]/gi,' '); 
	ars = ars.replace(/\s+/g, ' ').trim();
	return ars;
}

function GetSearchResults()
{
	var params = new URLSearchParams(location.search);
	var search = decodeURI(params.get("s"));

	var searchResult = indexData.search(tgtrimm(search));

	var result = '';

	if (searchResult.length > 0) {
		for (var i = 0; i < searchResult.length; i++) {
			currentDocument = indexData.documentStore.getDoc(searchResult[i].ref);
			result = result + '<div class="search-result"><a href="' + currentDocument.h + '">' + currentDocument.t + '</a></div>';
		}
		document.write(result);

	} else {
		document.write('<div class="search-nofound">К сожалению, не удалось найти запрашиваемую Вами информацию.</div><div class="search-nofound-info">Попробуйте изменить или сократить запрос.</div>');
	}
}

GetSearchResults();