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
        slider = React.render(
            <Slider min={min}, max={max}, step={step} label={label}/>,
            $("#{container} > div.slider:last-child()").get(0)
        )
        slider.setState {value: 0.5}
        slider

    Textbox = React.createClass
        render: ->
            <div className="Textbox">
                <input type="text" value={@props.value} placeholder={@props.placeholder} onChange={this.handleChange}/>
            </div>
        handleChange: (event) ->
            @setState {value: event.target.value}

    createTextbox = (placeholder, container='.slider-container') ->
        $(container).append("<div class='textbox'>")
        textbox = React.render(
            <Textbox placeholder={placeholder}/>,
            $("#{container} > div.textbox:last-child()").get(0)
        )
        textbox.setState {value: ""}
        textbox

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
        cabbieInst.submit()

    # $

    class Cabbie

        constructor: ->
            # initialize data
            @extremes = JSON.parse extremeDataRaw
            @data = JSON.parse cabbieDataRaw
            @info = JSON.parse infoDataRaw
            @medallions = @data.medallions

            # initialize sliders
            @textMed = createTextbox "Enter Medallion #..."
            @sliderAgil = createSlider 0, 1, .01, "Agility"
            @sliderEnd = createSlider 0, 1, .01, "Endurance"
            @sliderExp = createSlider 0, 1, .01, "Experience"
            @sliderSat = createSlider 0, 1, .01, "Satisfaction"
            @buttonSubmit = createButton "Go!", submitFunc

        getFields: ->
            fields =
                medallion: @textMed.state.value.toUpperCase()
                md5: Crypto.hex_md5(@textMed.state.value.toUpperCase()).toUpperCase()
                agility: @sliderAgil.state.value
                endurance: @sliderEnd.state.value
                experience: @sliderExp.state.value
                satisfaction: @sliderSat.state.value

        submit: ->
            fields = this.getFields()
            data = @medallions[fields.md5]
            info = @info[fields.medallion]
            agilityRating = (data.t_avgSpeed - @extremes.minAvgSpeed) / (@extremes.maxAvgSpeed - @extremes.minAvgSpeed)
            enduranceRating = (data.t_avgDistance - @extremes.minAvgDistance) / (@extremes.maxAvgDistance - @extremes.minAvgDistance)
            experienceRating = (data.t_numberOfTrips - @extremes.minNumTripsT) / (@extremes.maxNumTripsT - @extremes.minNumTripsT)
            satisfactionRating = (data.f_avgTipPercent - @extremes.minAvgTipPercent) / (@extremes.maxAvgTipPercent - @extremes.minAvgTipPercent)
            rating = fields.agility * agilityRating + fields.endurance * enduranceRating + fields.experience * experienceRating + fields.satisfaction * satisfactionRating
            rating = rating / (fields.agility + fields.endurance + fields.experience + fields.satisfaction)
            ratings = 
                total: rating
                agility: agilityRating
                endurance: enduranceRating
                experience: experienceRating
                satisfaction: satisfactionRating
            console.log(ratings)


    cabbieInst = new Cabbie()

