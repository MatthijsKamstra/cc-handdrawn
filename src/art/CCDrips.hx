package art;

// import ;
import sketcher.draw.AST.LineCap;

class CCDrips extends SketcherBase {
	var grid:GridUtil;
	var circleRadius = 85;
	// dat
	var message = 'drips';
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
			name: "drips",
			closed: true
		};
		var gui = new js.dat.gui.GUI(guiSettings);
		gui.add(this, 'message');
		gui.add(this, 'circleRadius');
		var refreshController = gui.add(this, 'refresh');
		refreshController.onFinishChange((e) -> {
			drawShape();
		});
		// gui.add(this, 'strokeWeight');
		// gui.close();
	}

	function drawShape() {
		sketch.clear();
		for (k in 0...grid.array.length) {
			// center point
			var cp:Point = grid.array[k];
			sketch.makeX(Math.round(cp.x), Math.round(cp.y));

			// random biggest spatter
			var randomCircleRadius = random(circleRadius / 2, circleRadius);
			// for-ground
			var circle = sketch.makeCircle(Math.round(cp.x), Math.round(cp.y), Math.round(randomCircleRadius));
			circle.fill = ' black ';
			circle.noStroke();
			// border spatter
			for (i in 0...10) {
				var rp:Point = {
					x: cp.x + random(-randomCircleRadius, randomCircleRadius),
					y: cp.y + random(-randomCircleRadius, randomCircleRadius)
				};
				var spatter = sketch.makeCircle(Math.round(rp.x), Math.round(rp.y), Math.round(random(randomCircleRadius / 2)));
				spatter.fill = rgb(0); // ' black ';
				spatter.noStroke();
			}
			// drip
			for (j in 0...3) {
				var dripWeight = randomInt(10, Math.round(randomCircleRadius / 2));
				var rp:Point = {
					x: cp.x + random(-randomCircleRadius + dripWeight, randomCircleRadius - dripWeight),
					y: cp.y + random(-randomCircleRadius + dripWeight, randomCircleRadius - dripWeight)
				};
				// drip line, straight down
				var line = sketch.makeLine(Math.round(rp.x), Math.round(rp.y), Math.round(rp.x),
					Math.round(rp.y + random(randomCircleRadius, randomCircleRadius + 100)));
				line.lineCap = LineCap.Round;
				line.stroke = rgb(0);
				line.lineWeight = dripWeight;
			}
		}

		// draw
		sketch.update();
	}

	// ____________________________________ override ____________________________________

	override function setup() {
		trace('SETUP :: ${toString()}');

		// to grid
		grid = new GridUtil(w, h);
		grid.setIsCenterPoint(true);
		grid.setNumbered(3, 3);
	}

	override function draw() {
		// trace('DRAW :: ${toString()}');
		drawShape();
		stop();
	}
}
