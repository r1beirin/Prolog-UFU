:- load_files([ 
  chave,         
  eventos,
  email,
  lancamentos,
  integrante,
  complemento,
  itemlog,
  pagamentos
  ],
	[
    if(not_loaded),
    silent(true)    
]).