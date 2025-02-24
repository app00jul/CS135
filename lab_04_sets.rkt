#lang eopl

#|-------------------------------------------------------------------------------
 | Name: Julian Noeske
 | Pledge: I pledge my honor that I have abided by the Stevens Honor System.
 |-------------------------------------------------------------------------------|#


#|-------------------------------------------------------------------------------|
 |                          Lab 4: Sets (20 PTS +4 EC)                           |
 |-------------------------------------------------------------------------------|#


#| In this lab, we'll implement some basic functions which operate on sets.
 | These functions will come in handy in some subsequent labs.
 | EOPL lacks a built-in set datatype, so what we call a "set" will
 |   simply be a list which we ensure contains no duplicate elements.
 | And, when interacting with a "set", we won't care about
 |   the order of elements in the underlying list.
 | So throughout this lab, we can treat a set as a list,
 |   but we can't necessarily treat a list as a set.
 | Below is a helper function you'll need to construct a set from a list.
 | It simply eliminates duplicate elements from the input list.
 |#

;; Type signature: (make-set list) -> set
(define (make-set L)
  (cond [(null? L) '()]
        [(member (car L) (cdr L)) (make-set (cdr L))]
        [else (cons (car L) (make-set (cdr L)))]))


#| As you're working on each function, consider if you can
 |   take advantage of functions you've already implemented in this file.
 | Take particular note of the type signatures of each function.
 | If the output is expecting a set, make sure your
 |   output contains no duplicate values.
 | Additionally, your functions should be able to work with sets containing any type of data.
 |   Don't worry about nested sets, though.
 |   You'll see sets containing lists, but not sets containing sets.
 |   If a set contains lists, the order of items inside of the lists must matter.
 | Unless otherwise specified, the empty set/list is valid input to each function!
 | You may assume when the type of a function's input is "set" that
 |   the input will not contain duplicates.
 |#


#| IMPORTANT NOTE!!!
 | If the output of a function is of type "set", the order of elements
 |   in the output set does NOT need to match the order shown in the expected output.
 | If the set you output contains all the same elements of the expected set
 |   and contains no duplicate values, then it is correct.
 | If the output of a function is any other type than "set",
 |   the standard rule applies that its value must precisely match
 |   the expected output to be marked as correct.
 |#


#|-------------------------------------------------------------------------------|
 |                  Part 1: Unary Set Operations (6 PTS +4 EC)                   |
 |-------------------------------------------------------------------------------|#

#| First, we'll implement functions which operate on one set.
 | Some functions may require recursion; others may not.
 |#


#| Implement "element?" to accept a set S and an element e
 |   and return #t if e is an element of S, and #f otherwise.
 | Use Racket's "equal?" function to compare data of arbitrary types.
 |
 | Examples:
 |   (element? '() 0)                     -> #f
 |   (element? '(7 8 9) 8)                -> #t
 |   (element? '("a" "b" "c") "ab")       -> #f
 |   (element? '(the man saw a dog) 'saw) -> #t
 |   (element? '((1 2) (3 4)) '(1 2))     -> #t
 |#

;; Type signature: (element? set any) -> boolean
;; 2 PTS
(define (element? S e)
  (cond [(null? S) #f]
        [(equal? (car S) e) #t]
        [else (element? (cdr S) e)]
    )
  )




#| Implement "insert" to accept a set S and an element e,
 |   and return the set of e and all the elements of S.
 | If S already contains e, the resultant set
 |   should not have any new elements.
 | Remember, the order of elements in the resultant set
 |   does not need to match the output shown below.
 |
 | Examples:
 |   (insert '(1 2 3) 0)            -> (0 1 2 3)
 |   (insert '(1 2 3) 1)            -> (1 2 3)
 |   (insert '("ab" "cd" "ba") "a") -> ("a" "ab" "cd" "ba")
 |   (insert '((y) (x z)) '(x y z)) -> ((y) (x z) (x y z))
 |#

;; Type signature: (insert set any) -> set
;; 2 PTS
(define (insert S e)
  (cond [(element? S e) S]
        [else (append S (list e))]
    )
  )




#| Implement "remove" to accept a set S and element e,
 |   and return the set of all elements in S except for e.
 | If e is not an element of S, the resultant set
 |   should be equivalent to S.
 |
 | Examples:
 |   (remove '(1 2 3) 2)          -> (1 3)
 |   (remove '(1 2 3 4) 3)        -> (1 2 4)
 |   (remove '("ab" "c") "a")     -> ("ab" "c")
 |   (remove '((x y z) (z)) '(x)) -> ((x y z) (z))
 |   (remove '((x y z) (z)) '(z)) -> ((x y z))
 |#

;; Type signature: (remove set any) -> set
;; 2 PTS
(define (remove S e)
  (cond [(element? S e)
                       (cond [(equal? e (car S)) (cdr S)]
                             [else (remove (cdr (append S (list (car S)))) e)])
        ]
        [else S]
    )
  )





#| Implement "cardinality" to accept a list L
 |   and return |L|, or the number of *unique*
 |   element in L.
 | Examples:
 |   (cardinality '(1 2 3))                   -> 3
 |   (cardinality '(1 1 2 3 3))               -> 3
 |   (cardinality '(a a a))                   -> 1
 |   (cardinality '((x y z) (x) (x y) (x z))) -> 4
 |#

;; Type signature: (cardinality list) -> int
;; 2 PTS
(define (cardinality L)
  (length (make-set L))
  )




#| EXTRA CREDIT:
 | Implement "powerset" to accept a set S and return P(S),
 |   or the powerset of S.
 | P(S) is a set which contains every possible subset of S, including S.
 | This one is pretty challenging to implement!
 |
 | Hints:
 |   EOPL's "map" function may come in handy.
 |   You may want to use let-binding to reduce computation time.
 |   Consider writing helper functions or lambda functions.
 |
 | Because the output is a set of sets, the order of all the subsets,
 |   and the order of items in each subset, are arbitrary.
 |
 | Examples:
 |   (powerset '())            -> (())
 |   (powerset '(1))           -> (() (1))
 |   (powerset '(1 2))         -> (() (1) (2) (1 2))
 |   (powerset '(a b c)        -> (() (a) (b) (c) (a b) (a c) (b c) (a b c))
 |   (powerset '((A B) (C D))) -> (() ((C D)) ((A B)) ((A B) (C D)))
 |     -- In the above case, A needs to precede B and C needs to precede D,
 |        because we interpret (A B) and (C D) as ordered lists.
 |#

;; Type signature: (powerset set) -> set-of-sets
;; 4 EC PTS
(define (powerset S)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                     Part 2: Binary Set Operations (14 PTS)                    |
 |-------------------------------------------------------------------------------|#

#| Now we'll implement functions which operate on two sets.
 | Some functions may require recursion; others may not.
 |#


#| Implement "union" to accept sets S1 and S2 and return S1 ⋃ S2,
 |   or the set of all elements which are in S1 or in S2.
 | Examples:
 |   (union '(1 2 3) '(4 5 6))         -> (1 2 3 4 5 6) 
 |   (union '(c b f d) '(b c a))       -> (a b c d f)
 |   (union '("abc") '())              -> ("abc")
 |   (union '((z) (x y)) '((y x) (z))) -> ((z) (x y) (y x))
 |#

;; Type signature: (union set set) -> set
;; 2 PTS
(define (union S1 S2)
  (cond [(null? S1) S2]
        [(null? S2) S1]
        [else (make-set(append S1 S2))]
    )
  )




#| Implement "intersection" to accept sets S1 and S2 and return S1 ⋂ S2,
 |   or the set of all elements which are in S1 and in S2.
 | You may want to write a helper function for this one!
 |
 | Examples:
 |   (intersection '(1 2 3 4) '(2 4 5))         -> (2 4)
 |   (intersection '(s a n d e p) '(b h a t))   -> (a)
 |   (intersection '("abc") '("ab"))            -> ()
 |   (intersection '((x y) (z)) '((x y) (y x))) -> ((x y))
 |#

;; Type signature: (intersection set set) -> set
;; 4 PTS
(define (intersection S1 S2)
  (cond [(null? S1) '()]
        [(null? S2) '()]
        [(element? S1 (car S2)) (append (list (car S2)) (intersection S1 (cdr S2)))]
        [else (intersection S1 (cdr S2))]
    )
  )




#| Implement "disjoint" to accept sets S1 and S2 and return
 |   whether S1 and S2 are disjoint (in other words, whether
 |   they share no elements in common).
 |
 | Examples:
 |   (disjoint? '(1 2 3) '())          -> #t
 |   (disjoint? '(a b c) '(b))         -> #f
 |   (disjoint? '((x z)) '((x y) (z))) -> #t
 |#

;; Type signature: (disjoint? set set) -> boolean
;; 1 PTS
(define (disjoint? S1 S2)
  (cond [(null? (intersection S1 S2)) #t]
        [else #f]
    )
  )




#| Implement "subset?" to accept sets S1 and S2 and return S1 ⊆ S2.
 | In other words, it returns #t if S1 is a subset of S2 (or the same as S2),
 |   and #f otherwise.
 | In other-other words, it returns #t if every element in S1 is also in S2.
 |
 | Examples:
 |   (subset? '() '())               -> #t
 |   (subset? '(1 2 3) '(4 1 3 5 2)) -> #t
 |   (subset? '(b a c) '(d f e a g)) -> #f
 |   (subset? '(1 3 2) '(3 2 1))     -> #t
 |#

;; Type signature: (subset? set set) -> boolean
;; 4 PTS
(define (subset? S1 S2)
  (cond [(equal? (length S1) (length (intersection S1 S2))) #t]
        [else #f]
    )
  )



#| Implement "set-equal?" to accept sets S1 and S2 and return whether S1 and S2 are equal
 |   (in other words, all elements of S1 are in S2 and all elements of S2 are in S1).
 | Recall that two sets with the same elements but in a different order
 |   are still equivalent to one another.
 |
 | Examples:
 |   (set-equal? '() '())                           -> #t
 |   (set-equal? '(a b c) '(a b c))                 -> #t
 |   (set-equal? '(1 2 3 4) '(4 3 1 2))             -> #t
 |   (set-equal? '("c" "b" "d" "a") '("a" "c" "b")) -> #f
 |#

;; Type signature: (set-equal? set set) -> boolean
;; 1 PTS
(define (set-equal? S1 S2)
  (cond [(not (equal? (length S1) (length S2))) #f]
        [(subset? S1 S2) #t]
        [else #f]
        )
  )
