define [
    'jquery'
    'react'
    'text!extremeData'
    'text!cabbieData'
], ($, React, extremeDataRaw, cabbieDataRaw) ->

    extremes = JSON.parse extremeDataRaw
    data = JSON.parse cabbieDataRaw
    medallions = data.medallions

    React.createClass