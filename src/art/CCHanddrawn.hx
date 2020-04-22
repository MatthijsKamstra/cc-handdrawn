package art;

import sketcher.export.VideoExport;
import sketcher.draw.AST.LineJoin;
import sketcher.draw.AST.LineCap;
import js.Browser.*;
import js.html.*;

class CCHanddrawn extends SketcherBase {
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

	// dat
	var message = '"hand-drawn"';
	var useAnimation = true;
	var useAnchor = false;
	var strokeWeight = 10;

	// var explode = function() {
	// 	trace('booom');
	// };
	var clear = function() {};
	var stopRecording = function() {}
	var startRecording = function() {}

	///
	var fontFamly = 'Oswald:200,300,400,500,600,700';
	var isMouseDown:Bool = false;
	var scale = 1.0;
	var collectionPointArray:Array<Array<Point>> = [];
	var pointArray:Array<Point> = [];
	var videoExport:VideoExport;

	public function new() {
		// use debug?
		this.isDebug = true;

		super();

		// embed font files and then init
		EmbedUtil.embedGoogleFont(fontFamly, drawShape);

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
		pointArray = [];
		collectionPointArray.push(pointArray);
		isMouseDown = true;
	}

	function onMouseMoveHandler(e:MouseEvent) {
		if (isMouseDown) {
			// trace('onMouseMoveHandler');
			var p:Point = {
				x: e.offsetX * scale,
				y: e.offsetY * scale
			};
			pointArray.push(p);
		};
	}

	function onMouseUpHandler(e:MouseEvent) {
		trace('onMouseUpHandler');
		isMouseDown = false;
	}

	// ____________________________________ settings/dat.GUI/quicksettings ____________________________________

	function initDatGui() {
		var gui = new js.dat.gui.GUI();
		gui.add(this, 'message');
		gui.add(this, 'useAnimation');
		gui.add(this, 'useAnchor');
		gui.add(this, 'strokeWeight');
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

		// var f1 = gui.addFolder('Flow Field');
		// f1.add(this, 'speed');
		// f1.add(this, 'noiseStrength');

		// var f2 = gui.addFolder('Letters');
		// f2.add(this, 'growthSpeed');
		// f2.add(this, 'maxSize');
		// f2.add(this, 'message');

		// // Choose from accepted values
		// gui.add(this, 'message', ['pizza', 'chrome', 'hooray']);

		// // // Choose from named values
		// gui.add(this, 'speed', {Stopped: 0, Slow: 0.1, Fast: 5});

		// gui.addColor(this, 'color0');
		// gui.addColor(this, 'color1');
		// gui.addColor(this, 'color2');
		// gui.addColor(this, 'color3');

		// var controller = gui.add(this, 'maxSize', 0, 10);
		// controller.onChange(function(value) {
		// 	// Fires on every change, drag, keypress, etc.
		// 	trace('value: $value');
		// });

		// controller.onFinishChange(function(value) {
		// 	// Fires when a controller loses focus.
		// 	js.Browser.alert("The new value is " + value);
		// });
	}

	function clearAll() {
		collectionPointArray = [];
		pointArray = [];
		sketch.clear();
		setup();
	}

	function drawShape() {
		// reset previous sketch
		sketch.clear();

		// background color
		var bg = sketch.makeRectangle(0, 0, w, h, false);
		bg.id = "bg color";
		bg.fill = getColourObj(_color1);

		// quick generate grid
		if (isDebug) {
			// sketcher.debug.Grid.gridDots(sketch, grid);
		}

		var text = sketch.makeText(message, w2, h4);
		text.fontFamily = fontFamly;
		text.fontSizePx = 100;
		text.fontWeight = '800';
		text.textAlign = TextAlignType.Center;
		text.fillColor = getColourObj(_color4);
		text.fillOpacity = .3;

		// dummy loop to generate correct number of shapes
		// for (i in 0...shapeArray.length) {
		// 	var sh = shapeArray[i];
		// }

		for (i in 0...collectionPointArray.length) {
			var _pointArray = collectionPointArray[i];
			var polyline = sketch.makePolyLinePoint(_pointArray);
			polyline.strokeWeight = strokeWeight;
			polyline.strokeColor = getColourObj(_color3);
			polyline.fillOpacity = 0;
			polyline.lineCap = LineCap.Round;
			polyline.lineJoin = LineJoin.Round;

			if (useAnchor) {
				for (i in 0..._pointArray.length) {
					var p = _pointArray[i];
					// trace(p);
					var circle = sketch.makeCircle(p.x, p.y, 10);
					circle.fillOpacity = 0;
					circle.strokeColor = getColourObj(_color2);
					circle.strokeWeight = 3;
				}
			}
		}

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

		isDebug = true;

		message = toString();
		description = toString();

		// to grid
		grid = new GridUtil(w, h);
		grid.setCellSize(_cellsize);
		// grid.setNumbered(3, 3); // 3 horizontal, 3 vertical
		grid.setIsCenterPoint(true); // default true, but can be set if needed
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		if (useAnimation)
			drawShape();
		// stop();
	}
}
