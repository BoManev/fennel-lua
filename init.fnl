(fn print-and-add [a b c]
  (print a)
  (+ b c))

(print-and-add 10 5 2)
;; no arity
(print-and-add 10 5 2 7)

(λ print-calc [x ?y z] (print (- x (* (or ?y 1) z))))
;; airty 
(print-calc 5)
(print-calc 5 nil 2)

;; lex scoping
(let [x (+ 89 5.2)
      f (fn [abc] (print (* 2 abc)))]
  (f x))

;; file scoping
(local tau-approx 6.28318)
(print tau-approx)
;; immutable
(set tau-approx 10)

;; immutable
(let [x 19]
  ;; shadow
  (let [x 88]
    (print (+ x 2)))
  (print x))

;; mutable
(var x 19)
(set x (+ x 18))
(print x)

;; double-precision (lua 5.1)
(print (/ 5 2))
;; integer dvision (lua 5.3)
(print (// 5 2))

(let [x (+ 1 99)
      y (- x 12)
      z 100_000]
  (+ z (/ z 10)))

(.. "hello" "world")

;; lua table
{"key1" 1 2 "value2"}
;; sequential table (start at 1)
["a" "b" 1]

(let [tbl {}
      key1 "some string"
      key2 12]
  (tset tbl key1 "value1")
  (tset tbl key2 "value2")
  tbl
  (. tbl key1)
  (. tbl "some string"))

(local seqtbl ["a" "b" "c" "d"])
;; pop
(table.remove seqtbl)
;; push
(table.insert seqtbl 1)
;; insert at index 1
(table.insert seqtbl 1 "prefix")
;; remove at index
(table.remove seqtbl 1)

(print seqtbl)
(print (vim.inspect seqtbl))

(let [tbl ["abc" "b" "c"]]
  (+ (length tbl)
     (length (. tbl 1))))

;; pairs for tables (all key iter)
(each [key value (pairs {"key1" 52 "key2" 99})]
  (print key value))

;; ipars for seq table (numberic key iter)
(each [index value (ipairs ["a" "b" "c"])]
  (print index value))

;; can be used for tables (numebric key iter until first non-numberic)
(each [key value (ipairs { 1 52 "key2" 99 3 "value3"})]
  (print key value))

(print (tonumber "x"))

;; string iter
(var sum 0)
(each [digits (string.gmatch "244 122 xx 163" "%d+")]
  (set sum (+ sum (tonumber digits))))
(print sum)

;; create a table
(collect [_ s (ipairs [:hello :yeet :world])]
  s (length s))

;; create  a seq table
(icollect [_ s (ipairs [:hello :yeet :world])]
  (if (not= :yeet s)
      (s:upper)))

(for [i 1 10]
  (print i))

(for [i 1 10 2]
  (print i))


(let [x (math.random 64)]
  (if (= 0 (% x 2))
      (print "even")
      (= 0 (% x 9))
      (print "mod 9")))

(when (= 10 10)
  (print "1st effect")
  (print "2nd effect, no else"))

;; string :shorthand (no spaces or reserved)
(let [tlb {:Y 700
          :G 200
          :C 300
          :T 240
          :I (- (. tlb Y))
          :S (- Y G C)
          :PrS (- Y C T)
          :PubS (- T G)}]
  (print (= S (+ PrS PubS))))

;; for string keys (:shorthand)
(let [tbl {:x 52 :y 91}]
  (+ tbl.x tbl.y))

;; also with set
(let [tbl {}]
  (set tbl.one 1)
  (set tbl.two 2)
  tbl)

;; variable name as key
(let [one 1 ten 10
  tbl {: one : ten }]
  tbl)

;; nil is absence of value !

;; positional deconstruction
(let [data [1 2 3]
      [st nd rd] data]
  (print st nd rd))

;; key deconstruction
(let [pos {:x 23 :y 42}
      {:x x-pos :y y-pos} pos]
  (print x-pos y-pos))

;; extra values are discarded
;; missing values are nil
(let [f (fn [] ["a" "b" {:x "xx" :y "yy"}])
        [a d {:x x :y y}] (f)]
  (print a d)
  (print x y))

;; functions can return MULTIPLE values

;; pcall - protected call (similar to wrapping a function in try/catch)
(let [(ok? val-or-msg) (pcall can-error-out filename)]
  (if ok?
      (print "Get value" val-or-msg)
      (print "Get error:" val-or-msg))) 

;; assert errors out if value is nil
;; if io.open returns nil, assert error out
(let [f (assert (io.open filename))
        contents (f.read f "*all")]
  (f.close f)
  contents)

;; variadic functions
;; ... expands to multiple values inline
;; destruct or wrap in a table literatel ([...]) and index like a table
(fn print-each [...]
  (each [i v (ipairs [...])]
    (print (.. "Argument " i " is " v))))

(print-each :a :b :c)

;; or use select
;; "#" number of args
(fn myprint [prefix ...]
  (print prefix)
  (print (.. (select "#" ...) " arguments given: "))
  (print ...))

(myprint ":D " :d :e :f)

