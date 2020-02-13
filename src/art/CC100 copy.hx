package art;

import js.Browser.*;
import js.html.*;

class CC100 extends SketcherBase {
	var shapeArray:Array<Circle> = [];
	var grid:GridUtil;
	// sizes
	var _radius = 150;
	var _cellsize = 150;
	// colors
	var _color0:RGB = null;
	var _color1:RGB = null;
	var _color2:RGB = null;
	var _color3:RGB = null;
	var _color4:RGB = null;
	// settings
	var panel1:QuickSettings;
	// animate
	var dot:Circle;

	// dat
	var message = 'dat.gui';
	var speed = 0.8;
	var displayOutline = false;
	var noiseStrength = 0.8;
	var growthSpeed = 0.8;
	var maxSize = 0.8;
	var explode = function() {
		trace('booom');
	};

	var color0 = "#ffae23"; // CSS string
	var color1 = [0, 128, 255]; // RGB array
	var color2 = [0, 128, 255, 0.3]; // RGB with alpha
	var color3 = {h: 350, s: 0.9, v: 0.3}; // Hue, saturation, value

	///
	var fontFamly = 'Oswald:200,300,400,500,600,700';

	var ongoingTouches = [];

	public function new() {
		// use debug?
		this.isDebug = true;

		super();
		// embed font files and then init
		EmbedUtil.embedGoogleFont(fontFamly, drawShape);
		// init
		// embed dat.GUI and init
		EmbedUtil.datgui(initDatGui2);
		// initDatGui();
		init();
	}

	var el:CanvasElement;
	var ctx:Dynamic;

	function init() {
		el = sketch.canvas;
		ctx = el.getContext2d();
		el.addEventListener("touchstart", handleStart, false);
		el.addEventListener("touchend", handleEnd, false);
		el.addEventListener("touchcancel", handleCancel, false);
		el.addEventListener("touchmove", handleMove, false);
	}

	function handleStart(e:js.html.TouchEvent) {
		e.preventDefault();
		console.log("touchstart.");

		var ctx = el.getContext2d();
		var touches = e.changedTouches;

		for (i in 0...touches.length) {
			var _touches = touches[i];
			trace(_touches);

			console.log("touchstart:" + i + "...");
			ongoingTouches.push(copyTouch(touches[i]));
			var color = colorForTouch(touches[i]);
			ctx.beginPath();
			ctx.arc(touches[i].pageX, touches[i].pageY, 4, 0, 2 * Math.PI, false); // a circle at the start
			ctx.fillStyle = color;
			ctx.fill();
			console.log("touchstart:" + i + ".");
		}
	}

	function handleEnd(evt:js.html.TouchEvent) {
		evt.preventDefault();
		// log("touchend");

		var touches = evt.changedTouches;

		for (i in 0...touches.length) {
			var _touches = touches[i];
			trace(_touches);

			var color = colorForTouch(touches[i]);
			var idx = ongoingTouchIndexById(touches[i].identifier);

			if (idx >= 0) {
				ctx.lineWidth = 4;
				ctx.fillStyle = color;
				ctx.beginPath();
				ctx.moveTo(ongoingTouches[idx].pageX, ongoingTouches[idx].pageY);
				ctx.lineTo(touches[i].pageX, touches[i].pageY);
				ctx.fillRect(touches[i].pageX - 4, touches[i].pageY - 4, 8, 8); // and a square at the end
				ongoingTouches.splice(idx, 1); // remove it; we're done
			} else {
				console.log("can't figure out which touch to end");
			}
		}
	}

	function handleCancel(e:js.html.TouchEvent) {
		e.preventDefault();
		console.log("touchcancel.");
		var touches = e.changedTouches;

		for (i in 0...touches.length) {
			var _touches = touches[i];
			trace(_touches);

			var idx = ongoingTouchIndexById(touches[i].identifier);
			ongoingTouches.splice(idx, 1); // remove it; we're done
		}
	}

	function handleMove(evt:js.html.TouchEvent) {
		evt.preventDefault();

		var touches = evt.changedTouches;

		for (i in 0...touches.length) {
			var _touches = touches[i];
			trace(_touches);

			var color = colorForTouch(touches[i]);
			var idx = ongoingTouchIndexById(touches[i].identifier);

			if (idx >= 0) {
				console.log("continuing touch " + idx);
				ctx.beginPath();
				console.log("ctx.moveTo(" + ongoingTouches[idx].pageX + ", " + ongoingTouches[idx].pageY + ");");
				ctx.moveTo(ongoingTouches[idx].pageX, ongoingTouches[idx].pageY);
				console.log("ctx.lineTo(" + touches[i].pageX + ", " + touches[i].pageY + ");");
				ctx.lineTo(touches[i].pageX, touches[i].pageY);
				ctx.lineWidth = 4;
				ctx.strokeStyle = color;
				ctx.stroke();

				ongoingTouches.splice(idx, 1, copyTouch(touches[i])); // swap in the new touch record
				console.log(".");
			} else {
				console.log("can't figure out which touch to continue");
			}
		}
	}

	function copyTouch(obj) {
		// :{identifier, pageX, pageY}
		var objc = obj;
		return objc;
		// {
		// 	identifier, pageX, pageY
		// };
	}

	function colorForTouch(touch) {
		var r = touch.identifier % 16;
		var g = Math.floor(touch.identifier / 3) % 16;
		var b = Math.floor(touch.identifier / 7) % 16;
		r = untyped r.toString(16); // make it a hex digit
		g = untyped g.toString(16); // make it a hex digit
		b = untyped b.toString(16); // make it a hex digit
		var color = "#" + r + g + b;
		console.log("color for touch with identifier " + touch.identifier + " = " + color);
		return color;
	}

