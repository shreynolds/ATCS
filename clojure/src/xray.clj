(ns xray)

; Some Examples:

(defn makelist [n]
	(cons '() n)
)

(defn factorial [n]
	(if (<= n 1)
		1
		(* n (factorial (- n 1))) ; You can also do (dec n) here.
	)
)

(defn ifactorial [n]
	(defn ifactorial-iter [num product]
		(if (<= num 1)
			product
			(ifactorial-iter (- num 1) (* product num))
		)

	)
	(ifactorial-iter n 1)
)

; Exercises:

; Write a function called enth that returns the nth item in a list.
(defn enth [n list]
	(defn enth-iter [n list count]
		(if (= count n)
			(first list)
			(enth-iter n (rest list) (+ count 1))
		)

	)
	(enth-iter n list 1)
)


; Write a function last-item that returns the list that contains only the 
;   last element of a given list. Example: (last-item (list 23 72 149 34))
;   returns (34)

(defn last-item [list]
	(if (= (rest list) '())
		(first list)
		(last-item (rest list))
	)
)


; Write a function called backwardList that returns a list that is the
;   reverse of the input list.

(defn backwardList [list]
	(defn backward-iter [inputList end]
		(if (= nil (first inputList))
			end
			(backward-iter (rest inputList) (cons (first inputList) end))

		)
	)
	(backward-iter list '())
)


; Write a variation on the function add-transformed called sum that takes 
;   two numbers, a function that computes the next value on the way from 
;   the first number to the second number, and a function that transforms
;   the each of the numbers.

; 1 4 inc sqaure --> 1 sqared + 2 sqared + 3 squared + 4 squared


(defn sum [ a b next transformer]
	(if (> a b)
		0
		(+ (transformer a) (sum (next a) b next transformer))
	)
)


; Write an analogous procedure called product that returns the product 
;   of the values of a function at points over a given range. Show 
;   how to define factorial in terms of this new function.
(defn product [ a b next transformer]
	(if (> a b)
		1
		(* (transformer a) (product (next a) b next transformer))
	)

)

(defn factorial [num]
	(product 1 num (fn [x] (+ x 1)) (fn [x] x))
)


; If your product function generates a recursive process, write one
;   that generates an iterative process. Or vice versa.
(defn product [ a b next transformer]
	(defn product-iter [a b next transformer prod]
		(if (> a b)
			prod
			(product-iter (next a) b next transformer (* prod (transformer a)))
		)
	)
	(product-iter a b next transformer 1)
)



; Sum and product are both special cases of a still more general 
;   notion called accumulate that combines a collection of terms, 
;   using some general accumulation function:
;      (accumulate a b next transformer combiner null-value)
;   Accumulate takes as arguments the same transformer and range 
;   specifications as sum and product, together with a combiner 
;   procedure (of two arguments) that specifies how the current 
;   term is to be combined with the accumulation of the preceding
;   terms and a null-value that specifies what base value to use 
;   when the terms run out. Write accumulate and show how sum and 
;   product can both be defined as simple calls to accumulate.
(defn accumulate [a b next transformer combiner null-value]
	(if (> a b)
		null-value
		(combiner (transformer a) (accumulate (next a) b next transformer combiner null-value))
	)
)

(defn sum [ a b next transformer]
	(accumulate a b next transformer (fn [x y] (+ x y)) 0)
)

(defn product [ a b next transformer]
	(accumulate a b next transformer (fn [x y] (* x y)) 1)
)


; If your accumulate procedure generates a recursive process, write
;   one that generates an iterative process. If it generates an 
;   iterative process, write one that generates a recursive process.
(defn accumulate [ a b next transformer combiner null-value]
	(defn accumulate-iter [a b next transformer combiner total]
		(if (> a b)
			total
			(accumulate-iter (next a) b next transformer combiner (combiner total (transformer a)))
		)
	)
	(accumulate-iter a b next transformer combiner null-value)
)


; You can obtain an even more general version of accumulate by 
;   introducing the notion of a filter on the terms to be combined.
;   That is, combine only those terms derived from values in the 
;   range that satisfy a specified condition. The resulting 
;   filtered-accumulate abstraction takes the same arguments as 
;   accumulate, together with an additional predicate of one argument
;   that specifies the filter. Write filtered-accumulate as a procedure. 
(defn filtered-accumulate [a b next transformer combiner null-value filter]
	(if (> a b)
		null-value
		(if (filter a)
			(combiner (transformer a) (filtered-accumulate (next a) b next transformer combiner null-value filter))
			(combiner null-value (filtered-accumulate (next a) b next transformer combiner null-value filter))
		)
	)
)

; Use filtered-accumulate to write a function that computes the following:
; a. the sum of the squares of the even numbers in the interval a to b.
(defn sumsquares [ a b]
	(filtered-accumulate a b (fn [x] (+ x 1)) (fn [y] (* y y)) (fn [a b] (+ a b)) 0 (fn [z] (= 0 (mod z 2))))
)


; b. the product of all the positive integers less than n that aren't 
;	 multiples of the first five primes. NOTE: you may need to write a
;    helper 'mostly not prime' function.

;the first five primes are 2, 3, 5, 7, 11
;mostly prime: the first five primes and anything that is not a multiple of the first five primes

(defn mostlyprime [num] 
(defn mp_iter [num primelist] 
(if (= (first primelist) nil) 
true 
(let [prime (first primelist)] 
(if (and (= 0 (mod num prime)) (> (/ num prime) 1)) 
false 
(mp_iter num (rest primelist)) 
) 
) 
) 
) 
(mp_iter num '(2 3 5 7 11)) 
)



(defn primeproduct [n]
	(filtered-accumulate 1 n (fn [x] (+ x 1)) (fn [y] y) (fn [a b] (* a b)) 1 (fn [z] (mostlyprime z)))
)

; Write a function double that takes a function of one argument as an input
;    and returns a function that applies the original procedure twice.
;    For example, if inc is a procedure that adds 1 to its argument, 
;    then (double inc) should be a procedure that adds 2. Record your 
;    prediction for what value is returned by:
;      (((double (double double)) inc) 5) -- 9 is my prediction, but it was  21
;    and then calculate it with your function.
(defn double [infunc]
	(fn [x] (infunc(infunc x)))
)


;methods increment and square for testing
(defn incr [x]
	(+ x 1)
)

(defn square [x]
	(* x x)
)

; Write a function compostion that takes two one-argument functions as inputs
;   (let's call them f and g for example) and returns a one-argument function
;   that is the composition f(g(x)). For example, if inc is a procedure that 
;   adds 1 to its argument, ((compose square inc) 6) returns 49.

(defn compose [f g]
	(fn [x] (f(g x)))
)


; If f is a numerical function and n is a positive integer, then we can form
;    the nth repeated application of f, which is defined to be the function
;    whose value at x is f(f(...(f(x))...)). For example, if f is the 
;    function x = x + 1, then the nth repeated application of f is the 
;    function x = x + n. If f is the operation of squaring a number, then 
;    the nth repeated application of f is the function that raises its 
;    argument to the (2n)th power. Write a function that takes as inputs a 
;    function that computes f and a positive integer n and returns the 
;    function that computes the nth repeated application of f. 
;    Your function should be able to be used as follows:
;       ((repeated square 2) 5) would return 625
;    Hint: You may find it convenient to use compose from above.
(defn repeated [func n]
	(if (= n 2)
		(compose func func)
		(compose func (repeated func (- n 1)))
	)
)


(defn -main [& args]
	;put your test code here
	;(println (product 1 4 (fn [x] (+ x 1)) (fn [y] y)))
	;(println (factorial 5))
	;(println (accumulate 1 8 (fn [x] (+ x 1)) (fn [y] y) (fn [a b] (+ a b)) 0))

	(println ((double incr) 5))
	(println ((repeated incr 10) 5))
	(println (primeproduct 7))
)
