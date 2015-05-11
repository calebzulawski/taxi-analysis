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
                label: @props.label


        render: ->
            <div className="slider">
                <div className="label">{@props.label}</div>
                <input type="range" min={@props.min} max={@props.max} step={@props.step} />
            </div>

    createSlider = (min, max, step, onChange, label, container='.slider-container') ->
        $(container).append("<div class='slider'>")
        React.render(
            <Slider min={min}, max={max}, step={step} label={label}/>,
            $("#{container} > div.slider:last-child()").get(0)
        )

    onChange = () ->
        console.log "yay"

    Textbox = React.createClass
        getInitialState: ->
            state =
                placeholder: @props.placeholder

        render: ->
            <div className="Textbox">
                <input type="text" placeholder={@props.placeholder}/>
            </div>

    createTextbox = (placeholder, container='.slider-container') ->
        $(container).append("<div class='textbox'>")
        React.render(
            <Textbox placeholder={placeholder}/>,
            $("#{container} > div.textbox:last-child()").get(0)
        )

    Button = React.createClass
        getInitialState: ->
            state =
                value: @props.value

        render: ->
            <div className="Button">
                <input type="button" value={@props.value}/>
            </div>

    createButton = (value, container='.slider-container') ->
        $(container).append("<div class='button'>")
        React.render(
            <Button value={value}/>,
            $("#{container} > div.button:last-child()").get(0)
        )

    # $

    class Cabbie

        constructor: ->
            # initialize data
            extremes = JSON.parse extremeDataRaw
            data = JSON.parse cabbieDataRaw
            medallions = data.medallions

            # initialize sliders
            @textbox1 = createTextbox "Enter Medallion #..."
            @slider1 = createSlider -100, 100, 1, onChange, "Agility"
            @slider2 = createSlider -100, 100, 1, onChange, "Endurance"
            @slider3 = createSlider -100, 100, 1, onChange, "Experience"
            @slider4 = createSlider -100, 100, 1, onChange, "Satisfaction"
            @button1 = createButton "Go!"


    new Cabbie()
