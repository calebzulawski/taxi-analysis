define [
    'jquery'
    'react'
    'crypto'
    'text!extremeData'
    'text!cabbieData'
    'text!infoData'
], ($, React, Crypto, extremeDataRaw, cabbieDataRaw, infoDataRaw) ->

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
                <input type="range" min={@props.min} max={@props.max} step={@props.step} onChange={this.handleChange}/>
            </div>
        handleChange: (event) ->
            @setState {value: event.target.value}

    createSlider = (min, max, step, label, container='.slider-container') ->
        $(container).append("<div class='slider'>")
        React.render(
            <Slider min={min}, max={max}, step={step} label={label}/>,
            $("#{container} > div.slider:last-child()").get(0)
        )

    Textbox = React.createClass
        render: ->
            <div className="Textbox">
                <input type="text" value={@props.value} placeholder={@props.placeholder} onChange={this.handleChange}/>
            </div>
        handleChange: (event) ->
            @setState {value: event.target.value}

    createTextbox = (placeholder, container='.slider-container') ->
        $(container).append("<div class='textbox'>")
        React.render(
            <Textbox placeholder={placeholder}/>,
            $("#{container} > div.textbox:last-child()").get(0)
        )

    Button = React.createClass
        render: ->
            <div className="Button">
                <input type="button" value={@props.value} onClick={@props.onClick}/>
            </div>

    createButton = (value, onClick, container='.slider-container') ->
        $(container).append("<div class='button'>")
        React.render(
            <Button value={value} onClick={onClick}/>,
            $("#{container} > div.button:last-child()").get(0)
        )

    submitFunc = () ->
        console.log cabbieInst.submit()

    # $

    class Cabbie

        constructor: ->
            # initialize data
            extremes = JSON.parse extremeDataRaw
            data = JSON.parse cabbieDataRaw
            info = JSON.parse infoDataRaw
            medallions = data.medallions

            # initialize sliders
            @textMed = createTextbox "Enter Medallion #..."
            @sliderAgil = createSlider 0, 1, .01, "Agility"
            @sliderEnd = createSlider 0, 1, .01, "Endurance"
            @sliderExp = createSlider 0, 1, .01, "Experience"
            @sliderSat = createSlider 0, 1, .01, "Satisfaction"
            @buttonSubmit = createButton "Go!", submitFunc

        submit: ->
            fields =
                medallion: @textMed.state.value
                md5: Crypto.hex_md5 @textMed.state.value
                agility: @sliderAgil.state.value
                endurance: @sliderEnd.state.value
                experience: @sliderExp.state.value
                satisfaction: @sliderSat.state.value


    cabbieInst = new Cabbie()

