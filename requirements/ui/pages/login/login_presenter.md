# Login Presenter

> ## Regras
1. ✅ Chamar Validation ao alterar o email
2. ✅ Notificar o emailErrorStream com o mesmo erro do Validation, caso retorne erro
3. ✅ Não notificar o emailErrorStream se o valor for igual ao último
4. ✅ Notificar o isFormValidStream após alterar o email, mas não notificar o isFormValidStream se o valor for igual ao último
5. ✅ Notificar o emailErrorStream com null, caso o Validation não retorne erro
6. ✅ Chamar Validation ao alterar a senha
7. ✅ Notificar o passwordErrorStream com o mesmo erro do Validation, caso retorne error
8. ✅ Não notificar o passwordErrorStream se o valor for igual ao último erro
9. ✅ Notificar o isFormValidStream após alterar a senha, mas mas não notificar o isFormValidStream se o valor for igual ao último
10.✅ Notificar o passwordErrorStream com null, caso o Validation não retorne erro
11.✅ Notificar o isFormValidStream desabilita o butão se qualquer campo estiver inválido
12.✅ Notificar o isFormValidStream habilita o butão se qualquer campo estiver inválido
13.✅ Chamar o Authentication com email e senha corretos
14.✅ Notificar o isLoadingStream como true antes de chamar o Authentication e false no fim do Authentication
15.✅ Notificar o mainErrorStream caso o Authentication retorne erro: InvalidCredentials 
16.✅ Notificar o mainErrorStream caso o Authentication retorne erro: UnexpectedError
17.✅ Gravar o Account no cache em caso de sucesso
18.✅ Notificar o mainErrorStream caso o SaveCurrentAccount retorne erro
19.✅ Levar o usuário pra tela de Inicial em caso de sucesso
20.✅ Levar o usuário pra tela de Criar conta