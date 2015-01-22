# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  countdownElements = $('span.countdown')

  if countdownElements.length > 0
    setTimeout ->
      countDownTick(countdownElements)
    , 1000

countDownTick = (countdownElements) ->
  for countdownElement in countdownElements
    countDown($ countdownElement)

  setTimeout ->
    countDownTick(countdownElements)
  , 1000

countDown = (element) ->
  timeRemaining = parseTime(element.text())

  if timeRemaining > 0
    element.text(formatTime(timeRemaining - 1))

parseTime = (str) ->
  arr = str.split(":")

  parseInt(arr[0], 10) * 3600 +
    parseInt(arr[1], 10) * 60 +
    parseInt(arr[2], 10)

formatTime = (time) ->
  hours = parseInt(time / 3600)
  minutes = parseInt((time % 3600) / 60)
  seconds = parseInt(time % 60)
  console.log [ hours, minutes, seconds ]

  ((formatNumber(number)) for number in [ hours, minutes, seconds ]).join(":")

formatNumber = (number) ->
  if number < 10 then "0#{number}" else number
