// Generated by CoffeeScript 1.9.2
(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(['jquery', 'react', 'crypto', 'text!extremeData', 'text!cabbieData', 'text!infoData'], function($, React, Crypto, extremeDataRaw, cabbieDataRaw, infoDataRaw) {
    var Button, CONTAINER, Cabbie, Results, SLIDER_CONTAINER, Slider, Textbox, cabbieInst, createButton, createResults, createSlider, createTextbox, submitFunc;
    SLIDER_CONTAINER = '.slider-container';
    CONTAINER = '.container';
    Slider = React.createClass({
      getInitialState: function() {
        var state;
        return state = {
          value: this.props.value,
          min: this.props.min,
          max: this.props.max,
          step: this.props.step,
          label: this.props.label
        };
      },
      render: function() {
        return React.createElement("div", {
          "className": "slider"
        }, React.createElement("div", {
          "className": "label"
        }, this.props.label, ": ", React.createElement("span", {
          "className": "slider-value"
        }, this.state.value)), React.createElement("input", {
          "type": "range",
          "min": this.props.min,
          "max": this.props.max,
          "step": this.props.step,
          "onChange": this.handleChange
        }));
      },
      handleChange: function(event) {
        return this.setState({
          value: event.target.value
        });
      }
    });
    createSlider = function(min, max, step, label, container) {
      var slider;
      if (container == null) {
        container = SLIDER_CONTAINER;
      }
      $(container).append("<div class='slider'>");
      return slider = React.render(React.createElement(Slider, {
        "min": min,
        "max": max,
        "step": step,
        "value": 0.5,
        "label": label
      }), $(container + " > div.slider:last-child()").get(0));
    };
    Textbox = React.createClass({
      render: function() {
        var label;
        label = "Medallion #";
        return React.createElement("div", {
          "className": "Textbox"
        }, React.createElement("h2", {
          "className": "label"
        }, label), React.createElement("input", {
          "type": "text",
          "value": this.props.value,
          "placeholder": this.props.placeholder,
          "onChange": this.handleChange
        }));
      },
      handleChange: function(event) {
        return this.setState({
          value: event.target.value
        });
      }
    });
    createTextbox = function(placeholder, container) {
      var textbox;
      if (container == null) {
        container = '.container';
      }
      $(container).prepend("<div class='textbox'>");
      textbox = React.render(React.createElement(Textbox, {
        "placeholder": placeholder
      }), $(container + " > div.textbox").get(0));
      textbox.setState({
        value: ""
      });
      return textbox;
    };
    Button = React.createClass({
      render: function() {
        return React.createElement("div", {
          "className": "Button"
        }, React.createElement("input", {
          "type": "button",
          "value": this.props.value,
          "onClick": this.props.onClick
        }));
      }
    });
    createButton = function(value, onClick, container) {
      if (container == null) {
        container = SLIDER_CONTAINER;
      }
      $(container).append("<div class='button'>");
      return React.render(React.createElement(Button, {
        "value": value,
        "onClick": onClick
      }), $(container + " > div.button:last-child()").get(0));
    };
    Results = React.createClass({
      render: function() {
        var key, ref, results, val;
        results = [];
        ref = this.props.labels;
        for (key in ref) {
          val = ref[key];
          if (this.props.fields[key]) {
            results.push({
              label: val,
              value: this.props.fields[key]
            });
          }
        }
        return React.createElement("div", {
          "className": "results"
        }, React.createElement("h3", {
          "className": "resultTitle"
        }, this.props.resultTitle), React.createElement("ul", null, results.map(function(result) {
          return React.createElement("li", null, result.label, ": ", React.createElement("span", {
            "className": "value"
          }, result.value.toFixed(2)));
        })));
      }
    });
    createResults = function(fields, medallion, resultTitle, parent, container) {
      var textLabels;
      if (parent == null) {
        parent = CONTAINER;
      }
      if (container == null) {
        container = 'resultsList';
      }
      $(parent).append("<div class='" + container + "'>");
      textLabels = {
        total: "Your weighted rating",
        agility: "Agility",
        endurance: "Endurance",
        experience: "Experience",
        satisfaction: "Satisfaction",
        f_avgFare: "Average Fare ($)",
        f_avgTip: "Average Tip ($)",
        f_avgTipPercent: "Average Tip (%)",
        f_numberOfTrips: "# of Trips (2013)",
        t_avgDistance: "Average Distance/Trip (mi)",
        t_avgSpeed: "Average Speed (mph)"
      };
      return React.render(React.createElement(Results, {
        "fields": fields,
        "labels": textLabels,
        "medallion": medallion,
        "resultTitle": resultTitle
      }), $("." + container).get(0));
    };
    submitFunc = function() {
      return cabbieInst.submit();
    };
    Cabbie = (function() {
      function Cabbie() {
        this.initializeComponents = bind(this.initializeComponents, this);
        this.extremes = JSON.parse(extremeDataRaw);
        this.data = JSON.parse(cabbieDataRaw);
        this.info = JSON.parse(infoDataRaw);
        this.medallions = this.data.medallions;
        this.numCabbies = Object.keys(this.medallions).length - 1;
        this.initializeComponents();
      }

      Cabbie.prototype.initializeComponents = function() {
        this.textMed = createTextbox("Enter Medallion #...");
        this.sliderAgil = createSlider(0, 1, .01, "Agility");
        this.sliderEnd = createSlider(0, 1, .01, "Endurance");
        this.sliderExp = createSlider(0, 1, .01, "Experience");
        this.sliderSat = createSlider(0, 1, .01, "Satisfaction");
        return this.buttonSubmit = createButton("Go!", submitFunc);
      };

      Cabbie.prototype.getFields = function() {
        var fields;
        return fields = {
          medallion: this.textMed.state.value.toUpperCase(),
          md5: Crypto.hex_md5(this.textMed.state.value.toUpperCase()).toUpperCase(),
          agility: parseFloat(this.sliderAgil.state.value),
          endurance: parseFloat(this.sliderEnd.state.value),
          experience: parseFloat(this.sliderExp.state.value),
          satisfaction: parseFloat(this.sliderSat.state.value)
        };
      };

      Cabbie.prototype.mergeCabbieResults = function(cabbieData, ratings) {
        var i, k, numberData, v;
        numberData = {};
        for (k in cabbieData) {
          v = cabbieData[k];
          i = parseFloat(v);
          if (isNaN(i)) {
            numberData[k] = v;
          } else {
            numberData[k] = i;
          }
        }
        return $.extend({}, ratings, numberData);
      };

      Cabbie.prototype.generateRatings = function(data, fields) {
        var agilityRating, enduranceRating, experienceRating, rating, ratings, satisfactionRating;
        agilityRating = (this.numCabbies - data.pctSpeed + 1) / this.numCabbies;
        enduranceRating = (this.numCabbies - data.pctAvgDistance + 1) / this.numCabbies;
        experienceRating = (this.numCabbies - data.pctNumberOfTrips + 1) / this.numCabbies;
        satisfactionRating = (this.numCabbies - data.pctAvgTip + 1) / this.numCabbies;
        rating = fields.agility * agilityRating + fields.endurance * enduranceRating + fields.experience * experienceRating + fields.satisfaction * satisfactionRating;
        rating = rating / (fields.agility + fields.endurance + fields.experience + fields.satisfaction);
        return ratings = {
          total: rating,
          agility: agilityRating,
          endurance: enduranceRating,
          experience: experienceRating,
          satisfaction: satisfactionRating
        };
      };

      Cabbie.prototype.submit = function() {
        var data, fields, info, ratings, resultTitle, resultsData;
        fields = this.getFields();
        data = this.medallions[fields.md5];
        info = this.info[fields.medallion];
        ratings = this.generateRatings(data, fields);
        resultsData = this.mergeCabbieResults(data, ratings);
        resultTitle = "Results for Medallion # " + fields.medallion;
        return this.results = createResults(resultsData, fields.medallion, resultTitle);
      };

      return Cabbie;

    })();
    return cabbieInst = new Cabbie();
  });

}).call(this);
