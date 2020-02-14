package art;

// import ;
import sketcher.draw.AST.LineCap;

class CCSpatter extends SketcherBase {
	var grid:GridUtil;

	var _shapeMax = 100;
	var _divide:Float = null;

	final finalBigSpatterCircle = 200.0;
	final finalSmallSpatterCircle = 200.0 / 3;
	var _bigSpatterCircle = 200.;
	var _smallSpatterCircle = 200.0 / 3;
	var _lineWeight = 10;
	var _litelineWeight = 1;
	var _xoffset = null;

	// dat
	var message = 'spatter';
	var isArtwork = false;
	var refresh = function() {}

	public function new() {
		// use debug?
		this.isDebug = true;

		super();

		// embed dat.GUI and init
		EmbedUtil.datgui(initDatGui);
	}

	function initDatGui() {
		var guiSettings:js.dat.gui.GUI.GUIOptions = {
			name: "spatter",
			closed: true
		};
		var gui = new js.dat.gui.GUI(guiSettings);
		gui.add(this, 'message');

		gui.add(this, 'isArtwork');
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

		// to grid
		grid = new GridUtil(w, h);
		grid.setIsCenterPoint(true);
		grid.setNumbered(3, 3);
		// set default values

		_divide = (360 / _shapeMax);
	}

	function drawShape() {
		sketch.clear();

		/**
		 * - bigspatter is random based upon finalBigSpaterCircle size
		 * - smallspatter is smaller then the bigspatter
		 * - distance of the smallspatter is longer when circle is smaller: 0.2 max distance, 0.6 minimal distance
		 */
		_bigSpatterCircle = finalBigSpatterCircle * MathUtil.random(0.5, 1.2);

		_smallSpatterCircle = _bigSpatterCircle * MathUtil.random(0.2, 0.6);
		_xoffset = (_bigSpatterCircle * 1);

		// base spatter
		var p:Point = {
			x: w2,
			y: h2,
		}
		var x = sketch.makeX(p.x, p.y);
		var circle = sketch.makeCircle(p.x, p.y, _bigSpatterCircle);
		circle.fill = getColourObj(BLACK);
		if (isArtwork) {
			circle.setFill(getColourObj(BLACK)).setStroke(getColourObj(BLACK), _lineWeight);
		} else {
			// circle.noStroke();
			circle.noFill();
			circle.strokeColor = getColourObj(BLACK);
			circle.strokeWeight = _litelineWeight;
		}

		// small spatter
		var p2:Point = {
			x: p.x + _xoffset,
			y: p.y,
		}
		var x = sketch.makeX(p2.x, p2.y);
		var circle = sketch.makeCircle(p2.x, p2.y, _smallSpatterCircle);
		if (isArtwork) {
			circle.setFill(getColourObj(BLACK)).setStroke(getColourObj(BLACK), _lineWeight);
		} else {
			// circle.noStroke();
			circle.noFill();
			circle.strokeColor = getColourObj(RED);
			circle.strokeWeight = _litelineWeight;
		}

		// dots on circle
		var bigArray:Array<Point> = [];
		var smallArray:Array<Point> = [];
		for (i in 0..._shapeMax) {
			var angle = i * _divide;

			var posx = p.x + Math.cos(radians(angle - 180)) * (_bigSpatterCircle);
			var posy = p.y + Math.sin(radians(angle - 180)) * (_bigSpatterCircle);
			var posx2 = p2.x + Math.cos(radians(angle + 0)) * (_smallSpatterCircle);
			var posy2 = p2.y + Math.sin(radians(angle + 0)) * (_smallSpatterCircle);

			bigArray.push({x: posx, y: posy});
			smallArray.push({x: posx2, y: posy2});

			if (!isArtwork) {
				var r = (i == 0) ? 10 : 4; // visualize starting circle

				var c = sketch.makeCircle(posx, posy, r);
				c.noFill();
				c.setStroke(getColourObj(GREEN), 1);

				var c2 = sketch.makeCircle(posx2, posy2, r);
				c2.noFill();
				c2.setStroke(getColourObj(GREEN), 1);
			}
		}

		var s1:Int = _shapeMax;
		var s2:Int = Math.round(_shapeMax / 2);
		var s3:Int = Math.round(_shapeMax / 3);
		var s4:Int = Math.round(_shapeMax / 4);

		for (i in 0...s2) {
			var p1 = bigArray[i + s4];
			var p2 = smallArray[i + s4];
			var p3 = smallArray[i + s4 - 10];
			var p4 = smallArray[i + s4 + 10];

			var _lineColor = getColourObj(GREEN);
			var _dlineWeight = _litelineWeight;
			if (isArtwork) {
				_lineColor = getColourObj(BLACK);
				_dlineWeight = _lineWeight;
			}

			sketch.makeLinePoint(p1, p2).setStroke(_lineColor, _dlineWeight).setLineEnds();
			sketch.makeLinePoint(p1, p3).setStroke(_lineColor, _dlineWeight).setLineEnds();
			sketch.makeLinePoint(p1, p4).setStroke(_lineColor, _dlineWeight).setLineEnds();
		}

		sketch.update();
	}

	// ____________________________________ override ____________________________________

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		stop();
	}
}
