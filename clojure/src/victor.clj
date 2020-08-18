(ns victor)

; Some Examples:

(defn square [x] (* x x))

(defn larger [a b] 
	(if (> a b)
		a
		b
	)
)

(defn mystery [x]
	(cond 
		(= x 0) "Zero is my hero!"
		(= x 2) "First prime number!"
		(= x 7) "Lucky!"
		(= x 13) "Unlucky!"
		:else (* (+ x 5) -2)
	)
)

(defn abs [x] ((if (> x 0) + - ) 0 x))

; Exercises:

; Write a function called divby3 that takes a number and returns
;	true if it is divisible by three and false otherwise.

(defn divby3 [x] 
	(def remain (mod x 3))
	(= 0 remain)
)


; Write a function called almost20 that takes one number as input,
;   and returns true if the given non-negative number is 1 or 2 less 
;   than a multiple of 20. So for example 38 and 39 return true, 
;   but 40 returns false.

(defn almost20 [x]
	(def remain (mod x 20))
	(or (= 18 remain) (= 19 remain))
)


; Write a function called love6 that takes two int values, and returns
;   true if either one is 6. Or if their sum or difference is 6.
(defn love6 [a b]
	(or (= a 6) (= b 6) (= 6 (+ a b)) (= 6 (- a b)) (= 6 (- b a)))
)


; Write a function called sumProd that takes two numbers as inputs and
;	returns a string with the sum and product of those numbers with 
;	a space in between.
(defn sumProd [a b]
 (str (+ a b) " " (* a b))
)


; Write a function called squareFacts that takes the side length as an 
; 	input and returns a string with the area, the perimeter, and the
;   length of the diagonal of the square. NOTE: you can access java
;   math functions such as sqrt with 'Math/sqrt'.

(defn squareFacts [a]
	(str (* a a )  " " (* 4 a) " " (* a (Math/sqrt 2)))
)


; Write a function called second that returns the second item in a list

(defn secundus [ x ] 
	(first (rest x))
)

; Write a function called third that returns the third item in a list.
(defn tertius [ x ]
	(first (rest (rest x)))
)

; Write a function called sign that takes a number as an argument and
;   returns 1 if the number is positive, -1 if the number is negative, 
;   and 0 if the number is 0.
(defn sign [x]
	(cond 
		(> x 0) 1
		(> 0 x) -1
		(= 0 x) 0
	)
)


; Write a function called sumSquares that takes three numbers as arguments 
;   and returns the sum of the squares of the two larger numbers.

(defn sumSquares [ a b c ]
	(cond
		(and (> b a) (> c a)) (+ (* b b) (* c c))
		(and (> b c) (> a c)) (+ (* b b) (* a a))
		:else (+ (* c c) (* a a))
	)
)

; Write a function called quadRoots that takes in the three coefficients
;   of a quadratic equation and returns either 'two real roots', 
;   'one real root', or 'two imaginary roots'

(defn quadRoots [ a b c]
	(def discr (- ( * b b) (* 4 a c)))
	(cond 
		(= discr 0) "one real root"
		(> discr 0) "two real roots"
		:else "two imaginary roots"
	)

)

; Throwback Thursday:

; Write a function called quadrant that takes x and y coordinates 
;	and returns what quadrant the point is in (as a string), including 
;	the special cases of the origin, x-axis, and y-axis.

(defn quadrant [x y]
	(cond 
		(and (> x 0) (> y 0)) "first quadrant"
		(and (> x 0) ( < y 0)) "fourth quadrant"
		(and (< x 0) (> y 0)) "second quadrant"
		(and (< x 0) (< y 0)) "third quadrant"
		(and (= x 0) (= y 0)) "origin"
		(= x 0) "y-axis"
		:else "x-axis"
	)
)


; Write a function called craps that takes two rolls of the dice 
;   (numbers from 2-12) and decides if you win or lose at the dice game 
;   of craps. Reminder about how the game will be played:
;   On the first roll:
;      7 or 11: Player wins. Game over.
;      2, 3, or 12: Player loses. Game over.
;      Otherwise: Look at the second roll:
;          Same number as on the first roll: Player wins
;          7: Player loses
;          Otherwise: We’ll call it a tie.
; Your function should return 'win', 'lose', or 'tie'.
(defn craps [ a b ]
	(cond
		(or (= a 7) (= a 11)) "win"
		(or (= a 2) (= a 3) (= a 12)) "lose"
		(= a b) "win"
		(= b 7) "lose"
		:else "tie"
	)

)


(defn -main [& args]
	;put your test code here
	(println (craps 11 9))
	(println (craps 7 7))
	(println (craps 12 10))
)