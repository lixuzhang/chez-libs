
(library
  (srfi :117 list-queues)
  (export make-list-queue list-queue list-queue-copy list-queue-unfold list-queue-unfold-right
          list-queue? list-queue-empty?
          list-queue-front list-queue-back list-queue-list list-queue-first-last
          list-queue-add-front! list-queue-add-back! list-queue-remove-front! list-queue-remove-back!
          list-queue-remove-all! list-queue-set-list!
          list-queue-append list-queue-append! list-queue-concatenate
          list-queue-append list-queue-append! list-queue-concatenate
          list-queue-map list-queue-map! list-queue-for-each)
  (import (rnrs) (rnrs mutable-pairs)
          (only (srfi :1 lists) last-pair list-copy))

  ;;; The list-queue record
  ;;; The invariant is that either first is (the first pair of) a list
  ;;; and last is the last pair, or both of them are the empty list.

  (define-record-type (list-queue> raw-make-list-queue list-queue?)
                      (fields
                        (mutable first get-first set-first!)
                        (mutable last get-last set-last!)))

  ;;; Constructors

  (define make-list-queue
    (case-lambda
      ((list)
       (if (null? list)
         (raw-make-list-queue '() '())
         (raw-make-list-queue list (last-pair list))))
      ((list last)
       (raw-make-list-queue list last))))

  (define (list-queue . objs)
    (make-list-queue objs))

  (define (list-queue-copy list-queue)
    (make-list-queue (list-copy (get-first list-queue))))

  ;;; Predicates

  (define (list-queue-empty? list-queue)
    (null? (get-first list-queue)))

  ;;; Accessors

  (define (list-queue-front list-queue)
    (if (list-queue-empty? list-queue)
      (error 'list-queue-front "Empty list-queue")
      (car (get-first list-queue))))

  (define (list-queue-back list-queue)
    (if (list-queue-empty? list-queue)
      (error 'list-queue-back "Empty list-queue")
      (car (get-last list-queue))))

  ;;; Mutators (which carefully maintain the invariant)

  (define (list-queue-add-front! list-queue elem)
    (let ((new-first (cons elem (get-first list-queue))))
      (if (list-queue-empty? list-queue)
        (set-last! list-queue new-first))
      (set-first! list-queue new-first)))

  (define (list-queue-add-back! list-queue elem)
    (let ((new-last (list elem)))
      (if (list-queue-empty? list-queue)
        (set-first! list-queue new-last)
        (set-cdr! (get-last list-queue) new-last))
      (set-last! list-queue new-last)))

  (define (list-queue-remove-front! list-queue)
    (if (list-queue-empty? list-queue)
      (error 'list-queue-remove-front! "Empty list-queue"))
    (let* ((old-first (get-first list-queue))
           (elem (car old-first))
           (new-first (cdr old-first)))
      (if (null? new-first)
        (set-last! list-queue '()))
      (set-first! list-queue new-first)
      elem))

  (define (list-queue-remove-back! list-queue)
    (if (list-queue-empty? list-queue)
      (error 'list-queue-remove-back! "Empty list-queue"))
    (let* ((old-last (get-last list-queue))
           (elem (car old-last))
           (new-last (penult-pair (get-first list-queue))))
      (if (null? new-last)
        (set-first! list-queue '())
        (set-cdr! new-last '()))
      (set-last! list-queue new-last)
      elem))

  (define (list-queue-remove-all! list-queue)
    (let ((result (get-first list-queue)))
      (set-first! list-queue '())
      (set-last! list-queue '())
      result))

  ;; Return the next to last pair of lis, or nil if there is none

  (define (penult-pair lis)
    (let lp ((lis lis))
      (cond
        ;((null? lis) (error "Empty list-queue"))
        ((null? (cdr lis)) '())
        ((null? (cddr lis)) lis)
        (else (lp (cdr lis))))))

  ;;; The whole list-queue


  ;; Because append does not copy its back argument, we cannot use it
  (define (list-queue-append . list-queues)
    (list-queue-concatenate list-queues))

  (define (list-queue-concatenate list-queues)
    (let ((result (list-queue)))
      (for-each
        (lambda (list-queue)
          (for-each (lambda (elem) (list-queue-add-back! result elem)) (get-first list-queue)))
        list-queues)
      result))

  (define list-queue-append!
    (case-lambda
      (() (list-queue))
      ((queue) queue)
      (queues
        (for-each (lambda (queue) (list-queue-join! (car queues) queue))
                  (cdr queues))
        (car queues))))

  ; Forcibly join two queues, destroying the second
  (define (list-queue-join! queue1 queue2)
    (set-cdr! (get-last queue1) (get-first queue2)))

  (define (list-queue-map proc list-queue)
    (make-list-queue (map proc (get-first list-queue))))

  (define list-queue-unfold
    (case-lambda
      ((stop? mapper successor seed queue)
       (list-queue-unfold* stop? mapper successor seed queue))
      ((stop? mapper successor seed)
       (list-queue-unfold* stop? mapper successor seed (list-queue)))))

  (define (list-queue-unfold* stop? mapper successor seed queue)
    (let loop ((seed seed))
      (if (not (stop? seed))
        (list-queue-add-front! (loop (successor seed)) (mapper seed)))
      queue))

  (define list-queue-unfold-right
    (case-lambda
      ((stop? mapper successor seed queue)
       (list-queue-unfold-right* stop? mapper successor seed queue))
      ((stop? mapper successor seed)
       (list-queue-unfold-right* stop? mapper successor seed (list-queue)))))

  (define (list-queue-unfold-right* stop? mapper successor seed queue)
    (let loop ((seed seed))
      (if (not (stop? seed))
        (list-queue-add-back! (loop (successor seed)) (mapper seed)))
      queue))

  ;;; This definition of map! isn't fully SRFI-1 compliant, as it
  ;;; handles only unary functions.  You can use SRFI-1's definition
  ;;; if you want.

  (define (map! f lis) ; chibi's map! does not alter the original list...
    (let lp ((lis lis))
      (if (pair? lis)
        (begin
          (set-car! lis (f (car lis)))
          (lp (cdr lis))))))

  (define (list-queue-map! proc list-queue)
    (map! proc (get-first list-queue)))

  (define (list-queue-for-each proc list-queue)
    (for-each proc (get-first list-queue)))

  ;;; Conversion

  (define (list-queue-list list-queue)
    (get-first list-queue))

  (define (list-queue-first-last list-queue)
    (values (get-first list-queue) (get-last list-queue)))

  (define list-queue-set-list!
    (case-lambda
      ((list-queue first)
       (set-first! list-queue first)
       (if (null? first)
         (set-last! list-queue '())
         (set-last! list-queue (last-pair first))))
      ((list-queue first last)
       (set-first! list-queue first)
       (set-last! list-queue last))))

  )

