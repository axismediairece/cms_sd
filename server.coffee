express=require('express')
app=express()

app.get '/',(req,res)->
  res.send "ok"

app.listen(3000)