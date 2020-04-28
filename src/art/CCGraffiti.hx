package art;

import sketcher.export.VideoExport;
import sketcher.draw.AST.LineJoin;
import sketcher.draw.AST.LineCap;
import js.Browser.*;
import js.html.*;

class CCGraffiti extends SketcherBase {
	// colors
	var _color0:RGB = null;
	var _color1:RGB = null;
	var _color2:RGB = null;
	var _color3:RGB = null;
	var _color4:RGB = null;
	var _colorArr:Array<RGB> = [];
	var _activeColor:RGB = null;
	var _colorCounter = 0;

	// dat
	var message = '"hand-drawn"';
	var buildversion = App.getBuildDate();
	var useMouseMove = false;
	// var useAnimation = true;
	// var useAnchor = true;
	var nozzleWeight = 60;
	var clear = function() {};
	var stopRecording = function() {}
	var startRecording = function() {}

	// mouse
	var isMouseDown:Bool = false;
	var scale = 1.0;
	// points
	var previousP:Point;
	var currentP:Point;

	// video
	var videoExport:VideoExport;

	public function new() {
		// use debug?
		this.isDebug = true;

		super();

		// // embed font files and then init
		// EmbedUtil.embedGoogleFont(fontFamly, drawShape);

		// embed dat.GUI and init
		EmbedUtil.datgui(initDatGui);

		setupOnMouse();
		setupVideo();
	}

	function setupVideo() {
		videoExport = new VideoExport();
		videoExport.setCanvas(sketch.canvas);
		// videoExport.setSvg(mysvg);
		// videoExport.setAudio(audioEl);
		// videoExport.setDownload(downloadButton); // optional
		// videoExport.setVideo(mypreviewvideo); // optional
		videoExport.setup(); // activate everything
	}

	function setupOnMouse() {
		var el = sketch.canvas;

		// el.addEventListener("touchstart", handleStart, false);
		// el.addEventListener("touchend", handleEnd, false);
		// el.addEventListener("touchcancel", handleCancel, false);
		// el.addEventListener("touchmove", handleMove, false);

		sketch.canvas.onmousedown = onMouseDownHandler;
		sketch.canvas.onmousemove = onMouseMoveHandler;
		sketch.canvas.onmouseup = onMouseUpHandler;

		scale = sketch.canvas.width / document.getElementById('sketcher_canvas').clientWidth;

		// make sure the canvas has the browser focus
		sketch.canvas.focus();
	}

	// ____________________________________ mouse handers ____________________________________

	function onMouseDownHandler(e:MouseEvent) {
		trace('onMouseDownHandler');
		isMouseDown = true;
	}

	function onMouseMoveHandler(e:MouseEvent) {
		if (isMouseDown && useMouseMove) {
			// trace('onMouseMoveHandler');
			convertEvent2Points(e);
		};
	}

	function onMouseUpHandler(e:MouseEvent) {
		trace('onMouseUpHandler');
		if (!useMouseMove)
			convertEvent2Points(e);
		nextColor();
		isMouseDown = false;
	}

	function convertEvent2Points(e:MouseEvent) {
		previousP = currentP;
		var p:Point = {
			x: e.offsetX * scale,
			y: e.offsetY * scale
		};
		currentP = p;
		setPoint();
	}

	function nextColor() {
		// trace(_colorCounter);
		// trace(_colorArr.length);

		_colorCounter++;
		if (_colorCounter >= _colorArr.length)
			_colorCounter = 0;

		_activeColor = _colorArr[_colorCounter];
	}

	// ____________________________________ settings/dat.GUI/quicksettings ____________________________________

	function initDatGui() {
		var guiSettings:js.dat.gui.GUI.GUIOptions = {
			name: '${toString()}',
			closed: false
		};
		var gui = new js.dat.gui.GUI(guiSettings);
		gui.add(this, 'message');
		gui.add(sketch.settings, 'type');
		gui.add(this, 'buildversion');
		// gui.add(this, 'useAnimation');
		// gui.add(this, 'useAnchor');
		gui.add(this, 'useMouseMove');
		gui.add(this, 'nozzleWeight');
		// gui.add(this, 'explode');
		var clearControler = gui.add(this, 'clear');
		clearControler.onFinishChange(function(value) {
			clearAll();
		});

		var startControler = gui.add(this, "startRecording");
		startControler.onFinishChange(function(value) {
			videoExport.start();
		});

		var stopControler = gui.add(this, "stopRecording");
		stopControler.onFinishChange(function(value) {
			videoExport.stop();
		});
	}

