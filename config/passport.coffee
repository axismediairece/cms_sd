Server=require './init'
mongoose=require 'mongoose'
Conta=mongoose.model 'contas'
config=Server.config
confPass=config.passport
passport=require 'passport'
FacebookStrategy=require('passport-facebook').Strategy
TwitterStrategy=require('passport-twitter').Strategy


passport.serializeUser (user,done)->
	console.log user
	done null,user._id

passport.deserializeUser (id,done)->
	Conta.findOne {_id:id},(err,user)-> done err,user



passport.use new TwitterStrategy {
	consumerKey:confPass.twitter.clientID
	consumerSecret:confPass.twitter.clientSecret
	callbackURL:confPass.twitter.callbackURL
	},(token,tokenSecret,profile,done)->
		Conta.findOne {'twitter.id':profile.id},(err,conta)->
			if err then return done err,null
			if !conta
				_conta=new Conta
					name: profile.displayName
					username: profile.username
					provider: 'twitter'
					twitter: profile._json
				_conta.save (err,data)->
					if err then return console.log err
					done err,data
			else
				done err,conta



passport.use new FacebookStrategy
	clientID:confPass.facebook.clientID
	clientSecret:confPass.facebook.clientSecret
	callbackURL:confPass.facebook.callbackURL
	,(acessToken,refreshToken,profile,done)->
		Conta.findOne {'facebook.id':profile.id},(err,conta)->
			if err then return done err,null
			if !conta
				_conta=new Conta
					email:profile.emails[0].value
					username:profile.username
					provider:'facebook'
					facebook:profile._json
				_conta.save (err,data)->
					if err then return console.log err
					done err,data
			else
				done err,conta
