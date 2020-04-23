package art;

// import ;
import sketcher.draw.IBase;
import sketcher.draw.AST.LineCap;

class CCCurve extends SketcherBase {
	// dat
	var message = 'spatter';
	var isArtwork = false;
	var _lineWeight = 1;
	var refresh = function() {}

	public function new() {
		// use debug?
		this.isDebug = true;

		var stageW = 1080; // 1024; // video?
		var stageH = 1080; // 1024; // video?
		var settings = new Settings(stageW, stageH, 'svg');
		settings.autostart = true;
		settings.padding = 10;
		settings.scale = false;
		settings.elementID = 'sketcher-wrapper';

		super(settings);

		// embed dat.GUI and init
		EmbedUtil.datgui(initDatGui);
	}

	function initDatGui() {
		var guiSettings:js.dat.gui.GUI.GUIOptions = {
			name: "spatter",
			closed: false
		};
		var gui = new js.dat.gui.GUI(guiSettings);
		gui.add(this, 'message');

		gui.add(this, 'isArtwork');
		gui.add(this, '_lineWeight');
		var refreshController = gui.add(this, 'refresh');
		refreshController.onFinishChange((e) -> {
			drawShape();
		});
		// gui.add(this, 'strokeWeight');
		// gui.close();
	}

	// ____________________________________ override setup ____________________________________

	override function setup() {
		trace('SETUP :: ${toString()}');

		message = toString();
		description = toString();
	}

	function drawShape() {
		sketch.clear();

		var debugCircleArray:Array<IBase> = [];
		var debugCircleArray2:Array<IBase> = [];
		var spatterArray:Array<IBase> = [];
		var lineArray:Array<IBase> = [];
		var debugArray:Array<IBase> = [];
		var groupArray:Array<IBase> = [];

		var distance = MathUtil.random(h2, h);
		var dia0 = MathUtil.random(w / 10, w);
		var dia1 = MathUtil.random(w - w3, w);

		var pVertical0:Point = {
			x: w2,
			y: h2 - (distance / 2),
		}
		var pVertical1:Point = {
			x: w2,
			y: h2 + (distance / 2),
		}
		// top horizon
		var pHorizontalTop0:Point = {
			x: w2 - (dia0 / 2),
			y: pVertical0.y,
		}
		var pHorizontalTop1:Point = {
			x: w2 + (dia0 / 2),
			y: pVertical0.y,
		}
		// bottom horizon
		var pHorizontalBottom0:Point = {
			x: w2 - (dia1 / 2),
			y: pVertical1.y,
		}
		var pHorizontalBottom1:Point = {
			x: w2 + (dia1 / 2),
			y: pVertical1.y,
		}
		// midden line
		var line = sketch.makeLinePoint(pVertical0, pVertical1).noFill().setStroke(getColourObj(GREEN), 1);
		lineArray.push(cast line);

		// horizontal line top
		var line = sketch.makeLinePoint(pHorizontalTop0, pHorizontalTop1).noFill().setStroke(getColourObj(PINK));
		lineArray.push(cast line);
		// horizontal line bottom
		var line = sketch.makeLinePoint(pHorizontalBottom0, pHorizontalBottom1).noFill().setStroke(getColourObj(PINK));
		lineArray.push(cast line);

		var horArray:Array<Point> = [];
		var horbottomArray:Array<Point> = [];
		var verArray:Array<Point> = [];

		var total = 50;
		for (i in 0...total + 1) {
			var p:Point = {
				x: pHorizontalTop0.x + (i * ((pHorizontalTop1.x - pHorizontalTop0.x) / total)),
				y: pHorizontalTop0.y,
			}
			var p1:Point = {
				x: pHorizontalBottom0.x + (i * ((pHorizontalBottom1.x - pHorizontalBottom0.x) / total)),
				y: pHorizontalBottom0.y,
			}
			horArray.push(p);
			horbottomArray.push(p1);
			var circle = sketch.makeCircle(p.x, p.y, 10).noFill().setStroke(getColourObj(PINK));
			debugCircleArray.push(cast circle);
			var circle = sketch.makeCircle(p1.x, p1.y, 10).noFill().setStroke(getColourObj(PINK));
			debugCircleArray.push(cast circle);

			var p2:Point = {
				x: pVertical0.x,
				y: pVertical0.y + (i * ((pVertical1.y - pVertical0.y)) / total)
			}
			verArray.push(p2);
			var circle = sketch.makeCircle(p2.x, p2.y, 10).noFill().setStroke(getColourObj(LIME));
			var x = sketch.makeX(p2.x, p2.y);

			// debugCircleArray.push(cast circle);
		}

		// trace(horArray);
		// trace(horArray.length);
		// trace(Math.floor(horArray.length / 2));
		// // console.log(hor1Array);
		// // console.log(hor2Array);
		var offset = 10;
		for (i in 0...Math.ceil(horArray.length / 2)) {
			var p_t1:Point = horArray[i]; // first top horizontal line
			var p_t2:Point = horArray[(horArray.length - 1) - i]; // second top horizontal line
			var p_v1:Point = verArray[i]; // first part vertical line
			var p_v2:Point = verArray[(verArray.length - 1) - i]; // second part vertical line

			var line = sketch.makeLinePoint(p_t1, hpoint(p_v1, -offset)).noFill().setStroke(getColourObj(PURPLE), _lineWeight).setLineEnds();
			var line = sketch.makeLinePoint(p_t2, hpoint(p_v1, offset)).noFill().setStroke(getColourObj(PURPLE), _lineWeight).setLineEnds();

			var p_b1:Point = horbottomArray[i]; // first bottom horizontal line
			var p_b2:Point = horbottomArray[(horbottomArray.length - 1) - i]; // second bottom horizontal line

			var line = sketch.makeLinePoint(p_b1, hpoint(p_v2, -offset)).noFill().setStroke(getColourObj(PURPLE), _lineWeight).setLineEnds();
			var line = sketch.makeLinePoint(p_b2, hpoint(p_v2, offset)).noFill().setStroke(getColourObj(PURPLE), _lineWeight).setLineEnds();
		}

		var g = sketch.makeGroup(debugCircleArray);
		g.id = 'debug circles one';
		groupArray.push(g);
		var g = sketch.makeGroup(lineArray);
		g.id = 'lines';
		groupArray.push(g);

		sketch.update();
	}

	function hpoint(p:Point, offset:Float):Point {
		var _p:Point = {
			x: p.x + offset,
			y: p.y,
		}
		return _p;
	}

	// ____________________________________ override ____________________________________

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		stop();
	}
}
