var open_menuItem = new Array();
var current_a_url;

function getMainParent(item) {
	if(item == null) return;
	if (item == null || item.length == 0) return null;
	var main_level = item.getAttribute('level');
	if (main_level == 0) return null;
	do {
		item = item.previousElementSibling;
		current_level = item.getAttribute('level');
	} while (current_level >= main_level)
	return item;
}

function getMainChilds(item) {
	if(item == null) return;
	
	var main_level = item.getAttribute('level');
	var child_level = parseInt(main_level) + 1;
	var childs = new Array();
	do {
		item = item.nextElementSibling;
		if(item == null) return childs;
		
		item_level = item.getAttribute('level');
		if (item_level == child_level) childs.push(item);
	} while (item_level > main_level)
	return childs;
}

function openChilds(item, openItemArray) {
	if(item == null) return;
	
	var childs = getMainChilds(item);
	for (i = 0; i < childs.length; i++) {
		var child = childs[i];
		openItemArray.push(child);
	}
}

function openTree(obj) {
	if(obj == null) return;
	var temp = new Array();

	/* временно */
	divs = document.getElementsByTagName('div');

for (var i = 0; i < divs.length; i++) {
    divs[i].className = divs[i].className.replace(/\bisactive\b/,'').replace(/\bisopen\b/,'');
}

	obj.className += ' isactive ';

	do {
		openChilds(obj, temp);
		obj.className +=' isopen ';
	} while ((obj = getMainParent(obj)) != null)

	for (var i = 0; i < temp.length; i++) {
		for (var j = 0; j < open_menuItem.length; j++) {
			if (open_menuItem[j] != null && open_menuItem[j].getAttribute("id") == temp[i].getAttribute("id")) {
				open_menuItem[j] = null;
			}
		}
		if (hasClass(temp[i],'isshow') == false) temp[i].className += ' isshow ';
	}

	while (open_menuItem.length != 0) {
		var item = open_menuItem.pop();
		if (item != null) item.className = item.className.replace(/\bisshow\b/,'');
	}
	open_menuItem = temp;
}

function openMenuTree(url) {
	if (current_a_url == url) return;
	else current_a_url = url;
	var object = document.querySelector('a[href="' + url + '"]');
	if (!object) return;
	openTree(object.parentElement);
	object.scrollIntoView();
}

function hasClass(element, cls) {
    return (' ' + element.className + ' ').indexOf(' ' + cls + ' ') > -1;
}

window.onload = function(){
	
	var elements = document.getElementsByTagName('a');
		for(var i = 0, len = elements.length; i < len; i++) {
			elements[i].onclick = function () {
				current_a_url = this.getAttribute('href');
				openTree(this.parentElement);
			}
		}
};

if(window.addEventListener)
{
	window.addEventListener("message", openTreeMessage, false);
}

function openTreeMessage(event) {
	openMenuTree(event.data);
}