	function clearAll() {
		// collectionPointArray = [];
		// collectionPointColorArray = [];
		// pointArray = [];
		sketch.clear();

		previousP = null;
		currentP = null;

		setup();
	}

	function dripAnimation(lineObj:LineObject) {
		console.log('dripAnimation: $lineObj');

		Go.to(lineObj, lineObj.time)
			.prop('y2', lineObj.y2 + lineObj.drip)
			.onUpdate(onUpdateHandler, [lineObj])
			.ease(Quad.easeOut);
	}

	function onUpdateHandler(lineObj:LineObject) {
		// console.log('p:$p, $line');

		var p1 = {
			x: lineObj.x1,
			y: lineObj.y1
		}
		var p2 = {
			x: lineObj.x2,
			y: lineObj.y2
		}

		var line = sketch.makeLinePoint(p1, p2);
		line.setStroke(getColourObj(PINK), lineObj.r);
		line.setLineEnds();

		sketch.update();
	}

	function setPoint() {
		var p = currentP;

		var circle = sketch.makeCircle(p.x, p.y, 4);
		circle.setFill(getColourObj(BLACK), 0.5);

		var circle = sketch.makeCircle(p.x, p.y, nozzleWeight);
		circle.fillOpacity = 0;
		circle.setStroke(getColourObj(BLACK), 0.5);

		if (previousP != null) {
			var line = sketch.makeLinePoint(currentP, previousP);
			line.setStroke(getColourObj(RED), nozzleWeight * 2, 0.1);
			line.setLineEnds();
			var line = sketch.makeLinePoint(currentP, previousP);
			line.setStroke(getColourObj(RED), 1);

			var distance = MathUtil.distancePoint(currentP, previousP);
			if (distance <= nozzleWeight) {
				var circle = sketch.makeCircle(p.x, p.y, distance);
				circle.fillOpacity = 0;
				circle.setStroke(getColourObj(LIME), 1);

				var pct = distance / nozzleWeight;
				var pct2 = 1 - (distance / nozzleWeight);

				// console.log(pct + '%');
				// console.log(pct2 + '%');

				var drip = sketch.makeCircle(p.x, p.y, nozzleWeight * pct2);
				drip.setFill(getColourObj(LIME), 0.5);

				var _line:LineObject = {
					x1: p.x,
					y1: p.y,
					x2: p.x,
					y2: p.y,
					r: 50 * pct2,
					drip: nozzleWeight * 1.5 + (100 * pct2),
					time: (2 * pct)
				}

				dripAnimation(_line);
			}
		}

		// update sketch, to draw svg or canvas
		sketch.update();
	}

	function drawShape() {
		// update sketch, to draw svg or canvas
		sketch.update();
	}

	// ____________________________________ override ____________________________________
	override function setup() {
		trace('SETUP :: ${toString()}');

		var colorArray = ColorUtil.niceColor100SortedString[randomInt(ColorUtil.niceColor100SortedString.length - 1)];
		_color0 = hex2RGB(colorArray[0]);
		_color1 = hex2RGB(colorArray[1]);
		_color2 = hex2RGB(colorArray[2]);
		_color3 = hex2RGB(colorArray[3]);
		_color4 = hex2RGB(colorArray[4]);
		_colorArr = [_color1, _color2, _color3, _color4];
		_activeColor = _colorArr[_colorCounter];

		isDebug = true;

		message = toString();
		description = toString();

		sketch.clear();

		// background color
		var bg = sketch.makeRectangle(0, 0, w, h, false);
		bg.id = "bg color";
		bg.fill = getColourObj(_color0);

		// update
		sketch.update();
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		// stop();
		// drawShape();
	}
}

typedef LineObject = {
	var x1:Float;
	var y1:Float;
	var x2:Float;
	var y2:Float;
	var r:Float;
	var drip:Float;
	var time:Float;
}
