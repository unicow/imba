# to run these tests, simply open the imbadir/test/dom.html in your browser and
# open the console / developer tools.

extern describe, test, ok, eq, it

var _ = require 'underscore'

tag el

	def flag ref
		@flagged = ref
		super

tag group
	prop ops
	prop opstr

	prop expected
	prop actual
		
	def setChildren nodes, typ
		@ops = []
		@opstr = ""
		@errors = null
		expected = _.flatten(nodes).filter do |n|
			n isa String or (n and n.@dom)
			# n isa String ? n : (n and n.@dom)
			# n and n.@dom
		actual = []
		# log "setStaticChildren",nodes,expected
		super(nodes,typ)

		for child,i in @dom:childNodes
			# how would this work on server?
			# if child isa Text
			# 	actual.push( child:textContent )
			# 	continue if child:textContent == expected[i]

			var el = child isa Text ? child:textContent : tag(child)
			if el != expected[i]
				@errors ||= []
				# log "not the same as expected at i",child,expected[i].@dom
				@errors.push([el,expected[i],i])

			actual.push( el )
		# log actual

		if @errors
			console.log 'got errors'
			console.log 'expected',expected
			console.log 'found',actual

		eq @errors, null
		return self

	def appendChild node
		# log "appendChild",node
		ops.push ["appendChild",node]
		@opstr += "A"
		super

	def removeChild node
		# log "removeChild",node
		ops.push ["removeChild", node]
		@opstr += "R"
		super

	def insertBefore node, rel
		# log "insertBefore"
		ops.push ["insertBefore",node,rel]
		@opstr += "I"
		super

	def reset
		render
	
	def commit
		self # dont render automatically

	def name
		"test"

	def render a: no, b: no, c: no, d: no, e: no, list: null, str: null, list2: null
		# no need for nested stuff here - we're testing setStaticChildren
		# if it works on the flat level it should work everywhere
		<self>
			<el.a> name
			str
			<el.b> "ok"
			if a
				<el.header>
				<el.title> "Header"
				<el.tools>
				if b
					<el.long>
					<el.long>
				else
					<el.short>
					<el.short>
					<el.short>
				<el.ruler>
			if c
				<div.c1> "long"
				<div.c2> "loong"
			if d and e
				<el.long>
				<el.footer>
				<el.bottom>
			elif e
				<el.footer>
				<el.bottom>
			else
				<el> "!d and !e"
			list
			<el.x> "very last"
			list2


tag other

	def render
		<self> for item in items
			<li> item

tag textlist
	def render texts = []
		<self> for item in texts
			item

tag group2 < group

	def render a: no
		<self>
			if a
				<el.a>
				<el.b>
				<el.c>
			else
				<el.d>
				<el.e>

tag group3 < group

	def render a: no
		<self>
			<el.a>
			a ? "items" : "item"

tag group4 < group

	def render a: no
		<self>
			<el.a>
			if a
				"text"
			else
				<el.b>
				<el.c>

tag group5 < group

	def render a: no
		<self>
			"a"
			"b"
			a ? (<el.c> "c") : "d"

tag unknowns < div

	def ontap
		render
		setInterval(&,100) do render
		self

	def tast
		10

	def render
		<self>
			5
			Date.new.toString
			10
			"20"
			"30"
			<div.hello>
			<div.hello> <b>
			<div.int> 10
			<div.date> Date.new
			<div.str> "string"
			<div.list> list
			<div.item> tast
			<div.if>
				if true
					list
				else
					<b>
					<b>

			<div.if>
				<b>
				<b>
				tast
				<b>


	def list
		for x in [1,2,3]
			<div@{x}.x>

tag stat < group
	def render
		<self>
			<div.hello>
			<ul.other>
				<li.a>
				<li.b>
			<div.again>

