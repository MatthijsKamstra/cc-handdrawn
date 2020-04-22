package art;

import sketcher.export.VideoExport;
import sketcher.draw.AST.LineJoin;
import sketcher.draw.AST.LineCap;
import js.Browser.*;
import js.html.*;

class CCGraffiti extends SketcherBase {
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
	var _colorArr:Array<RGB> = [];
	var _activeColor:RGB = null;
	var _colorCounter = 0;

	var testArr:Array<Point> = [
		{x: 100.92373791621911, y: 274.93018259935553}, {x: 100.92373791621911, y: 274.93018259935553}, {x: 100.92373791621911, y: 276.09022556390977},
		{x: 100.92373791621911, y: 276.09022556390977}, {x: 240.12889366272825, y: 300.45112781954884}, {x: 240.12889366272825, y: 300.45112781954884},
		{x: 325.9720730397422, y: 354.9731471535983}, {x: 325.9720730397422, y: 356.1331901181525}, {x: 325.9720730397422, y: 356.1331901181525},
		{x: 379.33404940923737, y: 388.6143931256713}, {x: 379.33404940923737, y: 388.6143931256713}, {x: 378.17400644468313, y: 388.6143931256713},
		{x: 378.17400644468313, y: 388.6143931256713}, {x: 378.17400644468313, y: 388.6143931256713}, {x: 378.17400644468313, y: 389.77443609022555},
		{x: 415.2953813104189, y: 407.1750805585392}, {x: 415.2953813104189, y: 407.1750805585392}, {x: 414.1353383458646, y: 408.33512352309344},
		{x: 414.1353383458646, y: 408.33512352309344}, {x: 414.1353383458646, y: 408.33512352309344}, {x: 447.7765843179377, y: 416.45542427497315},
		{x: 447.7765843179377, y: 416.45542427497315}, {x: 447.7765843179377, y: 417.6154672395274}, {x: 447.7765843179377, y: 417.6154672395274},
		{x: 475.6176154672395, y: 417.6154672395274}, {x: 476.7776584317938, y: 417.6154672395274}, {x: 476.7776584317938, y: 417.6154672395274},
		{x: 512.7389903329753, y: 414.1353383458646}, {x: 512.7389903329753, y: 414.1353383458646}, {x: 512.7389903329753, y: 414.1353383458646},
		{x: 628.7432867883996, y: 392.094522019334}, {x: 628.7432867883996, y: 392.094522019334}, {x: 631.0633727175081, y: 392.094522019334},
		{x: 633.3834586466165, y: 392.094522019334}, {x: 773.7486573576799, y: 378.17400644468313}, {x: 773.7486573576799, y: 378.17400644468313},
		{x: 773.7486573576799, y: 378.17400644468313}, {x: 961.6756176154672, y: 422.25563909774434}, {x: 961.6756176154672, y: 422.25563909774434},
		{x: 961.6756176154672, y: 422.25563909774434}, {x: 946.595059076262, y: 687.905477980666}, {x: 946.595059076262, y: 687.905477980666},
		{x: 946.595059076262, y: 686.7454350161117}, {x: 946.595059076262, y: 686.7454350161117}, {x: 946.595059076262, y: 686.7454350161117},
		{x: 672.8249194414608, y: 736.6272824919441}, {x: 567.2610096670247, y: 716.906552094522}, {x: 567.2610096670247, y: 716.906552094522},
		{x: 508.09881847475833, y: 701.8259935553168}, {x: 508.09881847475833, y: 701.8259935553168}, {x: 509.25886143931257, y: 701.8259935553168},
		{x: 509.25886143931257, y: 701.8259935553168}, {x: 483.7379162191192, y: 693.7056928034372}, {x: 483.7379162191192, y: 693.7056928034372},
		{x: 483.7379162191192, y: 692.5456498388829}, {x: 482.57787325456496, y: 692.5456498388829}, {x: 482.57787325456496, y: 692.5456498388829},
		{x: 483.7379162191192, y: 693.7056928034372}, {x: 461.6970998925886, y: 690.2255639097745}, {x: 460.53705692803436, y: 690.2255639097745},
		{x: 460.53705692803436, y: 689.0655209452202}, {x: 459.3770139634801, y: 689.0655209452202}, {x: 455.8968850698174, y: 689.0655209452202},
		{x: 437.3361976369495, y: 687.905477980666}, {x: 437.3361976369495, y: 687.905477980666}, {x: 433.85606874328676, y: 687.905477980666},
		{x: 432.6960257787325, y: 687.905477980666}, {x: 431.5359828141783, y: 687.905477980666}, {x: 401.37486573576797, y: 689.0655209452202},
		{x: 401.37486573576797, y: 689.0655209452202}, {x: 396.734693877551, y: 690.2255639097745}, {x: 395.5746509129968, y: 690.2255639097745},
		{x: 393.25456498388826, y: 690.2255639097745}, {x: 393.25456498388826, y: 691.3856068743287}, {x: 361.9334049409237, y: 700.6659505907626},
		{x: 361.9334049409237, y: 700.6659505907626}, {x: 361.9334049409237, y: 700.6659505907626}, {x: 361.9334049409237, y: 700.6659505907626},
		{x: 358.453276047261, y: 701.8259935553168}, {x: 357.29323308270676, y: 702.986036519871}, {x: 334.0923737916219, y: 708.7862513426423},
		{x: 334.0923737916219, y: 708.7862513426423}, {x: 334.0923737916219, y: 708.7862513426423}, {x: 328.2921589688507, y: 711.1063372717508},
		{x: 325.9720730397422, y: 712.266380236305}, {x: 274.93018259935553, y: 730.827067669173}, {x: 274.93018259935553, y: 730.827067669173},
		{x: 177.48657357679915, y: 673.984962406015}, {x: 177.48657357679915, y: 673.984962406015}, {x: 177.48657357679915, y: 673.984962406015},
		{x: 171.68635875402794, y: 670.5048335123523}, {x: 141.52524167561762, y: 580.0214822771213}, {x: 141.52524167561762, y: 580.0214822771213},
		{x: 139.20515574650912, y: 571.9011815252417}, {x: 132.24489795918367, y: 542.9001074113856},
	];

