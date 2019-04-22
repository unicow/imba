extern describe, test, ok, eq, it

class A
	
	prop a
	prop b
	prop c
	prop d
	prop e
	prop f

	def initialize a,b
		@a = a
		@b = b
		@c = 1
		@d = 1
		@e = 1
		@f = 1

	def call fn
		var other = A.new(2,2)
		fn.call(other)
		self

	def test
		var res = [a,this.a]
		call do
			res.push a
			res.push this.a
			# loops create their own scope, but should still
			# have the outermost closed scope as their implicit context
			for x in [1]
				res.push(a)
				res.push(this.a)
		return res

	def innerDef
		var ary = []

		# def inside a method scope creates a local function
		# which is implicitly called.

		def recur i
			ary.push(i)
			recur(i + 1) if i < 5

		recur(0)
		eq ary, [0,1,2,3,4,5]

		var k = 0
		def implicit
			ary.push(k)
			implicit if ++k < 6

		implicit
		eq ary, [0,1,2,3,4,5,0,1,2,3,4,5]


	def letVar
		var ary = [1,2,3]
		var a = 1
		var b = 1
		var len = 1
		var i = 1
		var v = 1

		for v,i in ary
			v + 2
			i

		eq i,1

		if true
			for v,i in ary
				i
			eq i,1

		var r = for v in ary
			v

		r:length

		for v in ary
			let l = 1
			let a = 2
			let b = 2
			let c = 2
			let h = 0
			a + b + c

		for v in ary
			let a = 3
			let b = 3
			let c = 3
			f

		if true
			let a = 4
			let b = 4
			let i = 0
			let len = 10

			if true
				let a = 5
				let b = 5

			let e = for v,i in ary
				eq a,4
				i

			eq a,4
			eq i,0
		else
			let a = 4, b = 4, d = 4
			true

		var z = if 1
			for v in ary
				yes
			4
		else
			5

		eq v,1
		eq i,1
		eq len,1
		eq a + b + c + d + e + f, 6
		return

	def letIf
		var v = 2

		if let v = 3
			eq v,3

		eq v,2

		if let a = 2
			eq a, 2

		eq a,1

	def letShadow
		let v = 1
		if true
			let v = v * 2
			eq v, 2
		eq v, 1

		if true
			let c = c * 2
			eq c, 2

	def letSwitch val = 10
		let x = val
		let y = 20

		switch x
			when 10
				let y = 30
				let z = 30
				eq y, 30
			when 20
				let y = 40
				let z = 40
				eq z, 40

		eq y, 20



	def varShadow
		var x = 10
		var y = do
			var x = x * 2
			eq x, 20

		y()

	def caching

		if var f = f
			eq f, @f
		else
			eq 1, 0
		self
		
# console.log A.new.test
		

describe "Syntax - Scope" do
	var item = A.new(1,1)

	test "nested scope" do
		var obj = A.new(1,1)
		var res = obj.test
		eq res, [1,1,1,2,1,2]

	test "def inside method" do
		item.innerDef

	test "let" do
		

	test "class" do
		var x = 10
		class A
			var x = 20

			def test
				eq x, 20
				x += 10
				eq x, 30

		eq x, 10
		A.new.test
		eq x, 10

	test "let" do
		item.letVar
		item.letIf
		item.letShadow
		item.letSwitch(10)
		item.letSwitch(20)

		var a = 0
		if true
			let a = 1
			eq a, 1
		eq a, 0

	test "var shadowing" do
		item.varShadow

	test "caching" do
		A.new.caching

