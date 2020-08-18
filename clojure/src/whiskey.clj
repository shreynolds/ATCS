(ns whiskey)

; Some Examples:

(defn makelist [n]
	(cons n '())
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


;List Exercises!  

; Write a function called repeat2 that takes one input and returns a 
;   list containing two copies of the argument. 
;   Example: (repeat2 4) returns (4 4)
(defn repeat2 [n]
	(cons n (cons n '()))
)

; Write a function called repeat3 that takes one input and returns a list
;   containing three copies of the argument. 
;   Example: (repeat3 4)  returns (4 4 4)
(defn repeat3 [n]
	(cons n (repeat2 n))
)

; Write a generalized function called repeat that takes two inputs and
;   returns a list containing the second argument number of copies of the 
;   first argument. Example: (repeat 4 3)  returns (4 4 4)
(defn repeater [a b]
	(defn repeat-iter [a b list]
		(if (= b 0)
			list
			(repeat-iter a (- b 1) (cons a list))
		)

	)
	(repeat-iter a b '())
)

; Rewrite repeat2 and repeat3 so they use repeat

(defn repeat2 [n]
	(repeater n 2))

(defn repeat3 [n]
	(repeater n 3))


; Write a function called make-repeat that takes one paramenter and returns
;   a function with one parameter that returns a list containing its 
;   argument repeated the number of times equal to the input to make-repeat.
;   Example: ((make-repeat 3) 4) returns (4 4 4)
(defn make-repeat [n]
	(fn [j] (repeater j n))
)


; Write a function count-up-to that takes one argument, a positive
;   number, and returns a list of the positive numbers from 1 to the 
;   argument. Example: (count-up-to 4) returns (1 2 3 4)
(defn count-up-to [n]
	(defn count-iter [n list]
		(if(= n 1)
			(cons 1 list)
			(count-iter (- n 1) (cons n list))
		)
	)
	(count-iter n '())
)



; Write a function count-down-from that takes one argument, a positive
;   number, and returns a list of the positive numbers from the argument 
;   to 1. Example: (count-down-from 4) returns (4 3 2 1)

(defn count-down-from [n]
	(defn count-down-iter [counter n list]
		(if (= n counter)
			(cons counter list)
			(count-down-iter (+ counter 1) n (cons counter list))
		)
	)
	(count-down-iter 1 n '())
)

; If your unction count-down-from was recursive, write an iterative 
;   solution, and vice versa.

(defn count-down-from [n]
	(if (= n 0)
		'()
		(cons n (count-down-from (- n 1)))
	)
)


; Write a function add-items that takes a list of numbers and returns the
;   sum of the elements. Example: (add-items (list 2 5 4)) returns 11
(defn add-items [list]
	(defn add-iter [list sum]
		(if (= (first list) nil)
			sum
			(add-iter (rest list) (+ sum (first list)))
		)
	)
	(add-iter list 0)
)


; Write a function add-squares that takes a list of number and returns the
;   sum of the squares of the elements of the list. 
;   Example: (add-squares (list 2 5 4)) returns 45

(defn add-squares [list]
	(defn add-squares-iter [list sum]
		(if (= (first list) nil)
			sum
			(add-squares-iter (rest list) (+ sum (* (first list) (first list))))
		)
	)
	(add-squares-iter list 0)
)

; Write a function add-transformed that is a generalization of add-items 
;   and add-squares. It should take as arguments both a list of numbers and
;   a function and should return the sum of the results of applying the 
;   function to each number in the list. 
;   Example (add-transformed (list 2 5 4) square) returns 45.
(defn add-transformed [list funct]
	(defn add-transformed-iter [list funct sum]
		(if (= (first list) nil)
			sum
			(add-transformed-iter (rest list) funct (+ sum (funct (first list))))
		)
	)
	(add-transformed-iter list funct 0)
)


; Rewrite add-items using add-transformed.
(defn add-items [list]
	(add-transformed list (fn [x] x))

)

; Write a function double-all that takes a list of numbers and returns a
;   list of the given numbers multiplied by 2. 
;   Example (double-all (list 4 0 -3)) returns (8 0 -6)

(defn double-all [list]
	(if (= nil (first list))
		'()
		(cons (* 2 (first list)) (double-all(rest list)))

	)
)


; Write a more generalized function mul-all that takes the number by which
;   to multiply as a parameter in addition to the list of numbers to be 
;   multiplied. Example: (mul-all (list 4 0 -3) 2) returns (8 0 -6)

(defn mul-all [list times]
	(if (= nil (first list))
		'()
		(cons (* times (first list)) (mul-all (rest list) times))
	)
)


; Write a function delete that takes a number and a list of numbers and
;   returns a list with all instances of the given number removed. 
;   Example: (delete 1 (list 4 1 4 2 1 3)) returns (4 4 2 3)
(defn delete [num list]
	(if (= nil (first list))
		'()
		(if (= (first list) num)
			(delete num (rest list))
			(cons (first list) (delete num (rest list)))
		)
	)
)


(defn -main [& args]
	;put your test code here
	(println (delete 4 (list 4 0 -3)))
	(println (delete 1 '(7 3 1 2 1 7 9 8 1))) 
)