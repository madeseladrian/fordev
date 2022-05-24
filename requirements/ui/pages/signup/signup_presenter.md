# SignUp Presenter

> ## Regras
1. ✅ Chamar Validation ao alterar o nome
2. ✅ Notificar o nameErrorStream com o mesmo erro do Validation, caso retorne erro
3. ✅ Não notificar o nameErrorStream se o valor for igual ao último
4. ✅ Notificar o isFormValidStream após alterar o nome, mas não notificar o isFormValidStream se o valor for igual ao último
5. ✅ Notificar o nameErrorStream com null, caso o Validation não retorne erro
6. ✅ Chamar Validation ao alterar o email
7. ✅ Notificar o emailErrorStream com o mesmo erro do Validation, caso retorne erro
8. ✅ Não notificar o emailErrorStream se o valor for igual ao último
9. ✅ Notificar o isFormValidStream após alterar o email, mas não notificar o isFormValidStream se o valor for igual ao último
10.✅ Notificar o emailErrorStream com null, caso o Validation não retorne erro
11.✅ Chamar Validation ao alterar a senha
12.✅ Notificar o passwordErrorStream com o mesmo erro do Validation, caso retorne error
13.✅ Não notificar o passwordErrorStream se o valor for igual ao último erro
14.✅ Notificar o isFormValidStream após alterar a senha, mas mas não notificar o isFormValidStream se o valor for igual ao último
15.✅ Notificar o passwordErrorStream com null, caso o Validation não retorne erro
16.✅ Chamar Validation ao alterar a confirmação da senha
17. Notificar o passwordConfirmationErrorStream com o mesmo erro do Validation, caso retorne error
18. Não notificar o passwordConfirmationErrorStream se o valor for igual ao último erro
19. Notificar o isFormValidStream após alterar a confirmação da senha, mas mas não notificar o isFormValidStream se o valor for igual ao último
20. Notificar o passwordConfirmationErrorStream com null, caso o Validation não retorne erro
21. Para o formulário estar válido todos os Streams de erro precisam estar null e todos os campos obrigatórios não podem estar vazios
22. Não notificar o isFormValidStream se o valor for igual ao último
23. Chamar o Add Account com os valores corretos
24. Notificar o isLoadingStream como true antes de chamar o Authentication e false no fim do Authentication
25. Notificar o mainErrorStream caso o Add Account retorne erro: UnexpectedError
26. Gravar o Account no cache em caso de sucesso
27. Notificar o mainErrorStream caso o SaveCurrentAccount retorne erro
28. Levar o usuário pra tela de Enquetes em caso de sucesso
29. Levar o usuário pra tela de Login ao clicar no link de voltar para login