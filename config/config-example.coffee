path=require 'path'
#ARQUIVO DE CONFIGURAÇÃO DO SERVIDOR
dev={}
dev.port= 3000;
dev.domain= ''
dev.uri= 'http://'+dev.domain+':'+dev.port
module.exports=
	development:
		port:dev.port
		domain:dev.uri
		express:
			public:path.normalize __dirname+'/../public'
			views:path.normalize __dirname+'/../app/views'
			secret:''
		passport:
			facebook:
				clientID:''
				clientSecret:''
				callbackURL:dev.uri+'/auth/facebook/callback'
			twitter:
				clientID:''
				clientSecret:''
				callbackURL:dev.uri+'/auth/twitter/callback'
		mongodb:
			prefix:'amsd_'
			uri:'mongodb://<login>:<senha>@ds0<porta>.mongolab.com:<porta>/<db>'
		redis:
			host:''
			port:''
			pass:''
		i18n:
			defaultLocale:'pt-BR'
			locales:['pt-BR']
			directory:'./locale/'
			cookie:'lang'