describe "Tags" do

	var a = <el.a> "a"
	var b = <el.b> "b"
	var c = <el.c> "c"
	var d = <el.d> "d"
	var e = <el.e> "e"
	var f = <el.f> "f"

	var g = <el.g> "g"
	var h = <el.h> "h"
	var i = <el.i> "i"
	var j = <el.j> "j"

	var group = <group>
	document:body.appendChild(group.dom)

	# test "first render with string" do
	# 	group.render str: "Hello"
	# 	eq group.opstr, "AAAAA"

	test "first render" do
		group.render
		eq group.opstr, "AAAA"

	test "second render" do
		# nothing should happen on second render
		group.render
		eq group.opstr, ""

	test "added block" do
		group.render c: yes
		eq group.opstr, "II"

	test "remove again" do
		group.render c: no
		eq group.opstr, "RR"

	test "with string" do
		group.render str: "Hello there"
		eq group.opstr, "I"

		# changing the string only - should not be any
		# dom operations on the parent
		group.render str: "Changed string"
		eq group.opstr, ""

		# removing string, expect a single removeChild
		group.render str: null
		eq group.opstr, "R"

	test "changing conditionals" do
		group.render a: yes
		eq group.opstr, "IIIIIII"

		group.render a: yes, b: yes
		eq group.opstr, "RRRII"

	test "toplevel conditionals" do
		var node = <group2>
		node.render a: yes
		eq node.opstr, "AAA"

		node.render(a: no)
		eq node.opstr, "RRRAA"
		self

	test "conditionals with strings" do
		var node = <group3>
		node.render a: yes
		eq node.opstr, "AA"

		node.render(a: no)
		eq node.opstr, ""
		self

	test "conditionals with strings II" do
		var node = <group4>
		node.render a: yes
		eq node.opstr, "AA"

		# string should simply be replaced
		node.render(a: no)
		eq node.opstr, "RAA"
		self

	describe "group5" do

		test "conditions" do
			var node = <group5>
			document:body.appendChild(node.dom)
			node.render a: no
			eq node.opstr, "AAA"

			# string should simply be replaced
			node.render(a: yes)
			eq node.opstr, "RA"

			node.render(a: no)
			eq node.opstr, "RA"

	test "unknowns" do
		var node = <unknowns>
		document:body.appendChild(node.dom)
		node.render a: no
		# eq node.opstr, "AAA"

	describe "dynamic lists" do
		# render once without anything to reset
		var full = [a,b,c,d,e,f]

		test "last list" do
			group.render
			group.render list2: [h,i]
			eq group.opstr, "AA"

			group.render list2: [h,i,j]
			eq group.opstr, "A"

			group.render
			# render full regular again

		test "adding dynamic list items" do
			group.render list: full
			eq group.opstr, "IIIIII"

			# append one
			group.render list: [a,b,c,d,e,f,g]
			eq group.opstr, "I"
			# remove again
			group.render list: full
			eq group.opstr, "R"

			# add first element last
			group.render list: [b,c,d,e,f,a]
			eq group.opstr, "I"

			group.render list: full

		test "removing" do
			group.render list: [a,b,e,f]
			eq group.opstr, "RR"

			group.render list: full
			eq group.opstr, "II"

		test "should be reorderable" do

			group.render list: full # render with the regular list
			group.render list: [b,a,c,d,e,f]
			eq group.opstr, "I"

			# reordering two elements
			group.render list: full
			group.render list: [c,d,a,b,e,f]
			eq group.opstr, "II"

			# reordering two elements
			group.render list: full
			group.render list: [c,d,e,f,a,b], str: "Added string again as well"
			eq group.opstr, "III"

	describe "text lists" do
		var node = <textlist>
		document:body.appendChild(node.dom)

		test "render" do
			node.render(['a','b','c','d'])
			eq node.dom:textContent, 'abcd'
			node.render(['b','c','a','d'])
			eq node.dom:textContent, 'bcad'

			node.render(['b','a','a','d','a','g'])
			eq node.dom:textContent, 'baadag'
			node.render(['b','g','a','a','d','a'])
			eq node.dom:textContent, 'bgaada'


