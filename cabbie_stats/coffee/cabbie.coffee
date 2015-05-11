define [
    'jquery'
    'react'
    'text!extremeData'
    'text!cabbieData'
], ($, React, extremeDataRaw, cabbieDataRaw) ->

    SLIDER_CONTAINER = '.slider-container'

    Slider = React.createClass
        getInitialState: ->
            state =
                currentValue: @props.value
                min: @props.min
                max: @props.max
                step: @props.step


        render: ->
            <div className="slider">
                <input type="range" min={@props.min} max={@props.max} step={@props.step} />
            </div>

    createSlider = (min, max, step, onChange, container='.slider-container') ->
        $(container).append("<div class='slider'>")
        React.render(
            <Slider min={min}, max={max}, step={step} />,
            $("#{container} > div.slider:last-child()").get(0)
        )

    onChange = () ->
        console.log "yay"

    # $

    class Cabbie

        constructor: ->
            # initialize data
            extremes = JSON.parse extremeDataRaw
            data = JSON.parse cabbieDataRaw
            medallions = data.medallions

            # initialize sliders
            @slider1 = createSlider -100, 100, 1, onChange
            @slider2 = createSlider -100, 100, 1, onChange
            @slider3 = createSlider -100, 100, 1, onChange
            @slider4 = createSlider -100, 100, 1, onChange


    new Cabbie()