	function ongoingTouchIndexById(idToFind) {
		for (i in 0...ongoingTouches.length) {
			var _ongoingTouches = ongoingTouches[i];
			trace(_ongoingTouches);

			var id = ongoingTouches[i].identifier;

			if (id == idToFind) {
				return i;
			}
		}
		return -1; // not found
	}

	// ____________________________________ settings/dat.GUI/quicksettings ____________________________________

	function initDatGui2() {
		var text = new FizzyText();
		var gui = new js.dat.gui.GUI();
		gui.add(text, 'message');
		gui.add(text, 'speed', -5, 5);
		gui.add(text, 'displayOutline');
		gui.add(text, 'explode');
	}

	function initDatGui() {
		var gui = new js.dat.gui.GUI();
		gui.add(this, 'message');
		gui.add(this, 'speed', -5, 5);
		gui.add(this, 'displayOutline');
		gui.add(this, 'explode');

		var f1 = gui.addFolder('Flow Field');
		f1.add(this, 'speed');
		f1.add(this, 'noiseStrength');

		var f2 = gui.addFolder('Letters');
		f2.add(this, 'growthSpeed');
		f2.add(this, 'maxSize');
		f2.add(this, 'message');

		// Choose from accepted values
		gui.add(this, 'message', ['pizza', 'chrome', 'hooray']);

		// // Choose from named values
		gui.add(this, 'speed', {Stopped: 0, Slow: 0.1, Fast: 5});

		gui.addColor(this, 'color0');
		gui.addColor(this, 'color1');
		gui.addColor(this, 'color2');
		gui.addColor(this, 'color3');

		var controller = gui.add(this, 'maxSize', 0, 10);
		controller.onChange(function(value) {
			// Fires on every change, drag, keypress, etc.
			trace('value: $value');
		});

		controller.onFinishChange(function(value) {
			// Fires when a controller loses focus.
			js.Browser.alert("The new value is " + value);
		});
	}

	function createQuickSettings() {
		// demo/basic example
		panel1 = QuickSettings.create(10, 10, "Settings")
			.setGlobalChangeHandler(untyped drawShape)

			.addHTML("Reason", "Sometimes I need to find the best settings")

			.addTextArea('Quote', 'text', function(value) trace(value))
			.addBoolean('All Caps', false, function(value) trace(value))

			.setKey('h') // use `h` to toggle menu

			.saveInLocalStorage('store-data-${toString()}');
	}

	function createShape(i:Int, ?point:Point) {
		var shape:Circle = {
			_id: '$i',
			_type: 'circle',
			x: point.x,
			y: point.y,
			radius: _radius,
		}
		// onAnimateHandler(shape);
		return shape;
	}

	function onAnimateHandler(obj:Circle) {
		var padding = 50;
		var time = random(1, 2);
		var xpos = random(padding, w - (2 * padding));
		var ypos = random(padding, h - (2 * padding));
		Go.to(obj, time)
			.x(xpos)
			.y(ypos)
			.ease(Sine.easeInOut)
			.onComplete(onAnimateHandler, [obj]);
	}

	function drawShape() {
		if (this.dot == null)
			return;

		// reset previous sketch
		sketch.clear();

		// background color
		var bg = sketch.makeRectangle(0, 0, w, h, false);
		bg.id = "bg color";

		// group
		var bgGroup = sketch.makeGroup([bg]); // , bg1
		bgGroup.id = "sketch background";
		bgGroup.fill = getColourObj(_color1); // BLACK

		// quick generate grid
		if (isDebug) {
			sketcher.debug.Grid.gridDots(sketch, grid);
		}

		// dummy loop to generate correct number of shapes
		for (i in 0...shapeArray.length) {
			var sh = shapeArray[i];
		}

		var text = sketch.makeText(toString(), w2, h2);
		text.fontFamily = fontFamly;
		text.fontSizePx = 100;
		text.fontWeight = '800';
		text.textAlign = TextAlignType.Center;
		text.fillColor = getColourObj(_color4);

		var circle = sketch.makeCircle(dot.x, dot.y, 50);
		circle.strokeWeight = 10;
		circle.strokeColor = getColourObj(_color3);
		circle.fillOpacity = 0;

		// update sketch, to draw svg or canvas
		sketch.update();
	}

	// ____________________________________ override ____________________________________
	override function setup() {
		trace('SETUP :: ${toString()}');

		dot = createShape(100, {x: w2, y: h2});
		createQuickSettings();
		onAnimateHandler(dot);

		var colorArray = ColorUtil.niceColor100SortedString[randomInt(ColorUtil.niceColor100SortedString.length - 1)];
		_color0 = hex2RGB(colorArray[0]);
		_color1 = hex2RGB(colorArray[1]);
		_color2 = hex2RGB(colorArray[2]);
		_color3 = hex2RGB(colorArray[3]);
		_color4 = hex2RGB(colorArray[4]);

		isDebug = true;

		// to grid
		grid = new GridUtil(w, h);
		grid.setCellSize(_cellsize);
		// grid.setNumbered(3, 3); // 3 horizontal, 3 vertical
		grid.setIsCenterPoint(true); // default true, but can be set if needed

		shapeArray = [];
		for (i in 0...grid.array.length) {
			shapeArray.push(createShape(i, grid.array[i]));
		}
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		// stop();
	}
}

class FizzyText {
	public var message = 'dat.gui';
	public var speed = 0.8;
	public var displayOutline = false;
	public var explode = function() {
		trace("BOOM");
	};

	public function new() {}
}
