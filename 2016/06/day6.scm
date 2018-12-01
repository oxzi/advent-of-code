(use srfi-1) ; List Library
(use utils) ; For reading files

(define (line->count-list line)
  (map (lambda (c) (list (list c 1)))
       (string->list line)))

(define (combine-inner-lists la lb)
  (let
    ((lst (sort (append la lb)
                (lambda (a b) (char<=? (car a) (car b)))))
     (merge (lambda (xs x)
              (cond
                ((null? xs) (list x))
                ((char=? (car x) (caar xs))
                 (cons (list (car x) (+ (cadr x) (cadar xs))) (cdr xs)))
                (else (cons x xs))))))
    (foldl merge '() lst)))
    

(define (combine-count-lists la lb)
  (if (or (null? la) (null? lb))
    '()
    (cons (combine-inner-lists (car la) (car lb))
          (combine-count-lists (cdr la) (cdr lb)))))

(define (count-list->message lst op)
  (let
    ((sort-inner (lambda (x)
                   (sort x (lambda (a b) (op (cadr a) (cadr b)))))))
    (list->string (map caar (map sort-inner lst)))))
(define (count-list->message-a lst) (count-list->message lst >=))
(define (count-list->message-b lst) (count-list->message lst <=))

(define (message-from-file file)
  (let*
    ((data (read-all file))
     (lines (string-split data "\n"))
     (count-lists (map line->count-list lines))
     (total-count-list (foldl combine-count-lists
                              (car count-lists) (cdr count-lists)))
     (task1 (count-list->message-a total-count-list))
     (task2 (count-list->message-b total-count-list)))
    (string-append "Task 1: " task1 "\nTask 2: " task2)))

(print (message-from-file "input"))
