library("RMySQL")

mydb = dbConnect(MySQL(), user='root', password='password', dbname='stockdb', host='localhost')

#get today's date
todaydate <- Sys.Date()

today_day = format(todaydate, "%d")
#yahoo months start with Jan = 0, i.e. typical_month_num - 1
today_month = toString(as.numeric(format(todaydate, "%m")) - 1)
today_year = format(todaydate, "%Y")

#stock symbol
stock_symbol = "SPY"

#creating the url
url_create = paste("http://real-chart.finance.yahoo.com/table.csv?s=", stock_symbol, "&a=", today_month, "&b=", today_day, "&c=", today_year, "&d=", today_month,"&e=", today_day, "&f=", today_year, "&g=d&ignore=.csv", sep="")

#print out url_create for sanity check
url_create

#download and read in the csv
stockcsv <- read.csv(url_create)

#create INSERT query
query = paste("INSERT INTO stock_data (symbol, date, open, high, low, close, volume, adj_close) VALUES('", stock_symbol, "', '", stockcsv$Date[1], "', ", stockcsv$Open[1], ", ", stockcsv$High[1], ", ", stockcsv$Low[1], ", ", stockcsv$Close[1], ", ", stockcsv$Volume[1], ", ", stockcsv$Adj.Close[1], ")", sep="") 

#run query to insert into database
dbGetQuery(mydb, query)

#disconnect from db
dbDisconnect(mydb)
