(ns whiskey)

; Some Examples:

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

(defn goThrough [n list count]
	(if (= n count)
		(first list)
		(goThrough n (rest list) (+ count 1))
	)
)

(defn enth [n list]
	(goThrough n list 1)
)


; Write a function called backwardList that returns a list that is the
;   reverse of the input list.

(defn backwardList [outputList inputList]
	(if (= (first inputList) nil)
		outputList
		(backwardList (cons (first inputList) outputList) (rest inputList) )
	)
)


; Write a function called sumList that returns the sum of the 
;   inputted list.





; Write a function called sumNums that takes two numbers as inputs
;   and returns the sum of all of the numbers from the first to the
;   second, inclusive.



; Write a function called sumSquares that takes two numbers as 
;   inputs and returns the sum of the squares of all of the numbers 
;   from the first to the second, inclusive.



; Write a function called sum that takes two numbers and a third 
;   input and returns the sum of whatever done to all of the numbers
;   from the first to the second inputed number, inclusive.



; If your previous function was recursive, write an iterative version.
;   If iterative, write a resursive one!


; Write an analogous procedure called product that returns the product 
;   of the values of a function at points over a given range. Show 
;   how to define factorial in terms of this new function.



; If your product function generates a recursive process, write one
;   that generates an iterative process. Or vice versa.



; Sum and product are both special cases of a still more general 
;   notion called accumulate that combines a collection of terms, 
;   using some general accumulation function:
;      (accumulate combiner null-value term a next b)
;   Accumulate takes as arguments the same term and range 
;   specifications as sum and product, together with a combiner 
;   procedure (of two arguments) that specifies how the current 
;   term is to be combined with the accumulation of the preceding
;   terms and a null-value that specifies what base value to use 
;   when the terms run out. Write accumulate and show how sum and 
;   product can both be defined as simple calls to accumulate.



; If your accumulate procedure generates a recursive process, write
;   one that generates an iterative process. If it generates an 
;   iterative process, write one that generates a recursive process.



; You can obtain an even more general version of accumulate by 
;   introducing the notion of a filter on the terms to be combined.
;   That is, combine only those terms derived from values in the 
;   range that satisfy a specified condition. The resulting 
;   filtered-accumulate abstraction takes the same arguments as 
;   accumulate, together with an additional predicate of one argument
;   that specifies the filter. Write filtered-accumulate
;as a procedure. Show how to express the following using filtered-accumulate:

;a. the sum of the squares of the prime numbers in the interval a to b (assuming
;that you have a prime? predicate already written)

;b. the product of all the positive integers less than n that are relatively
;prime to n (i.e., all positive integers i < n such that GCD(i,n) = 1).



;Exercise 1.34.  Suppose we define the procedure

; (defn f [g]
;   (g 2))

;Then we have

;(f square)
;4

;(f #(* % (+ % 1)))
;6
; or less ninja way:  (f (fn [x] (* x (+ x 1))))

;What happens if we (perversely) ask the interpreter to evaluate the combination
;(f f)? Explain.




;Exercise 1.41.  Define a procedure double that takes a procedure of one argument
;as argument and returns a procedure that applies the original procedure twice.
;For example, if inc is a procedure that adds 1 to its argument, then (double
;inc) should be a procedure that adds 2. What value is returned by

;(((double (double double)) inc) 5)



;Exercise 1.42.  Let f and g be two one-argument functions. The composition f
;after g is defined to be the function x  f(g(x)). Define a procedure compose
;that implements composition. For example, if inc is a procedure that adds 1 to
;its argument,

;((compose square inc) 6)
;49



;Exercise 1.43.  If f is a numerical function and n is a positive integer, then
;we can form the nth repeated application of f, which is defined to be the
;function whose value at x is f(f(...(f(x))...)). For example, if f is the
;function x   x + 1, then the nth repeated application of f is the function x   x
;+ n. If f is the operation of squaring a number, then the nth repeated
;application of f is the function that raises its argument to the 2nth power.
;Write a procedure that takes as inputs a procedure that computes f and a
;positive integer n and returns the procedure that computes the nth repeated
;application of f. Your procedure should be able to be used as follows:

;((repeated square 2) 5) 
;625

;Hint: You may find it convenient to use compose from exercise 1.42.


(defn -main [& args]
	;put your test code here
	(println(backwardList '( ) '(1 2 3 8 5)))
)
