# Login Presenter

> ## Regras
1. ✅ Chamar Validation ao alterar o email
2. ✅ Notificar o emailErrorStream com o mesmo erro do Validation, caso retorne 
erro
3. ✅ Não notificar o emailErrorStream se o valor for igual ao último
4. ✅ Notificar o isFormValidStream após alterar o email, mas não notificar o 
isFormValidStream se o valor for igual ao último
5. ✅ Notificar o emailErrorStream com null, caso o Validation não retorne erro
6. ✅ Chamar Validation ao alterar a senha
7. ✅ Notificar o passwordErrorStream com o mesmo erro do Validation, caso 
retorne error
8. ✅ Não notificar o passwordErrorStream se o valor for igual ao último
erro
9. ✅ Notificar o isFormValidStream após alterar a senha, mas mas não notificar 
o isFormValidStream se o valor for igual ao último
10.✅ Notificar o passwordErrorStream com null, caso o Validation não retorne erro
11.✅ Para o formulário estar válido todos os Streams de erro precisam estar null 
e todos os campos obrigatórios não podem estar vazios
12.✅ Chamar o Authentication com email e senha corretos
13.✅ Notificar o isLoadingStream como true antes de chamar o Authentication e 
false no fim do Authentication
14.✅ Notificar o mainErrorStream caso o Authentication retorne erro: 
InvalidCredentials 
15.✅ Notificar o mainErrorStream caso o Authentication retorne erro: 
UnexpectedError
16.✅ Gravar o Account no cache em caso de sucesso
17.✅ Notificar o mainErrorStream caso o SaveCurrentAccount retorne erro
18.✅ Levar o usuário pra tela de Inicial em caso de sucesso
19.✅ Levar o usuário pra tela de Criar conta