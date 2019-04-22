# <div ->
# <.only[objvar]>
# <.only[objvar] :tap.test()>

var v = "hello"

tag cached
	def render
		<self>
			<.tool[data].neg uxa:action='notediscard'> <i.sicon data-name='circlecross'>
			for v in @ary
				<div@{v}> "v"

var bool = false
var fn = do console.log "called!"

<div ->
	<.tool[data].neg uxa:action='notediscard'> <i.sicon data-name='circlecross'>
	<button title="Something" css:display='block'>
	<button x:hello='block'>

	<button.two .{v} :tap.stop.hello(10)>
	<button.two :tap.prevent(bool)>
	<button.two :tap.prevent=fn>
	
	<button :tap.prevent=(|e| e.log("cached") )>
	<button :tap.prevent=(|e| e.log("cached",bool) )>
	<button .toggled=bool>
	
	<button 
		.toggled=bool
		:tap.stop.hello(10)
		title="Hello there"
	>


def check find, &blk
	let val = String(blk)
	assert.ok(val.indexOf(find) >= 0, "'{find}' not found in {val}")


if false # test
	
	var strvar = "hello"
	var numvar = 1
	var fnvar = do yes
	var objvar = {a: 1, b: 2}
	
	# id
	check "setId('one')" do <div#one>
		
	# flags
	check "flag('two')" do <div.two>
	check "flag('two',numvar)" do <div .two=numvar>
	check "setFlag(0,strvar)" do <div .{strvar}>
	check "setFlag(0,self.name())" do <div .{name}>
		
	# attributes
	check "setTitle(strvar)" do <div title=strvar>
	check "css('display','block')" do <div css:display='block'>
	check "setDisabled('disabled')" do <input disabled>
	check "setDisabled('disabled').setReadonly('readonly')" do <input disabled readonly>
		
	check "set('model',strvar,\{number:1\})" do <div model.number=strvar>
		
	# events
	check "('tap',['prevent','after'],0)" do <div.two :tap.prevent.after>
	check "('tap',[['incr',10]],0)" do <div.two :tap.incr(10)>
	check "('tap',[fnvar],0)" do <div.two :tap=fnvar>
		
	# data
	check "setData(objvar)" do <div[objvar]>
		
	# reference
	check "ref_('main',self)" do <div[objvar]@main>
	# eq <button.two .{v} :tap.stop.hello(10)>

tag App
	
	def myMethod a,b
		console.log "App#myMethod {dom:className}",[].concat(*arguments)
		
	def ontap
		console.log "App#ontap"

tag Inner
	def myMethod a,b
		console.log "Inner#myMethod",a,b

var fn = do yes

Imba.mount <App ->
	<button :tap.stop.myMethod> "myMethod"
	<button :tap.myMethod()> "myMethod()"
	<button :tap.myMethod(10)> "myMethod(10)"
	<button :tap.myMethod(10,20)> "myMethod(10,20)"
	<button :tap.myMethod(10,$event)> "myMethod(10,$event)"
	<button[100] :tap.myMethod(10,$event,$data)> "myMethod(10,$event,$data)"
	<button :tap.alt.myMethod(10)> "alt.myMethod(10)"
	<button :tap.alt.myMethod(10,data)> "alt.myMethod(10,data)"
	<button :tap.alt=fn> "alt.myMethod(10)"
	<button :tap.alt.bubble.myMethod(10)> "alt.bubble.myMethod(10)"
	<button :tap.self.stop.alt.myMethod(10)>
		"self.stop.alt.myMethod(10)"
		<b> "inner"
		
	<div>
		<input type='text' :keydown.left.log("left")>
		<input type='text' :keydown.del.log("del")>

	<div> "Hello"
	
	