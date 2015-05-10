# To run

```
cd <path/to/repo>
cd cabbie_stats
npm install  # you might need to install some dependencies with sudo npm install -g <dependency>
cjsx -o js/ -cw coffee/
```

And, in a new tab
```
cd <path/to/repo>
python -m SimpleHTTPServer
```

Go to `localhost:8000/cabbie_stats`

# To Develop

- Edit only coffee files
- Register new modules, dependencies, and data files in `main.coffee`
