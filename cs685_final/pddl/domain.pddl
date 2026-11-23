; Final Project Presentation CS 685

(define (domain any-task)
  (:requirements :strips :typing)
  (:types waypoint item receptacle - object
          surface container - receptacle)
  (:predicates
    (robot-at ?w - waypoint)
    (route ?from - waypoint ?to - waypoint)
    (near ?r - receptacle ?w - waypoint)
    (on ?i - item ?s - surface)
    (in ?i - item ?c - container)
    (holding ?i - item)
    (hand-empty)
    (open ?c - container)
    (closed ?c - container)
    (searched ?r - receptacle)
    (unsearched ?r - receptacle))

  (:action move
    :parameters (?from - waypoint ?to - waypoint)
    :precondition (and (robot-at ?from) (route ?from ?to))
    :effect (and (robot-at ?to) (not (robot-at ?from))))

  (:action grab-from-surface
    :parameters (?i - item ?s - surface ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?s ?w) (on ?i ?s) (hand-empty))
    :effect (and (holding ?i) (not (on ?i ?s)) (not (hand-empty))))

  (:action grab-from-container
    :parameters (?i - item ?c - container ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?c ?w) (open ?c) (in ?i ?c) (hand-empty))
    :effect (and (holding ?i) (not (in ?i ?c)) (not (hand-empty))))

  (:action put-down
    :parameters (?i - item ?s - surface ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?s ?w) (holding ?i))
    :effect (and (on ?i ?s) (hand-empty) (not (holding ?i))))

  (:action put-in
    :parameters (?i - item ?c - container ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?c ?w) (open ?c) (holding ?i))
    :effect (and (in ?i ?c) (hand-empty) (not (holding ?i))))

  (:action open
    :parameters (?c - container ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?c ?w) (closed ?c) (hand-empty))
    :effect (and (open ?c) (not (closed ?c))))

  (:action close
    :parameters (?c - container ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?c ?w) (open ?c) (hand-empty))
    :effect (and (closed ?c) (not (open ?c))))

  ; Looking at a surface. New item facts come from perception, not from here.
  (:action search-surface
    :parameters (?s - surface ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?s ?w) (unsearched ?s))
    :effect (and (searched ?s) (not (unsearched ?s))))

  ; Looking inside a container requires it to be open.
  (:action search-container
    :parameters (?c - container ?w - waypoint)
    :precondition (and (robot-at ?w) (near ?c ?w) (open ?c) (unsearched ?c))
    :effect (and (searched ?c) (not (unsearched ?c))))
)
