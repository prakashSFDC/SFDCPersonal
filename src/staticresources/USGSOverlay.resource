

// create the object
function USGSOverlay( usgsUrl, bounds,map)
{
	
	this.usgsUrl_ = usgsUrl;
	this.bounds_ = bounds;
	this.map_ = map;
 
	this.div_ = null;
  // Explicitly call setMap() on this overlay
  this.setMap(map);
 // alert('End USGS constructor');
}


// prototype
USGSOverlay.prototype = new google.maps.OverlayView();

// initialize
USGSOverlay.prototype.onAdd  = function()
{
	//alert('Entered onAdd()'); 
	//create new div node 
	var div = document.createElement("div");
	div.style.position = "absolute";
	div.style.top = 0;
	div.style.left = 0;
	div.style.height = 0;
	div.style.width = 0;
	//alert('1'); 
		
	// Create an IMG element and attach it to the div.
		var newImg = document.createElement("img");		
		newImg.src= this.usgsUrl_;
		newImg.style.width = "100%";
		newImg.style.height = "100%";
		div.appendChild(newImg);
	
	
	// keep interesting datas
	this.div_ = div;	
	
	var panes = this.getPanes();
	panes.overlayLayer.appendChild(div);
	
//alert('End of onAdd()');	
	
}

// Redraw based on the current projection and zoom level...
USGSOverlay.prototype.draw = function( )
{
//alert('Entered Draw()');
	var overlayProjection = this.getProjection();
//alert('After overlayProjection');
	// get the position in pixels of the bound	
    var sw = overlayProjection.fromLatLngToDivPixel(this.bounds_.getSouthWest());
	var ne = overlayProjection.fromLatLngToDivPixel(this.bounds_.getNorthEast());		
	
	// compute the absolute position (in pixels) of the div ...
	this.div_.style.left = Math.min(ne.x,sw.x) + 'px';
	this.div_.style.top = Math.min(sw.y,ne.y) + 'px';
	// ... and its size
	this.div_.style.width = Math.abs(sw.x - ne.x) +'px';
	this.div_.style.height = Math.abs(sw.y - ne.y) + 'px';
	
	//alert('End of Draw()');
}

// remove from the map pane
USGSOverlay.prototype.onRemove = function()
{
alert('In onRemove()');
  this.div_.parentNode.removeChild(this.div_);
  this.div_ = null;
alert('End of onRemove()');  
}
