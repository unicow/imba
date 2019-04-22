var Imba = require("../imba");

Imba.extendTag('element', function(tag){
	
	tag.prototype.__events = {'default': {},name: 'events'};
	tag.prototype.events = function(v){ return this._events; }
	tag.prototype.setEvents = function(v){ this._events = v; return this; }
	tag.prototype._events = {};
	tag.prototype.__intercept = {'default': false,name: 'intercept'};
	tag.prototype.intercept = function(v){ return this._intercept; }
	tag.prototype.setIntercept = function(v){ this._intercept = v; return this; }
	tag.prototype._intercept = false;
	tag.prototype['for'] = function(v){ return this._for; }
	tag.prototype.setFor = function(v){ this._for = v; return this; };
	
	tag.prototype.setContent = function (nodes,type){
		this._children = nodes;
		if (!this._intercept) { this.setChildren(nodes,type) };
		return this;
	};
	
	tag.prototype.on = function (event,callback){
		var dom_;
		return (dom_ = this.dom()) && dom_.addEventListener  &&  dom_.addEventListener(event,(this._events[("" + event + "_" + callback)] = callback.bind(this)),true);
	};
	
	tag.prototype.off = function (event,callback){
		var dom_;
		return (dom_ = this.dom()) && dom_.removeEventListener  &&  dom_.removeEventListener(event,(this._events[("" + event + "_" + callback)]),true);
	};
	
	tag.prototype.emit = function (name){
		var $0 = arguments, i = $0.length;
		var params = new Array(i>1 ? i-1 : 0);
		while(i>1) params[--i - 1] = $0[i];
		return Imba.emit(this,name,params);
	};
	tag.prototype.listen = function (name){
		var Imba_;
		var $0 = arguments, i = $0.length;
		var params = new Array(i>1 ? i-1 : 0);
		while(i>1) params[--i - 1] = $0[i];
		return Imba.listen.apply(Imba,[].concat([this,name], [].slice.call(params)));
	};
	tag.prototype.once = function (name){
		var Imba_;
		var $0 = arguments, i = $0.length;
		var params = new Array(i>1 ? i-1 : 0);
		while(i>1) params[--i - 1] = $0[i];
		return Imba.once.apply(Imba,[].concat([this,name], [].slice.call(params)));
	};
	tag.prototype.unlisten = function (name){
		var Imba_;
		var $0 = arguments, i = $0.length;
		var params = new Array(i>1 ? i-1 : 0);
		while(i>1) params[--i - 1] = $0[i];
		return Imba.unlisten.apply(Imba,[].concat([this,name], [].slice.call(params)));
	};
	
	tag.prototype.alert = function (message){
		return window.alert(message);
	};
	
	tag.prototype.storage = function (){
		return window.localStorage();
	};
	
	tag.prototype.appendStyles = function (styles){
		var res = [];
		for (var style in styles){
			if (!style) { continue; };
			res.push(this.appendStyle(style,styles[style]));
		};
		return res;
	};
	
	tag.prototype.appendStyle = function (name,value){
		var prop;
		if ((name && value) && (prop = ("" + name + ": " + value + ";"))) {
			return this.setAttribute('style',("" + ((this.getAttribute('style')) || '') + prop));
		};
	};
	
	tag.prototype.hasActiveRoute = function (){
		var getParentRoute_;
		var route = this._params || (getParentRoute_ = this.getParentRoute()) && getParentRoute_._params;
		return !route || route._active;
	};
	
	tag.prototype.dir = function (){
		var $0 = arguments, i = $0.length;
		var args = new Array(i>0 ? i : 0);
		while(i>0) args[i-1] = $0[--i];
		args.unshift(console);
		Function.prototype.call.apply(console.dir,args);
		return this;
	};
});
