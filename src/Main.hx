package;

import js.Browser.*;
import svg.*;

using StringTools;

class Main {
	var count:Int;
	var hash:String;
	var ccTypeArray:Array<Class<Dynamic>> = [
		//
		art.CCHanddrawn, //
		art.CCGraffiti, //
		art.CCDrips, //
		art.CCSpatter, //
		art.CCSpatten, //
		art.CCCurve, //
	];

	public function new() {
		trace('START :: main');
		document.addEventListener("DOMContentLoaded", function(event) {
			console.log('${model.constants.App.NAME} Dom ready :: build: ${model.constants.App.getBuildDate()}');
			// var cc = new art.CC100();
			// var cc = new svg.Calendar();
			setupArt();
			setupNav();
			setupPull();
		});
	}

	function setupArt() {
		// get hash from url
		getHash();

		var clazz = Type.resolveClass('art.${hash}');
		if (clazz == null) {
			// make sure if it's not in the list, show the latest Sketch
			clazz = ccTypeArray[ccTypeArray.length - 1];
		}
		count = ccTypeArray.indexOf(clazz);
		var cc = Type.createInstance(clazz, []);

		changeHash();
	}

	function setupNav() {
		// make sure the browser updates after changing the hash
		window.addEventListener("hashchange", function() {
			location.reload();
		}, false);

		// use cursor key lef and right to switch sketches
		window.addEventListener(KEY_DOWN, function(e:js.html.KeyboardEvent) {
			switch (e.key) {
				case 'ArrowRight':
					count++;
				case 'ArrowLeft':
					count--;
				case 'ArrowUp':
					count = ccTypeArray.length - 1;
				case 'ArrowDown':
					count = 0;
					// default : trace ("case '"+e.key+"': trace ('"+e.key+"');");
			}
			changeHash();
		}, false);
	}

	/**
		<select id="cars">
			<option value="volvo">Volvo</option>
			<option value="saab">Saab</option>
			<option value="mercedes">Mercedes</option>
			<option value="audi">Audi</option>
		</select>
	 */
	function setupPull() {
		var div = document.createDivElement();
		div.setAttribute('style', 'position: fixed;display: block;top: 0;');
		div.id = 'ccsketcher';

		var select = document.createSelectElement();
		select.id = 'art';
		for (i in 0...ccTypeArray.length) {
			var _ccTypeArray = ccTypeArray[i];
			var name = Type.getClassName(_ccTypeArray);

			var option = document.createOptionElement();
			option.value = '${name}';
			option.text = '${name}';
			if (name.indexOf(getHash()) != -1)
				option.selected = true;
			select.appendChild(option);
		}

		div.appendChild(select);
		document.body.appendChild(div);

		select.onchange = function(e) {
			var index = select.selectedIndex;
			var options = select.options;
			// console.log(untyped options[index].index);
			// console.log(untyped options[index].text);
			// console.log(Type.getClassName(ccTypeArray[index]));
			changeHash(index);
			setupArt();
		}
	}

	function changeHash(?i:Int) {
		if (i != null)
			count = i;
		location.hash = Type.getClassName(ccTypeArray[count]).replace('art.', '');
	}

	function getHash():String {
		// get hash from url
		hash = js.Browser.location.hash;
		hash = hash.replace('#', '');
		return hash;
	}

	static public function main() {
		var app = new Main();
	}
}
