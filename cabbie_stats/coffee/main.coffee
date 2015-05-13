require {
    baseUrl: '/taxi-analysis/cabbie_stats/js/'
    paths:
        # dependencies
        jquery: '../node_modules/jquery/dist/jquery.min'
        react: '../node_modules/react/dist/react'
        text: '../node_modules/text/text'
        crypto: '../node_modules/crypto/md5'
        d3: '../node_modules/d3/d3'

        # modules
        CabbieStats: 'cabbie'
        CabbiePlots: 'cabbiePlot'
        EthanVisualization: 'ethan'
        calendars: 'calendars'
        neighborhoods: 'neighborhoods'

        # data files
        cabbieData: '../data/cabbies_obj.json'
        extremeData: '../data/extremes.json'
        infoData: '../data/info.json'
}