	// dat
	var message = '"hand-drawn"';
	var buildversion = App.getBuildDate();
	var useAnimation = true;
	var useAnchor = true;
	var strokeWeight = 60;

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
	var collectionPointColorArray:Array<RGB> = [];
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

		// sketch.canvas.onmousedown = onMouseDownHandler;
		// sketch.canvas.onmousemove = onMouseMoveHandler;
		// sketch.canvas.onmouseup = onMouseUpHandler;

		scale = sketch.canvas.width / document.getElementById('sketcher_canvas').clientWidth;

		// make sure the canvas has the browser focus
		sketch.canvas.focus();
	}

	// ____________________________________ mouse handers ____________________________________

	function onMouseDownHandler(e:MouseEvent) {
		trace('onMouseDownHandler');
		pointArray = [];
		collectionPointArray.push(pointArray);
		collectionPointColorArray.push(_activeColor);
		isMouseDown = true;
	}

	function onMouseMoveHandler(e:MouseEvent) {
		if (isMouseDown) {
			// trace('onMouseMoveHandler');
			var p:Point = {
				x: e.offsetX * scale,
				y: e.offsetY * scale
			};

			console.log(p);
			pointArray.push(p);
		};
	}

	function onMouseUpHandler(e:MouseEvent) {
		trace('onMouseUpHandler');
		isMouseDown = false;
		nextColor();
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
	}

	function clearAll() {
		collectionPointArray = [];
		collectionPointColorArray = [];
		pointArray = [];
		sketch.clear();
		setup();
	}

	function drawShape() {
		// reset previous sketch

		// for (i in 0...collectionPointArray.length) {
		// 	var _pointArray = collectionPointArray[i];
		// 	var polyline = sketch.makePolyLinePoint(_pointArray);
		// 	polyline.strokeWeight = strokeWeight;
		// 	polyline.strokeColor = getColourObj(collectionPointColorArray[i]);
		// 	polyline.fillOpacity = 0;
		// 	polyline.lineCap = LineCap.Round;
		// 	polyline.lineJoin = LineJoin.Round;

		// 	if (useAnchor) {
		// 		for (i in 0..._pointArray.length) {
		// 			var p = _pointArray[i];
		// 			// trace(p);
		// 			var circle = sketch.makeCircle(p.x, p.y, 10);
		// 			circle.fillOpacity = 0;
		// 			circle.strokeColor = getColourObj(BLACK);
		// 			circle.strokeWeight = 3;
		// 		}
		// 	}
		// }
		var polyline = sketch.makePolyLinePoint(testArr);
		polyline.strokeWeight = strokeWeight;
		polyline.strokeColor = getColourObj(LIME);
		polyline.fillOpacity = 0;
		polyline.lineCap = LineCap.Round;
		polyline.lineJoin = LineJoin.Round;

		for (i in 0...testArr.length) {
			var p = testArr[i];
			// trace(p);
			var circle = sketch.makeCircle(p.x, p.y, 10);
			circle.fillOpacity = 0;
			circle.strokeColor = getColourObj(BLACK);
			circle.strokeWeight = 3;
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
		_colorArr = [_color1, _color2, _color3, _color4];
		_activeColor = _colorArr[_colorCounter];

		isDebug = true;

		message = toString();
		description = toString();

		// to grid
		grid = new GridUtil(w, h);
		grid.setCellSize(_cellsize);
		// grid.setNumbered(3, 3); // 3 horizontal, 3 vertical
		grid.setIsCenterPoint(true); // default true, but can be set if needed

		sketch.clear();

		// background color
		var bg = sketch.makeRectangle(0, 0, w, h, false);
		bg.id = "bg color";
		bg.fill = getColourObj(_color0);
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		if (useAnimation)
			drawShape();
		// stop();
	}
}
