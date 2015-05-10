define [
    'jquery'
    'react'
    'text!extremeData'
    'text!cabbieData'
], ($, React, extremeDataRaw, cabbieDataRaw) ->

    Slider = React.createClass

        render: ->

            <div className="slider">
                <input type="range" min={@props.min} max={@props.max} value={@props.value} step={@props.step} />
            </div>

        create = (min, max, value, step, onChange, container='body') ->
            React.render <Slider
                    min={min},
                    max={max},
                    value={value},
                    step={step}
                />, $(container).get(0)

    class Cabbie

        constructor: ->
            extremes = JSON.parse extremeDataRaw
            data = JSON.parse cabbieDataRaw
            medallions = data.medallions

            @slider = Slider.create(0, 1, 0.5, 0.05, null)