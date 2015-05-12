define [
    'jquery'
    'react'
    'crypto'
    'text!extremeData'
    'text!cabbieData'
    'text!infoData'
], ($, React, Crypto, extremeDataRaw, cabbieDataRaw, infoDataRaw) ->

    SLIDER_CONTAINER = '.slider-container'
    CONTAINER = '.container'

    Slider = React.createClass
        getInitialState: ->
            state =
                value: @props.value
                min: @props.min
                max: @props.max
                step: @props.step
                label: @props.label
        render: ->
            displayNumber = "#{parseInt(parseFloat(@state.value) * 100)}%"
            <div className="slider">
                <div className="label">{@props.label}: <span className="slider-value">{displayNumber}</span></div>
                <input type="range" min={@props.min} max={@props.max} step={@props.step} onChange={this.handleChange}/>
            </div>
        handleChange: (event) ->
            @setState {value: event.target.value}

    createSlider = (min, max, step, label, container=SLIDER_CONTAINER) ->
        $(container).append("<div class='slider'>")
        slider = React.render(
            <Slider min={min}, max={max}, step={step} value={0.5} label={label}/>,
            $("#{container} > div.slider:last-child()").get(0)
        )

    Textbox = React.createClass
        render: ->
            label = "Medallion #"
            <div className="Textbox">
                <h2 className="label">{label}</h2>
                <input type="text" value={@props.value} placeholder={@props.placeholder} onChange={this.handleChange}/>
            </div>
        handleChange: (event) ->
            @setState {value: event.target.value}

    createTextbox = (placeholder, container='.container') ->
        $(container).prepend("<div class='textbox'>")
        textbox = React.render(
            <Textbox placeholder={placeholder}/>,
            $("#{container} > div.textbox").get(0)
        )
        textbox.setState {value: ""}
        textbox

    Button = React.createClass
        render: ->
            <div className="Button">
                <input type="button" value={@props.value} onClick={@props.onClick}/>
            </div>

    createButton = (value, onClick, container=SLIDER_CONTAINER) ->
        $(container).append("<div class='button'>")
        React.render(
            <Button value={value} onClick={onClick}/>,
            $("#{container} > div.button:last-child()").get(0)
        )

    Results = React.createClass
        render: ->
            results = []
            for key, val of @props.labels
                if @props.fields[key]
                    results.push {label: val, value: @props.fields[key]}
            <div className="results">
                <h3 className="resultTitle">{@props.resultTitle}</h3>
                <ul>{
                    results.map (result) ->
                        <li>{result.label}: <span className="value">{result.value.toFixed(2)}</span></li>
                    }
                </ul>
            </div>

    createResults = (fields, medallion, resultTitle, parent=CONTAINER, container='resultsList') ->
        $(parent).append "<div id="result" class='#{container}'>"
        textLabels =
            total: "Your weighted rating"
            agility: "Agility"
            endurance: "Endurance"
            experience: "Experience"
            satisfaction: "Satisfaction"
            f_avgFare: "Average Fare ($)"
            f_avgTip: "Average Tip ($)"
            f_avgTipPercent: "Average Tip (%)"
            f_numberOfTrips: "# of Trips (2013)"
            t_avgDistance: "Average Distance/Trip (mi)"
            t_avgSpeed: "Average Speed (mph)"
        React.render(
            <Results fields={fields} labels={textLabels} medallion={medallion} resultTitle={resultTitle} />,
            $(".#{container}").get(0)
        )

    submitFunc = () ->
        cabbieInst.submit()
        window.location.href = "#result"


    class Cabbie

        constructor: ->
            # initialize data
            @extremes = JSON.parse extremeDataRaw
            @data = JSON.parse cabbieDataRaw
            @info = JSON.parse infoDataRaw
            @medallions = @data.medallions
            @numCabbies = Object.keys(@medallions).length - 1
            @initializeComponents()

        initializeComponents: =>
            # initialize sliders
            @textMed = createTextbox "Enter Medallion #..."
            @sliderAgil = createSlider 0, 1, .01, "Agility"
            @sliderEnd = createSlider 0, 1, .01, "Endurance"
            @sliderExp = createSlider 0, 1, .01, "Experience"
            @sliderSat = createSlider 0, 1, .01, "Satisfaction"
            @buttonSubmit = createButton "Go!", submitFunc
            # @avgResults = createResults @averages, null, '.header', 'avgResults'

        getFields: ->
            fields =
                medallion: @textMed.state.value.toUpperCase()
                md5: Crypto.hex_md5(@textMed.state.value.toUpperCase()).toUpperCase()
                agility: parseFloat @sliderAgil.state.value
                endurance: parseFloat @sliderEnd.state.value
                experience: parseFloat @sliderExp.state.value
                satisfaction: parseFloat @sliderSat.state.value

        mergeCabbieResults: (cabbieData, ratings) ->
            numberData = {}
            for k, v of cabbieData
                i = parseFloat v
                if isNaN i
                    numberData[k] = v
                else
                    numberData[k] = i
            $.extend {}, ratings, numberData

        generateRatings: (data, fields) ->
            agilityRating = (@numCabbies - data.pctSpeed + 1) / @numCabbies
            enduranceRating = (@numCabbies - data.pctAvgDistance + 1) / @numCabbies
            experienceRating = (@numCabbies - data.pctNumberOfTrips + 1) / @numCabbies
            satisfactionRating = (@numCabbies - data.pctAvgTip + 1) / @numCabbies
            rating = fields.agility * agilityRating + fields.endurance * enduranceRating + fields.experience * experienceRating + fields.satisfaction * satisfactionRating
            rating = rating / (fields.agility + fields.endurance + fields.experience + fields.satisfaction)
            ratings =
                total: rating
                agility: agilityRating
                endurance: enduranceRating
                experience: experienceRating
                satisfaction: satisfactionRating


        submit: ->
            fields = @getFields()
            data = @medallions[fields.md5]
            info = @info[fields.medallion]
            ratings = @generateRatings(data, fields)
            resultsData = @mergeCabbieResults(data, ratings)
            resultTitle = "Results for Medallion # #{fields.medallion}"
            @results = createResults resultsData, fields.medallion, resultTitle

    cabbieInst = new Cabbie()

