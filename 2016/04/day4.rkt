#lang racket

; String => String
; Returns a string of the 5 mostly used chars from the input.
(define (line->top-5-chars line)
  (let
      ; Char, List of (Char, Number) => List of (Char, Number)
      ([count-char (λ (chr lst)
                     (let ([charEle
                            (memf (λ (tuple)
                                    (eq? (car tuple) chr))
                                  lst)])
                       (if (list? charEle)
                           (map (λ (tuple)
                                  (if (eq? (car tuple) chr)
                                      (list (car tuple) (add1 (cadr tuple)))
                                      tuple))
                                lst)
                           (cons (list chr 1) lst))))]
       ; List of (Char, Number) => String
       [tuple-list->string (λ (tuple-list)
                             (list->string
                              (map (λ (x) (car x)) tuple-list)))])
    (tuple-list->string
     (take (sort (sort (foldl count-char '() (string->list line))
                       (λ (x y) (char>=? (car x) (car y))))
                 (λ (x y) (>= (cadr x) (cadr y))))
           5))))

; String => Bool
; Is true if the checksum matches.
(define (no-decoy? line)
  (let
      ; String => String
      ; Returns the given string without dashes.
      ([remove-dashes (λ (line) (string-replace line "-" ""))]) 
    (match (regexp-match
            #rx"([a-z-]+)-[0-9]+\\[([a-z]+)\\]"
            line)
      [(list _ str chk)
       (string=? (line->top-5-chars (remove-dashes str)) chk)])))

; String => Number
; Returns the sector ID for the given line.
(define (line->sector-id line)
  (string->number (cadr (regexp-match #rx"[a-z-]+-([0-9]+)\\[.+" line))))

; String => String
; Returns the (encrypted) name of the given line.
(define (line->encrypted-name line)
  (cadr (regexp-match #rx"([a-z-]+)-[0-9].*" line)))

; String, Number => String
; Rotates each char of the given string n times.
(define (rot line rotations)
  (letrec
      ; Char => Char
      ; Returns the successing char for the given one.
      ([char-succ (λ (chr) (integer->char (add1 (char->integer chr))))]
       ; Char, Number => Char
       ; Rotate the given char n times.
       [char-rot (λ (chr no) (cond
                               [(char=? chr #\-) #\space]
                               [(zero? no) chr]
                               [(char=? chr #\z) (char-rot #\a (sub1 no))]
                               [else (char-rot (char-succ chr) (sub1 no))]))]
       ; String, (Char => Char) => String
       ; Applies the given function to every char.
       [string-map (λ (f str) (list->string (map f (string->list str))))])
    (string-map (λ (x) (char-rot x rotations)) line)))

; String => String
; Tries to read the given string as a valid line and decrypt the content.
(define (decrypt-line line)
  (let
      ([sector-id (line->sector-id line)]
       [encrypted-name (line->encrypted-name line)])
    (rot encrypted-name sector-id)))

; => Number
; Sums the sector IDs of all legit lines from the "input"-file.
(define day4-task1
  (let* ([raw-lines (string-split (file->string "input") "\n")]
         [legit-lines (filter no-decoy? raw-lines)]
         [legit-ids (map line->sector-id legit-lines)]
         [id-sum (foldl + 0 legit-ids)])
    id-sum))

; => Number
; Find the sector-id for the encrypted northpole-storage.
(define day4-task2
  (let*
      ; String => Tuple of String, Number
      ; Decrypt the given line and returns a tuple of text and sector-id
      ([decrypt-with-id (λ (x) (list (decrypt-line x) (line->sector-id x)))]
       [raw-lines (string-split (file->string "input") "\n")]
       [legit-lines (filter no-decoy? raw-lines)]
       [decrypted-lines (map decrypt-with-id legit-lines)]
       [pole-line (findf (λ (x) (string-contains? (car x) "northpole"))
                         decrypted-lines)])
    (cadr pole-line)))

; => String
; Output for both tasks.
(define day4
  (let ([t1 (number->string day4-task1)]
        [t2 (number->string day4-task2)])
    (string-append "Solutions for day 4 are (a) " t1 " and (b) " t2)))
day4