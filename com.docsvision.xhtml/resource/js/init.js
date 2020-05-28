var current_page = location.hash.substr(1);
var open_local = location.protocol == 'file:' ? true : false;
var origin_location = window.location.href.toString().split('#')[0];



function Search() {
	searchText = document.getElementById('textToSearch').value;

	if (searchText.length < 3) {
		alert("Строка поиска должна содержать минимум 3 символа.");
		return;
	}

	window.open("searchpage.html?s=" + encodeURI(searchText), "contentFrame");
}

function openTree(url) {

	if (window.addEventListener && window.postMessage) {
		menuFrame.postMessage(url, "*");
	} else {
		if (menuFrame.openMenuTree) {

			menuFrame.openMenuTree(url);
		} else {
			document.getElementById('menuFrame').onload = function () {
				menuFrame.openMenuTree(url);
			};
		}
	}

	if (open_local == false) {
		document.getElementById('currentLink').innerHTML = origin_location + "#" + url;
	}
}

function SelectLink() {
	var doc = document,
		text = doc.getElementById('currentLink'),
		range, selection;
	if (doc.body.createTextRange) {
		range = document.body.createTextRange();
		range.moveToElementText(text);
		range.select();
	} else if (window.getSelection) {
		selection = window.getSelection();
		range = document.createRange();
		range.selectNodeContents(text);
		selection.removeAllRanges();
		selection.addRange(range);
	}
}

if (window.addEventListener) {
	window.addEventListener("message", openTreeMessage, false);
}

function openTreeMessage(event) {
	openTree(event.data);
}

window.onload = function () {
	if (open_local == false && location.hash) {
		window.open(current_page, "contentFrame");
	}
};