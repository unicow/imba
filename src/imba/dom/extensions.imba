var Imba = require("../imba")

extend tag element

	prop events default: {}
	prop intercept default: no
	prop for

	def setContent nodes, type
		@children = nodes
		setChildren nodes, type unless @intercept
		self

	def on event, callback
		dom?.addEventListener event, (@events["{event}_{callback}"] = callback.bind self), true

	def off event, callback
		dom?.removeEventListener event, (@events["{event}_{callback}"]), yes

	def emit name, *params do Imba.emit(self,name,params)
	def listen name, *params do Imba.listen(self,name,*params)
	def once name, *params do Imba.once(self,name,*params)
	def unlisten name, *params do Imba.unlisten(self,name,*params)

	def alert message
		window.alert message

	def storage
		window.localStorage

	def appendStyles styles
		for style of styles when style
			appendStyle style, styles[style]

	def appendStyle name, value
		if (name and value) and let prop = "{name}: {value};"
			setAttribute('style', "{(getAttribute 'style') or ''}{prop}")

	def hasActiveRoute
		let route = @params or getParentRoute?.@params
		return not route or route.@active

	def dir *args
		args.unshift(console)
		Function:prototype:call.apply(console:dir, args)
		self
