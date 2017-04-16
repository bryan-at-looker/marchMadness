(function() {
  looker.plugins.visualizations.add({
    id: 'ltv_grid',
    label: 'LTV Grid',
    options: {
      colorPreSet:
      {
        type: 'string',
        display: 'select',
        label: 'Color Range',
        section: 'Data',
        values: [{'Custom': 'c'},
        {'Tomato to Steel Blue': '#F16358,#DF645F,#CD6566,#BB666D,#A96774,#97687B,#856982,#736A89,#616B90,#4F6C97,#3D6D9E'},
        {'Pink to Black': '#170108,#300211,#49031A,#620423,#79052B,#910734,#AA083D, #C30946,#DA0A4E,#F30B57,#F52368,#F63378,#F63C79,#F75389,#F86C9A,#F985AB,#FB9DBC,#FCB4CC,#FDCDDD,#FEE6EE'},
        {'Green to  Red': '#ff4000,#ff8000,#ffbf00,#ffff00,#bfff00,#80ff00,#40ff00,#00ff00'},
        {'White to Green': '#ffffe5,#f7fcb9,#d9f0a3,#addd8e,#78c679,#41ab5d,#238443,#006837,#004529'},
        {'Green, Yellow, Red': '#9CFF94,#F6FFA3,#FF9C94'},
        {'Sunset': '#ffffcc,#ffeda0,#fed976,#feb24c,#fd8d3c,#fc4e2a,#e31a1c,#b10026'}],
        default: 'c',
        order: 1
      },

      colorMeasure: {
        type: 'number',
        label: 'Measure to Color',
        section: 'Data',
        placeholder: '1,2 or 3',
        order: 3
      },

      colorMinRange: {
        type: 'number',
        label: 'Min Range to Color',
        section: 'Data',
        order: 2.51,
        placeholder: 'min'
      },

      colorMaxRange: {
        type: 'number',
        label: 'Max Range to Color',
        section: 'Data',
        order: 2.52,
        placeholder: 'max'
      }
    },

    handleErrors: function(data, resp) {

      if (!resp || !resp.fields) return null;
      if (resp.fields.dimensions.length != 1) {
        this.addError({
          group: 'dimension-req',
          title: 'Incompatible Data',
          message: 'One dimension is required'
        });
        return false;
      } else {
        this.clearErrors('dimension-req');
      }
      if (resp.fields.pivots.length != 1) {
        this.addError({
          group: 'pivot-req',
          title: 'Incompatible Data',
          message: 'One pivot is required'
        });
        return false;
      } else {
        this.clearErrors('pivot-req');
      }
      if (resp.fields.measures.length > 3) {
        this.addError({
          group: 'measure-req',
          title: 'Incompatible Data',
          message: 'One to Three measures are required'
        });
        return false;
      } else {
        this.clearErrors('measure-req');
      }
      return true;
    },

    create: function(element, settings) {
      d3.select(element)
      .append('svg')
      .style('overflow', 'auto')
      .style('height', '100%')
      .append('grid')
      .attr('class', 'grid')
      .attr('id', 'grid-id')
      .attr('width', '100%')
      .attr('height', '100%');
    },

    update: function(data, element, settings, resp) {
      var columncount = 1 + resp["pivots"].length || 0;
      
      if (!this.handleErrors(data, resp)) return;
      this.clearErrors('color-error');

      var gradientMeasure = settings.colorMeasure || 1;

      var measures = [];

      if (resp.fields.measures[0] !== undefined) {
        measures.push(resp.fields.measures[0]);
      }
      if (resp.fields.measures[1] !== undefined) {
        measures.push(resp.fields.measures[1]);
      }
      if (resp.fields.measures[2] !== undefined) {
        measures.push(resp.fields.measures[2]);
      }
      if (resp.fields.table_calculations[0] !== undefined) {
        measures.push(resp.fields.table_calculations[0]);
      }
      if (resp.fields.table_calculations[1] !== undefined) {
        measures.push(resp.fields.table_calculations[1]);
      }

      if (settings.colorPreSet  == 'c') {
        var colorSettings =  settings.colorRange || ['white','#b3c8dc','#b3c8dc'];
      } else {
        var colorSettings =  settings.colorPreSet.split(",");
      };

      var dimension = resp.fields.dimensions[0];
      var measure = measures[0];
      var measure1 = measures[1] || {};
      var measure2 = measures[2] || {};

      var pivot = resp.pivots;
      var coloredMeasure = measure.name
      var colorMinMaxRange = [settings.colorMinRange || null , settings.colorMaxRange || null ];

      if(gradientMeasure == '2'){
        coloredMeasure = measure1.name
      }else if(gradientMeasure == '3'){
        coloredMeasure = measure2.name
      };

      var extents = d3.extent(data.reduce(function(prev, curr) {
        var values = pivot.map(function(pivot) {
          // console.log(curr[coloredMeasure][pivot.key].value);

          // test min and max, return only values in between
          if(pivot.is_total){ // ignore totals
            return null;

          }
          // Below Min
          else if(!(colorMinMaxRange[0]==null) && curr[coloredMeasure][pivot.key].value < Number(colorMinMaxRange[0])){
            return colorMinMaxRange[0];

          }
          // Above Max
          else if(!(colorMinMaxRange[1]==null) && curr[coloredMeasure][pivot.key].value > Number(colorMinMaxRange[1])){
            return colorMinMaxRange[1]
          }
          else
            return curr[coloredMeasure][pivot.key].value;
        });
        return prev.concat(values);
      }, []));

      extents = [Math.max(Number(colorMinMaxRange[1]),extents[1]) , Math.min(Number(colorMinMaxRange[0]),extents[0])];  
      var extentRange = extents[1] - extents[0];
      var extentInterval = extentRange / (colorSettings.length - 1);

      var colorScale = d3.scale.linear().domain(extents).range(colorSettings);

      // var grid = d3.select(element)
      // .select('grid');

			function gridData() {
				var data = new Array();
				var xpos = 1; //starting xpos and ypos at 1 so the stroke will show when we make the grid below
				var ypos = 1;
				var width = 50;
				var height = 50;
				var click = 0;
				
				// iterate for rows	
				for (var row = 0; row < 10; row++) {
					data.push( new Array() );
					
					// iterate for cells/columns inside rows
					for (var column = 0; column < 10; column++) {
						data[row].push({
							x: xpos,
							y: ypos,
							width: width,
							height: height,
							click: click
						})
						// increment the x position. I.e. move it over by 50 (width variable)
						xpos += width;
					}
					// reset the x position after a row is complete
					xpos = 1;
					// increment the y position for the next row. Move it down 50 (height variable)
					ypos += height;	
				}
				return data;
			}

			var gridData = gridData();	
			// I like to log the data to the console for quick debugging
			// console.log(gridData);

			var grid = d3.select("#grid")
				.append("svg")
				.attr("width","510px")
				.attr("height","510px");
				
			var row = grid.selectAll(".row")
				.data(gridData)
				.enter().append("g")
				.attr("class", "row");
				
			var column = row.selectAll(".square")
				.data(function(d) { return d; })
				.enter().append("rect")
				.attr("class","square")
				.attr("x", function(d) { return d.x; })
				.attr("y", function(d) { return d.y; })
				.attr("width", function(d) { return d.width; })
				.attr("height", function(d) { return d.height; })
				.style("fill", "#fff")
				.style("stroke", "#222")
				.on('click', function(d) {
			       d.click ++;
			       if ((d.click)%4 == 0 ) { d3.select(this).style("fill","#fff"); }
				   if ((d.click)%4 == 1 ) { d3.select(this).style("fill","#2C93E8"); }
				   if ((d.click)%4 == 2 ) { d3.select(this).style("fill","#F56C4E"); }
				   if ((d.click)%4 == 3 ) { d3.select(this).style("fill","#838690"); }
			    });
			}
		});
	}());
